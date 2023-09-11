//  Created by Geoff Pado on 9/10/23.
//  Copyright © 2023 Cocoatype, LLC. All rights reserved.

import CoreBluetooth

class SignalService: CBMutableService {
    let characteristic = SignalCharacteristic()
    init() {
        super.init(type: Constants.serviceUUID, primary: true)
        characteristics = [characteristic]
    }
}
