import Foundation
import Metal

private struct GPUFamilyDescriptor {
    let displayName: String
    let rawValue: Int
    let note: String?
}

@main
struct MetalGPUFamilyCheckCLI {
    static func main() {
        guard let defaultDevice = MTLCreateSystemDefaultDevice() else {
            fputs("No Metal-compatible GPU found.\n", stderr)
            exit(1)
        }

        let devices: [MTLDevice]
#if os(macOS)
        let discoveredDevices = MTLCopyAllDevices()
        devices = discoveredDevices.isEmpty ? [defaultDevice] : discoveredDevices
#else
        devices = [defaultDevice]
#endif

        print("Metal GPU Family Check\n")
        print("Discovered \(devices.count) Metal device\(devices.count == 1 ? "" : "s").\n")

        for (index, device) in devices.enumerated() {
            let headerSuffix = device.registryID == defaultDevice.registryID ? " (default)" : ""
            print("Device \(index + 1): \(device.name)\(headerSuffix)")

            printDeviceCharacteristics(device)
            printSupportedFamilies(device)
            print("")
        }
    }

    private static func printDeviceCharacteristics(_ device: MTLDevice) {
        var lines: [String] = []

#if os(macOS)
        if #available(macOS 10.13, *) {
            let hexRegistry = String(device.registryID, radix: 16, uppercase: true)
            lines.append("Registry ID: 0x\(hexRegistry)")
        }
#endif

        if #available(macOS 10.11, iOS 10.0, *) {
            lines.append("Headless: \(device.isHeadless ? "yes" : "no")")
        }

#if os(macOS)
        if #available(macOS 10.13, *) {
            lines.append("Low Power: \(device.isLowPower ? "yes" : "no")")
            lines.append("Removable: \(device.isRemovable ? "yes" : "no")")
        }

        if #available(macOS 10.15, *) {
            let sharesDisplay = !(device.isRemovable || device.isHeadless)
            lines.append("Shared with display: \(sharesDisplay ? "yes" : "no")")
        }
#endif

        for line in lines {
            print("  \(line)")
        }
    }

    private static func printSupportedFamilies(_ device: MTLDevice) {
        let knownFamilies = Self.knownFamilies()

        var supported: [String] = []
        var unsupported: [String] = []

        for descriptor in knownFamilies {
            guard let family = MTLGPUFamily(rawValue: descriptor.rawValue) else {
                continue
            }

            if device.supportsFamily(family) {
                let displayText: String
                if let note = descriptor.note {
                    displayText = "\(descriptor.displayName) – \(note)"
                } else {
                    displayText = descriptor.displayName
                }
                supported.append(displayText)
            } else {
                unsupported.append(descriptor.displayName)
            }
        }

        if supported.isEmpty {
            print("  Supported GPU families: none from the known list.")
        } else {
            print("  Supported GPU families:")
            supported.forEach { print("    • \($0)") }
        }

        if !unsupported.isEmpty {
            print("  Unsupported (known) GPU families:")
            unsupported.forEach { print("    • \($0)") }
        }
    }

    private static func knownFamilies() -> [GPUFamilyDescriptor] {
        var families: [GPUFamilyDescriptor] = []

        func add(_ name: String, rawValue: Int, note: String? = nil) {
            families.append(GPUFamilyDescriptor(displayName: name, rawValue: rawValue, note: note))
        }

        add("Apple 1", rawValue: 1001, note: "baseline iOS/tvOS family")
        add("Apple 2", rawValue: 1002)
        add("Apple 3", rawValue: 1003)
        add("Apple 4", rawValue: 1004)
        add("Apple 5", rawValue: 1005)
        add("Apple 6", rawValue: 1006)
        add("Apple 7", rawValue: 1007)
        add("Apple 8", rawValue: 1008)
        add("Apple 9", rawValue: 1009)
        add("Apple 10", rawValue: 1010)

        add("Mac 1", rawValue: 2001, note: "deprecated in favor of Mac 2")
        add("Mac 2", rawValue: 2002)

        add("Common 1", rawValue: 3001)
        add("Common 2", rawValue: 3002)
        add("Common 3", rawValue: 3003)

        add("Mac Catalyst 1", rawValue: 4001, note: "deprecated in favor of Mac 2")
        add("Mac Catalyst 2", rawValue: 4002, note: "deprecated in favor of Mac 2")

        add("Metal 3", rawValue: 5001)
        add("Metal 4", rawValue: 5002, note: "requires macOS 26 or newer")

        return families
    }
}
