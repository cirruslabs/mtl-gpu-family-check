# mtl-gpu-family-check

Swift Package Manager executable that prints the Metal GPU families supported by the current Mac.

## Requirements
- macOS 10.15 or newer with Metal support
- Xcode command-line tools (for `swift` and Metal headers)

## Running
Execute the CLI directly with SPM:

```bash
swift run mtl-gpu-family-check
```

To build a standalone binary:

```bash
swift build -c release
.build/release/mtl-gpu-family-check
```

## Sample output
```
Metal GPU Family Check

Discovered 1 Metal device.

Device 1: Apple M4 Pro (default)
  Registry ID: 0x100000460
  Headless: no
  Low Power: no
  Removable: no
  Shared with display: yes
  Supported GPU families:
    • Apple 1 – baseline iOS/tvOS family
    • Apple 2
    • Apple 3
    • Apple 4
    • Apple 5
    • Apple 6
    • Apple 7
    • Apple 8
    • Apple 9
    • Mac 1 – deprecated in favor of Mac 2
    • Mac 2
    • Common 1
    • Common 2
    • Common 3
    • Metal 3
    • Metal 4 – requires macOS 26 or newer
  Unsupported (known) GPU families:
    • Apple 10
    • Mac Catalyst 1
    • Mac Catalyst 2
```
