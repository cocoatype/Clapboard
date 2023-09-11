//  Created by Geoff Pado on 9/10/23.
//  Copyright © 2023 Cocoatype, LLC. All rights reserved.

import SwiftUI

struct ContentView: View {
    private let sender = SignalSender()
    private let receiver = SignalReceiver()
    @State var wasTapped = false

    var color: Color {
        (wasTapped ? Color.red : Color.black)
    }

    var body: some View {
        color
            .ignoresSafeArea()
            .onTapGesture {
                flash()
                sender.sendSignal()
            }.task {
                for await _ in receiver.signals {
                    flash()
                }
            }
    }

    func flash() {
        wasTapped = true
        Task {
            try! await Task.sleep(nanoseconds: 33 * NSEC_PER_MSEC)
            await MainActor.run {
                wasTapped = false
            }
        }
    }
}

#Preview {
    ContentView()
}
