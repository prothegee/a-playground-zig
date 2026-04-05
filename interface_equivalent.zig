//! Interface equivalent using simple generic with anytype comptime

const std = @import("std");

const Data = struct {
    x: i32,
    y: i32,
    z: i32,

    pub fn getX(self: *const Data) i32 {
        return self.x;
    } // Comment here to make the fail
    pub fn getY(self: *const Data) i32 {
        return self.y;
    }
    pub fn getZ(self: *const Data) i32 {
        return self.z;
    }
};

fn processData(obj_ptr: anytype) !void {
    comptime {
        const T = @TypeOf(obj_ptr);
        const BaseT = @typeInfo(T).pointer.child;

        if (!@hasDecl(BaseT, "getX")) {
            @compileError("Missing getX method");
        }
        if (!@hasDecl(BaseT, "getY")) {
            @compileError("Missing getY method");
        }
        if (!@hasDecl(BaseT, "getZ")) {
            @compileError("Missing getZ method");
        }
    }

    std.debug.print("Data: {d}, {d}, {d}\n", .{
        obj_ptr.getX(), // Comment here to make the fail
        obj_ptr.getY(),
        obj_ptr.getZ(),
    });
}

pub fn main() !void {
    var data = Data{ .x = 1, .y = 2, .z = 3 };

    try processData(&data);
}
