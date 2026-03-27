const std = @import("std");

const Struct1 = struct {
    some_bool: bool,
    some_number: i32,
};

const Struct2 = struct {
    // nothing here

    pub fn getZero() i32 { return 0; }
};

const Efoo = enum {
    UNDEFINED,
};
const Ebar = enum(u8) {
    UNDEFINED,
};

pub fn main() !void {
    std.debug.print("# check_sizeof.zign\n", .{});
    std.debug.print("Struct1  : {d}\n", .{@sizeOf(Struct1)});
    std.debug.print("Struct1* : {d}\n", .{@sizeOf(*Struct1)});
    std.debug.print("Struct2  : {d}\n", .{@sizeOf(Struct2)});
    std.debug.print("Struct2* : {d}\n", .{@sizeOf(*Struct2)});

    std.debug.print("Efoo     : {d}\n", .{@sizeOf(Efoo)});
    std.debug.print("Efoo*    : {d}\n", .{@sizeOf(*Efoo)});
    std.debug.print("Ebar     : {d}\n", .{@sizeOf(Ebar)});
    std.debug.print("Ebar*    : {d}\n", .{@sizeOf(*Ebar)});

    std.debug.print("u8       : {d}\n", .{@sizeOf(u8)});
    std.debug.print("u8 max   : {d}\n", .{std.math.maxInt(u8)});
    std.debug.print("u9       : {d}\n", .{@sizeOf(u9)});
    std.debug.print("u9 max   : {d}\n", .{std.math.maxInt(u9)});
    std.debug.print("u10      : {d}\n", .{@sizeOf(u10)});
    std.debug.print("u10 max  : {d}\n", .{std.math.maxInt(u10)});
    std.debug.print("u16      : {d}\n", .{@sizeOf(u16)});
    std.debug.print("u16 max  : {d}\n", .{std.math.maxInt(u16)});
}
