//  Created by Geoff Pado on 9/10/23.
//  Copyright © 2023 Cocoatype, LLC. All rights reserved.

import CoreBluetooth

class SignalCharacteristic: CBMutableCharacteristic {
    init() {
        super.init(type: Constants.characteristicUUID, properties: [.read, .write, .indicate, .notify], value: nil, permissions: [.readable, .writeable])
    }
}
