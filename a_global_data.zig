//! This file represent a global data for this repo,
//! any object that will be access from "somewhere" stored here
//!
const std = @import("std");

pub const Data = struct {
    num: i32,
};

pub var pData: ?*Data = null;
pub const allocator = std.heap.smp_allocator;

/// Create new data of Data
pub fn newData() !*Data {
    return try allocator.create(Data);
}

// Any other way tho?
