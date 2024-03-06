const std = @import("std");
const print = std.debug.print;

pub fn main() !void {
    // 0x1f09017002e002e1fffffffffffffffe05fffe0000000000;
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    const RANDOM: bool = true;

    var data_to_file = try allocator.alloc(u8, 13529688);
    defer allocator.free(data_to_file);
    const rand = std.crypto.random;
    if (RANDOM) {
        for (0..13529688) |i| {
            data_to_file[i] = rand.int(u8);
        }
    } else {
        for (0..563737) |i| {
            const offset: u64 = i * 24;
            data_to_file[offset] = 0x1f;
            data_to_file[offset + 1] = 0x09;
            data_to_file[offset + 1] = 0x01;
            data_to_file[offset + 3] = 0x70;
            data_to_file[offset + 4] = 0x02;
            data_to_file[offset + 5] = 0xe0;
            data_to_file[offset + 6] = 0x02;
            data_to_file[offset + 7] = 0xe1;
            data_to_file[offset + 8] = 0xff;
            data_to_file[offset + 9] = 0xff;
            data_to_file[offset + 10] = 0xff;
            data_to_file[offset + 11] = 0xff;
            data_to_file[offset + 12] = 0xff;
            data_to_file[offset + 13] = 0xff;
            data_to_file[offset + 14] = 0xff;
            data_to_file[offset + 15] = 0xfe;
            data_to_file[offset + 16] = 0x05;
            data_to_file[offset + 17] = 0xff;
            data_to_file[offset + 18] = 0xfe;
            data_to_file[offset + 19] = 0x00;
            data_to_file[offset + 20] = 0x00;
            data_to_file[offset + 21] = 0x00;
            data_to_file[offset + 22] = 0x00;
            data_to_file[offset + 23] = 0x00;
        }
    }
    const stdout = std.io.getStdOut().writer();
    // const stdfile = std.fs.cwd().openFile("all_lines.txt", .{});
    _ = try stdout.write(data_to_file);
}
