const std = @import("std");

pub fn main(init: std.process.Init) !void {
    const cwd = std.Io.Dir.cwd();
    const file = try cwd.createFile(init.io, "foo.bak.txt", .{ .read = true });
    defer file.close(init.io);
    _ = try file.writePositionalAll(
        init.io, "File from:\nfoo.bak.txt", 0
    );

    var buffer: [300]u8 = undefined;
    @memset(buffer[0..], 0);

    var read_buffer: [1024]u8 = undefined;
    var fr = file.reader(init.io, &read_buffer);
    var reader = &fr.interface;

    _ = reader.readSliceAll(buffer[0..]) catch 0;

    std.debug.print("file_write:\n{s}", .{buffer});
}
