const std = @import("std");

const IP: []const u8 = "127.0.0.1";
const PORT: u16 = 8080;
const MAX_KERNEL_BACKLOG: usize = 1024 * 4;
const MAX_CLIENT_REQUEST: usize = 1024 * 4;
const MAX_CLIENT_RESPONSE: usize = 1024 * 4;

// --------------------------------------------------------- //

fn handlers(io: std.Io, stream: std.Io.net.Stream) void {
    defer stream.close(io);

    var buf_read: [MAX_CLIENT_REQUEST]u8 = undefined;
    var buf_write: [MAX_CLIENT_RESPONSE]u8 = undefined;

    var read = stream.reader(io, &buf_read);
    var write = stream.writer(io, &buf_write);

    var server = std.http.Server.init(&read.interface, &write.interface);

    var keep_alive = true;
    while (keep_alive) {
        var req = server.receiveHead() catch |err| {
            if (err == error.HttpConnectionClosing) break;
            if (err == error.ConnectionResetByPeer) break;
            std.debug.print("Error: receive head: {}\n", .{err});
            break;
        };

        keep_alive = req.head.keep_alive;

        var path = if (std.mem.indexOfScalar(u8, req.head.target, '?')) |pos|
            req.head.target[0..pos]
        else
            req.head.target;
        if (path.len == 0) path = "/";

        const response_body: []const u8 =
            if (std.mem.eql(u8, path, "/"))
                if (req.head.method == .GET)
                    "OK"
                else
                    "Method Not Allowed"
            else
                "Not Found";

        const status: std.http.Status =
            if (std.mem.eql(u8, path, "/") and req.head.method == .GET)
                .ok
            else if (std.mem.eql(u8, path, "/"))
                .method_not_allowed
            else
                .not_found;

        req.respond(response_body, .{
            .status = status,
            .extra_headers = &.{
                .{ .name = "Content-Type", .value = "text/plain" },
            },
            .keep_alive = keep_alive,
        }) catch |err| {
            std.debug.print("Error: respond error: {}\n", .{err});
            break;
        };
    }
}

// --------------------------------------------------------- //

const HttpServer = struct {
    io: std.Io,
    ip: []const u8,
    port: u16,
    net_server: std.Io.net.Server,
    is_running: bool,

    pub fn init(io: std.Io, ip: []const u8, port: u16) !HttpServer {
        var address = try std.Io.net.IpAddress.resolve(io, ip, port);
        const net_server = try address.listen(io, .{
            .mode = .stream,
            .protocol = .tcp,
            .reuse_address = true,
            .kernel_backlog = MAX_KERNEL_BACKLOG,
        });
        return .{
            .io = io,
            .ip = ip,
            .port = port,
            .net_server = net_server,
            .is_running = false,
        };
    }

    pub fn deinit(self: *HttpServer) void {
        self.is_running = false;
        self.net_server.deinit(self.io);
    }

    pub fn run(self: *HttpServer) !void {
        if (@import("builtin").mode == .Debug) {
            std.debug.print("DEBUG MODE\n", .{});
        }
        std.debug.print("HttpServer running: {s}:{d}\n", .{ self.ip, self.port });
        defer self.net_server.deinit(self.io);

        self.is_running = true;
        while (self.is_running) {
            const stream = self.net_server.accept(self.io) catch |err| {
                std.debug.print("Error: accept loop: {}\n", .{err});
                continue;
            };
            handlers(self.io, stream);
        }
    }
};

// --------------------------------------------------------- //

pub fn main(process: std.process.Init) !void {
    const io = process.io;
    var server = try HttpServer.init(io, IP, PORT);
    defer server.deinit();
    try server.run();
}
