//
//  BluetoothConnect.swift
//  BluetoothRelay
//
//  Created by Jonas Willén on 2023-04-18.
//


import Foundation
import CoreBluetooth

class BluetoothConnect: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    var centralManager: CBCentralManager!
    var peripheralBLE: CBPeripheral!
    
    let GATTService = CBUUID(string: "0xFFE0")
    let GATTCommand = CBUUID(string: "0xFFE1")
    var toogle: UInt8 = 1
    
    var characteristicBLE: CBCharacteristic!
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
          case .unknown:
            print("central.state is .unknown")
          case .resetting:
            print("central.state is .resetting")
          case .unsupported:
            print("central.state is .unsupported")
          case .unauthorized:
            print("central.state is .unauthorized")
          case .poweredOff:
            print("central.state is .poweredOff")
          case .poweredOn:
            print("central.state is .poweredOn")
            centralManager.scanForPeripherals(withServices: nil)
        @unknown default:
            print("unknown")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("didDiscover")
        
        if let name = peripheral.name, name.contains("Bee-BLE"){
            print("Found Relay")
            peripheralBLE = peripheral
            peripheralBLE.delegate = self
            centralManager.connect(peripheralBLE)
            central.stopScan()
            
    
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
            print("didConnect")
           peripheral.discoverServices(nil)
           central.scanForPeripherals(withServices: [GATTService], options: nil)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
         for service in peripheral.services!{
             print("Service Found")
             peripheral.discoverCharacteristics([GATTCommand], for: service)
         }
     }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("didDiscoverCharacteristics")
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            if characteristic.uuid == GATTCommand{
                print("Command")
                characteristicBLE = characteristic
                // Write in the password 123456
                
                
                let parameter:[UInt8] = [0x3F, 0x40, 0xE2, 0x01]
          
                let data = NSData(bytes: parameter, length: 4)
        
                peripheral.writeValue(data as Data, for: characteristic, type: CBCharacteristicWriteType.withResponse)
                
                
                
               
                
                

                
            }
        }
    }
    
   
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic,
                    error: Error?) {
        print("New data")
        let data = characteristic.value
        var byteArray: [UInt8] = []
        for i in data! {
            let n : UInt8 = i
            byteArray.append(n)
        }
        
        print(byteArray)
        
    
            
        }
    
    
    override init(){
        super.init()
    }
    
    func start(){
        print("centralManager")
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func toogleRelay(){
        if(toogle == 1){
            // [0X66 för andra relät]
            let parameter:[UInt8] = [0x65]
            
            let data = NSData(bytes: parameter, length: 1)
            
            peripheralBLE.writeValue(data as Data, for: characteristicBLE, type: CBCharacteristicWriteType.withResponse)
            
            toogle = 2
        }else {
            // [0x70 för andra relät]
            let parameter:[UInt8] = [0x6F]
            
            let data = NSData(bytes: parameter, length: 1)
            
            peripheralBLE.writeValue(data as Data, for: characteristicBLE, type: CBCharacteristicWriteType.withResponse)
            
            toogle = 1
        }
    }
    
    
    
}
