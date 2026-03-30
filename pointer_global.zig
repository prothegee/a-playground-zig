const std = @import("std");

const g = @import("a_global_data.zig");

pub fn main() !u8 {
    g.pData = try g.newData();
    defer _ = g.pData;

    const nums = [_]i32 {1,2,3,4,5};

    // std.debug.print("g_pData created\n", .{});
    if (g.pData == null) {
        std.debug.print("Error: g.pData still null", .{});
        return 1;
    }

    if (g.pData) |v| {
        std.debug.print("v: {any}\n", .{v.num});

        for (nums) |n| {
            v.num = n;
            std.debug.print("v: {any}\n", .{v.num});
        }

        v.num = 6;
    }

    if (g.pData) |v| {
        std.debug.print("v: {any}\n", .{v.num});
    }

    // So how do I modified that data pointer outside/without the statement?

    std.debug.print("finished!\n", .{});

    return 0;
}
