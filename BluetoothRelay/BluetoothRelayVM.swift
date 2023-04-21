//
//  BluetoothRelayVM.swift
//  BluetoothRelay
//
//  Created by Jonas Willén on 2023-04-17.
//


import Foundation
import CoreBluetooth

class BluetoothRelayVM :  ObservableObject {
    let BLEConnect = BluetoothConnect()

    
    func initBluetooth(){
        print("Start")
        BLEConnect.start()
    }
    
    func toogleRelay(){
        BLEConnect.toogleRelay()
    }
}


