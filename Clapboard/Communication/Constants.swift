//  Created by Geoff Pado on 9/10/23.
//  Copyright © 2023 Cocoatype, LLC. All rights reserved.

import CoreBluetooth

enum Constants {
    static let characteristicUUIDString = "EC4D82F7-4370-4D2F-AC05-563766CACBD8"
    static let characteristicUUID = CBUUID(string: characteristicUUIDString)
    static let serviceUUIDString = "67F16D64-393A-4FA5-924A-82304D897A92"
    static let serviceUUID = CBUUID(string: serviceUUIDString)
}
