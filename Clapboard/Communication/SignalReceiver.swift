//  Created by Geoff Pado on 9/10/23.
//  Copyright © 2023 Cocoatype, LLC. All rights reserved.

import CoreBluetooth
import OSLog

class SignalReceiver: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    private let centralManager: CBCentralManager
    let signals: AsyncStream<Void>
    private let continuation: AsyncStream<Void>.Continuation
    override init() {
        (signals, continuation) = AsyncStream.makeStream(of: Void.self)
        centralManager = CBCentralManager()
        super.init()
        centralManager.delegate = self

    }

    // MARK: CBCentralManagerDelegate

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        os_log(.debug, "got new central state: %@", String(describing: central.state))
        if central.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: [Constants.serviceUUID])
        }
    }

    private var discoveredPeripherals = [CBPeripheral]()
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        os_log(.debug, "discovered peripheral: %@", String(describing: peripheral))
        discoveredPeripherals.append(peripheral)
        central.connect(peripheral)
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        os_log(.debug, "connected peripheral: %@", String(describing: peripheral))
        peripheral.delegate = self
        peripheral.discoverServices([Constants.serviceUUID])
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let service = peripheral.services?.first(where: { $0.isPrimary }) else {
            os_log(.error, "failed to find service with error: %@", String(describing: error))
            return
        }
        os_log(.debug, "discovered service: %@", String(describing: service))
        peripheral.discoverCharacteristics([Constants.characteristicUUID], for: service)
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristic = service.characteristics?.first else {
            os_log(.error, "failed to find characteristic with error: %@", String(describing: error))
            return
        }
        os_log(.debug, "discovered characteristic: %@", String(describing: characteristic))
        peripheral.setNotifyValue(true, for: characteristic)
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        os_log(.debug, "did update value for characteristic: %@", String(describing: characteristic))
        continuation.yield()
    }
}
