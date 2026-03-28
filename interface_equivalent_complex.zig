//! Interface equivalent using compile time interface checking using @hasDecl, see `NOTE`

const std = @import("std");

fn checkInterface(comptime T: type) void {
    comptime {
        if (!@hasDecl(T, "process")) {
            @compileError(@typeName(T) ++ ": missing 'process' method");
        }
        if (!@hasDecl(T, "getData")) {
            @compileError(@typeName(T) ++ ": missing 'getData' method");
        }
        if (!@hasDecl(T, "isValid")) {
            @compileError(@typeName(T) ++ ": missing 'isValid' method");
        }
    }
}

const FileData = struct {
    path: []const u8,
    data: []const u8,

    // NOTE:
    // - Comment below to make error
    pub fn process(self: *FileData) !void {
        std.debug.print("Processing file: {s}\n", .{self.path});
    }
    pub fn getData(self: *const FileData) []const u8 {
        return self.data;
    }
    pub fn isValid(self: *const FileData) bool {
        return self.data.len > 0;
    }
};

const NetworkData = struct {
    url: []const u8,
    buffer: [1024]u8,
    received: usize,

    // NOTE:
    // - Comment below to make error
    pub fn process(self: *NetworkData) !void {
        std.debug.print("Fetching from: {s}\n", .{self.url});
        self.received = 100;
    }
    pub fn getData(self: *const NetworkData) []const u8 {
        return self.buffer[0..self.received];
    }
    pub fn isValid(self: *const NetworkData) bool {
        return self.received > 0;
    }
};

fn handleData(comptime T: type, obj: *T) !void {
    checkInterface(T);

    if (!obj.isValid()) {
        std.debug.print("Invalid data, skipping\n", .{});
        return;
    }

    try obj.process();

    const data = obj.getData();
    std.debug.print("Got {d} bytes\n", .{data.len});
}

pub fn main() !void {
    var file = FileData{
        .path = "test.txt",
        .data = "hello",
    };

    var network = NetworkData{
        .url = "http://example.com",
        .buffer = undefined,
        .received = 0,
    };

    try handleData(FileData, &file);
    try handleData(NetworkData, &network);
}
