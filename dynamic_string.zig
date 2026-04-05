const std = @import("std");

const template1 =
    \\This is template one
;

const template2 =
    \\This is template two
    \\
    \\with some empty line!
;

const template3 =
    "This is template three\r\n" ++
    "\r\n" ++
    "with some empty line too!";

fn modifyStringByContent1(buffers: *std.ArrayList(u8), allocator: std.mem.Allocator) !void {
    buffers.clearAndFree(allocator);
    try buffers.appendSlice(allocator, template1);
}

fn modifyStringByContent2(buffers: *std.ArrayList(u8), allocator: std.mem.Allocator) !void {
    buffers.clearAndFree(allocator);
    try buffers.appendSlice(allocator, template2);
}

fn modifyStringByContent3(buffers: *std.ArrayList(u8), allocator: std.mem.Allocator) !void {
    buffers.clearAndFree(allocator);
    try buffers.appendSlice(allocator, template3);
}

fn modifyString(buffers: *std.ArrayList(u8), allocator: std.mem.Allocator) !void {
    try buffers.appendSlice(allocator, "Hello, ");
    try buffers.appendSlice(allocator, "World!");
    try buffers.appendSlice(allocator, " from Zig!");
}

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    var dstr = std.ArrayList(u8).empty;
    defer dstr.deinit(allocator);

    std.debug.print("dstr: {s}\n", .{dstr.items});

    try modifyString(&dstr, allocator);
    std.debug.print("dstr: {s}\n", .{dstr.items});

    try modifyStringByContent1(&dstr, allocator);
    std.debug.print("dstr: {s}\n", .{dstr.items});

    try modifyStringByContent2(&dstr, allocator);
    std.debug.print("dstr: {s}\n", .{dstr.items});

    try modifyStringByContent3(&dstr, allocator);
    std.debug.print("dstr: {s}\n", .{dstr.items});
}
