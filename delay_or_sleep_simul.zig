const std = @import("std");

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const time_count = 1;

    std.debug.print("start\n", .{});

    io.sleep(.fromSeconds(time_count), .awake) catch {};

    std.debug.print("finish after {} second\n", .{time_count});
}
