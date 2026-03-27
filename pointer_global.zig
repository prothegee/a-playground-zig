const std = @import("std");

const Data = struct {
    x: i32,
};

var g_pData: ?*Data = null;
var gpa = std.heap.page_allocator;

pub fn main() !void {
    g_pData = try gpa.create(Data);
    // defer _ = g_pData;

    std.debug.print("g_pData created\n", .{});

    if (g_pData) |p| {
        std.debug.print("p.x #1: {d}\n", .{p.x});
        p.x = 69;
        std.debug.print("p.x #2: {d}\n", .{p.x});
    }

    // while(true){}

    std.debug.print("finished!\n", .{});
}
