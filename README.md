# YESBluetoothDeviceManager

YESBluetoothDeviceManager is a tiny package that helps to easily interact with CBPeripheral device.

## Usage

Create class property like that:

```swift
private var manager: YESBluetoothDeviceManager!
```

Instantiate a instance of manager:

```swift
manager = YESBluetoothDeviceManager(deviceUUID: "CC7E9AC0-217F-C067-5979-17214E50727E",
                                    services: ["D06BBD68-5E35-472E-A1AF-1CCBC360ECA7"],
                                    characteristics: ["B9844A6B-ABCF-47D1-AC2F-8F580F79B153"]) { characteristics in
            print(characteristics)
}
```

You can also initialize other parameters of the manager:

```swift
YESBluetoothDeviceManager(deviceUUID: "CC7E9AC0-217F-C067-5979-17214E50727E",
                                  services: ["D06BBD68-5E35-472E-A1AF-1CCBC360ECA7"],
                                  characteristics: ["B9844A6B-ABCF-47D1-AC2F-8F580F79B153"],
                                  scanTimeOut: 10,
           onTurnedOff: {
            print("Peripheral is turned off")
        }, didDiscoverPeripheral: { peripheral in
            print("Peripheral discovered: \(peripheral)")
        }, didFailToDiscoverPeripheral: {
            print("Failed to discover peripheral")
        }, didConnectToPeripheral: { peripheral in
            print("Did Connect To Peripheral: \(peripheral)")
        }, didFailToConnectPeripheral: { peripheral in
            print("Did Fail To Connect To Peripheral: \(peripheral)")
        }, didDisconnectPeripheral: { peripheral in
            print("Did Disconnect From Peripheral: \(peripheral)")
        }, didUpdateCharacteristic: { characteristics in
            print("Did Update Characteristic: \(characteristics)")
        })
```
Use capture lists to avoid retain cycles, i.e.:

```swift
... didUpdateCharacteristic: { [weak self] characteristics in
            self?.update(characteristics)
        }
```

## Installing

### Cocoapods


- Add `pod 'YESBluetoothDeviceManager', '~> 0.2.7'` to your `Podfile` file's dependencies.

## Contributing

- [Open an issue](https://github.com/protspace/YESBluetoothDeviceManager/issues/new) for help, bugs.
- [Open a PR](https://github.com/protspace/YESBluetoothDeviceManager/pull/new/master) for changes.
- Twitter [@protspace on Twitter](https://twitter.com/protspace) for talks.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

