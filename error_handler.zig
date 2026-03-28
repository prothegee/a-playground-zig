const std = @import("std");

const ErrorMain = error{
    ERROR_FINE,
    ERROR_SOMETHING_ELSE,
};

fn errHandlerVoid(i: i32) ErrorMain!void {
    if (i == 1) {
        return ErrorMain.ERROR_FINE;
    }

    if (i > 1) {
        return ErrorMain.ERROR_SOMETHING_ELSE;
    }

    std.debug.print("continue for {}\n", .{i});
}

const ErrorBool = error{
    ERROR_LEFT,
    ERROR_RIGHT,
};

// we're looking 0
// only true when i is 0
fn errHandlerBool(i:i32) ErrorBool!bool {
    if (i < 0) {
        return ErrorBool.ERROR_LEFT;
    }
    if (i > 0) {
        return ErrorBool.ERROR_RIGHT;
    }

    return true;
}

pub fn main() !void {
    // The try & catch are seperate mechanism

    // Locally handling
    // better for full-control handling
    {
        errHandlerVoid(0) catch |e| {
            std.debug.print("Error: {} for 0\n", .{e});
        };
        errHandlerVoid(1) catch |e| {
            std.debug.print("Error: {} for 1\n", .{e});
        };
        errHandlerVoid(2) catch |e| {
            std.debug.print("Error: {} for >= 2\n", .{e});
        };
    }
    // Propagate handling
    // cause
    {
        try errHandlerVoid(0); // Will passed

        // try errHandlerVoid(1); // Error goes to the called

        errHandlerVoid(1) catch {}; // Catch but not handled, silent

        // // Uncomment below to see the effect
        // try errHandlerVoid(2); // Error provided, but will not continue
        //                        // compiled als passed
    }
    std.debug.print("lvl 1 passed!\n", .{});
}
