//
//  YESBluetoothDeviceManager.swift
//  HVAC_Bosch
//
//  Created by Eugene Sagidulin on 10/24/18.
//  Copyright © 2018 Digicode. All rights reserved.
//

import Foundation
import CoreBluetooth

class YESBluetoothDeviceManager: NSObject {

    var centralManager: CBCentralManager!
    var peripheral: CBPeripheral!

    private let deviceUUID: String?
    private var services: [CBUUID]
    private var characteristics: [CBUUID]
    private let scanTimeOut: Double
    private var onTurnedOff: (() -> Void)?
    private var didDiscoverPeripheral: ((CBPeripheral) -> Void)?
    private var didFailToDiscoverPeripheral: (() -> Void)?
    private var didConnectToPeripheral: ((CBPeripheral) -> Void)?
    private var didFailToConnectPeripheral: ((CBPeripheral) -> Void)?
    private var didDisconnectPeripheral: ((CBPeripheral) -> Void)?
    private var didUpdateCharacteristic: ((CBCharacteristic) -> Void)?

    init(deviceUUID: String?,
         services: [String],
         characteristics: [String],
         scanTimeOut: Double = 10,
         onTurnedOff: (() -> Void)? = nil,
         didDiscoverPeripheral: ((CBPeripheral) -> Void)? = nil,
         didFailToDiscoverPeripheral: (() -> Void)? = nil,
         didConnectToPeripheral: ((CBPeripheral) -> Void)? = nil,
         didFailToConnectPeripheral: ((CBPeripheral) -> Void)? = nil,
         didDisconnectPeripheral: ((CBPeripheral) -> Void)? = nil,
         didUpdateCharacteristic: ((CBCharacteristic) -> Void)? = nil ) {

        self.deviceUUID = deviceUUID
        self.services = services.map { s in (CBUUID(string: s)) }
        self.characteristics = characteristics.map { s in (CBUUID(string: s)) }
        self.scanTimeOut = scanTimeOut
        self.onTurnedOff = onTurnedOff
        self.didDiscoverPeripheral = didDiscoverPeripheral
        self.didFailToDiscoverPeripheral = didFailToDiscoverPeripheral
        self.didDisconnectPeripheral = didDisconnectPeripheral
        self.didUpdateCharacteristic = didUpdateCharacteristic
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func stopScan() {
        centralManager.stopScan()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

    deinit {
        print("⭕️ deiniting YESBluetoothDeviceManager")
    }
}
extension YESBluetoothDeviceManager: CBCentralManagerDelegate {

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("central.state is \(central.state.rawValue)")

        switch central.state {
        case .unknown, .resetting, .unsupported, .unauthorized, .poweredOff:
            onTurnedOff?()
        case .poweredOn:
            print("central.state is .poweredOn")
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
//            if let cachedPeripheral = centralManager.retrievePeripherals(withIdentifiers: [testCBUUID!]).first {
//                peripheral = cachedPeripheral
//                peripheral.delegate = self
//                centralManager.connect(peripheral, options: nil)
//                SVProgressHUD.dismiss()
//                return
//            }
            centralManager.scanForPeripherals(withServices: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + scanTimeOut) {
                guard self.centralManager.isScanning else { return }
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.centralManager.stopScan()
                self.didFailToDiscoverPeripheral?()
            }
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        print(peripheral)
        didDiscoverPeripheral?(peripheral)
        if peripheral.identifier.uuidString == deviceUUID {
            print("discovered peripheral: \(peripheral)")
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            centralManager.stopScan()
            peripheral = peripheral
            peripheral.delegate = self
            guard scalesPeripheral.state == .connected else {
                centralManager.connect(scalesPeripheral, options: nil)
                return
            }
            scalesPeripheral.discoverServices(services)
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        didConnectToPeripheral?(peripheral)
        peripheral.discoverServices(services)
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        didFailToConnectPeripheral?(peripheral)
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        didDisconnectPeripheral?(peripheral)
    }

    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String: Any]) {
        print(dict)
    }
}

// MARK: - CBPeripheralDelegate
extension YESBluetoothDeviceManager: CBPeripheralDelegate {

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }

        for service in services {

            if let _ = self.services.first(where: { $0.uuidString == service.uuid.uuidString }) {
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        print("all characteristics: \(characteristics)")
        for characteristic in characteristics {

            if let _ = self.characteristics.first(where: { $0.uuidString == characteristic.uuid.uuidString }) {
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        didUpdateCharacteristic?(characteristic)
    }
}
