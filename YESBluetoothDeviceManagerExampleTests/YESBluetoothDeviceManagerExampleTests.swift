//
//  YESBluetoothDeviceManagerExampleTests.swift
//  YESBluetoothDeviceManagerExampleTests
//
//  Created by Yevhen Sahidulin on 12/24/18.
//  Copyright © 2018 Yevhen Sahidulin. All rights reserved.
//

import XCTest
@testable import YESBluetoothDeviceManagerExample

class YESBluetoothDeviceManagerExampleTests: XCTestCase {

    private var manager: YESBluetoothDeviceManager!
    private let deviceUUID = "CC7E9AC0-217F-C067-5979-17214E50727E"
    private let servicesUUID = ["D06BBD68-5E35-472E-A1AF-1CCBC360ECA7"]
    private let characteristicsUUID = ["B9844A6B-ABCF-47D1-AC2F-8F580F79B153"]

    override func tearDown() {
        manager = nil
        super.tearDown()
    }

    func testScalesConnect() {
        let expectation = XCTestExpectation(description: "Connected to BLE")

        manager = YESBluetoothDeviceManager(deviceUUID: deviceUUID,
                                            services: servicesUUID,
                                            characteristics: characteristicsUUID,
                                            scanTimeOut: 10,
                                            onTurnedOff: {
                                                print("Peripheral is turned off")
        }, didDiscoverPeripheral: { peripheral in
            print("Peripheral discovered: \(peripheral)")
        }, didFailToDiscoverPeripheral: {
            print("Failed to discover peripheral")
        }, didConnectToPeripheral: { peripheral in
            print("Did Connect To Peripheral: \(peripheral)")
            expectation.fulfill()
        }, didFailToConnectPeripheral: { peripheral in
            print("Did Fail To Connect To Peripheral: \(peripheral)")
        }, didDisconnectPeripheral: { peripheral in
            print("Did Disconnect From Peripheral: \(peripheral)")
        }, didUpdateCharacteristic: { characteristics in
            print("Did Update Characteristic: \(characteristics)")
        })

        wait(for: [expectation], timeout: 5)
    }

    func testGetCharacteristics() {
        let expectation = XCTestExpectation(description: "Got characteristics from BLE")

        manager = YESBluetoothDeviceManager(deviceUUID: deviceUUID,
                                            services: servicesUUID,
                                            characteristics: characteristicsUUID,
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
            print("------- Did Update Characteristic: \(characteristics)")
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 5)
    }

}
