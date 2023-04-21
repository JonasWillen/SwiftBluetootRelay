//
//  ContentView.swift
//  BluetoothRelay
//
//  Created by Jonas Willén on 2023-04-17.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var theViewModel : BluetoothRelayVM
    
    var body: some View {
        VStack {
            Text("Bluetooth Relay!")
            Button{theViewModel.initBluetooth()} label: {
                Text("Connect")
            }
            Button{theViewModel.toogleRelay()} label: {
                Text("Toogle Relay")
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(BluetoothRelayVM())
    }
}
