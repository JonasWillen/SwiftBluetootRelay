//
//  BluetoothRelayApp.swift
//  BluetoothRelay
//
//  Created by Jonas Willén on 2023-04-17.
//

import SwiftUI

@main
struct BluetoothRelayApp: App {
    @StateObject private var theViewModel = BluetoothRelayVM()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(theViewModel)
        }
    }
}
