//  Created by Geoff Pado on 9/10/23.
//  Copyright © 2023 Cocoatype, LLC. All rights reserved.

import CoreBluetooth
import OSLog

class SignalSender: NSObject, CBPeripheralManagerDelegate {
    private let peripheralManager: CBPeripheralManager

    override init() {
        peripheralManager = CBPeripheralManager()
        super.init()
        peripheralManager.delegate = self
    }

    func sendSignal() {
        let timestamp = withUnsafeBytes(of: Date()) { Data($0) }
        peripheralManager.updateValue(timestamp, for: service.characteristic, onSubscribedCentrals: nil)
    }

    // MARK: CBPeripheralManagerDelegate

    private let service = SignalService()
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        os_log(.debug, "got new peripheral state: %@", String(describing: peripheral.state))

        if peripheral.state == .poweredOn {
            peripheral.add(service)
            peripheral.startAdvertising([
                CBAdvertisementDataServiceUUIDsKey: [service.uuid]
            ])
        }
    }

    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        peripheral.setDesiredConnectionLatency(.low, for: central)
    }
}

