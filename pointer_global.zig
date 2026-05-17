const std = @import("std");

const g = @import("a_global_data.zig");

const Mode = enum(u8) { UNWRAP_ONCE_USE_EVERYWHERE, MOVE_THE_OWNER, WHAT_THE_HELL, _ };

fn unwrapOnceUseEverywhere() !u8 {
    g.pData = try g.newData();
    // Free it later
    defer if (g.pData) |ptr| g.allocator.destroy(ptr);

    // Check once that it's not null
    if (g.pData == null) {
        std.debug.print("Error: g.pData still null", .{});
        return 1;
    }

    // Now use .? to unwrap anywhere (safe because we checked above)
    g.pData.?.num = 0;
    std.debug.print("v: {d}\n", .{g.pData.?.num});

    const nums = [_]i32{ 1, 2, 3, 4, 5 };
    for (nums) |n| {
        g.pData.?.num = n;
        std.debug.print("v: {d}\n", .{g.pData.?.num});
    }

    std.debug.print("finished!\n", .{});
    return 0;
}

fn storeAndUse() !u8 {
    g.pData = try g.newData();

    if (g.pData == null) {
        std.debug.print("Error: g.pData still null", .{});
        return 1;
    }

    // Store the unwrapped pointer in a variable
    var pData: *g.Data = g.pData.?; // but also time bomb

    if (g.pData) |ptr| g.allocator.destroy(ptr);

    // Uncomment bellow to break
    // std.debug.print("\n", .{g.pData.?.num});

    pData.num = 0;
    std.debug.print("v: {d}\n", .{pData.num});

    const nums = [_]i32{ 1, 2, 3, 4, 5 };
    for (nums) |n| {
        pData.num = n;
        std.debug.print("v: {d}\n", .{pData.num});
    }

    std.debug.print("finished!\n", .{});
    return 0;
}

fn notImplemented() !u8 {
    std.debug.print("Hey: not implemented\n", .{});
    return 1;
}

pub fn main() !u8 {
    const mode = Mode.WHAT_THE_HELL;

    return switch (mode) {
        .UNWRAP_ONCE_USE_EVERYWHERE => try unwrapOnceUseEverywhere(),
        .MOVE_THE_OWNER => try storeAndUse(),
        else => try notImplemented(),
    };
}
