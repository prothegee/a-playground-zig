Zig Optimize Mode

Zig provides four optimization modes that balance performance, safety, and binary size. The available modes are **Debug**, **ReleaseSafe**, **ReleaseFast**, and **ReleaseSmall**.

| Mode | Optimizations | Runtime Safety Checks | Best Use Case |
| :--- | :--- | :--- | :--- |
| **Debug** | Disabled | Enabled | Development and debugging. |
| **ReleaseSafe** | Yes (e.g., -O3) | Enabled | General releases where safety is critical. |
| **ReleaseFast** | Yes (Aggressive) | Disabled | High-performance applications like games. |
| **ReleaseSmall** | Yes (Size-focused) | Disabled | Embedded systems or size-constrained environments. |

These modes are configured in the build system using `b.standardOptimizeOption({})` in the `build.zig` file, which exposes the `-Doptimize` flag. Users can select a mode via the command line (e.g., `zig build -Doptimize=ReleaseFast`) or by hardcoding the enum value (e.g., `.optimize = .ReleaseFast`) in the executable or library definition.
