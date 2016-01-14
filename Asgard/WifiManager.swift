//
//  ViewController.swift
//  Asgard
//
//  Created by Cameron Ehrlich on 1/13/16.
//  Copyright © 2016 Cameron Ehrlich. All rights reserved.
//

import Foundation
import CoreWLAN

struct WifiNetwork: Equatable {
    let ssidString: String!
    let ssidData: NSData!
}

func ==(lhs: WifiNetwork, rhs: WifiNetwork) -> Bool {
    return lhs.ssidString == rhs.ssidString && lhs.ssidData.isEqualToData(rhs.ssidData)
}

protocol WifiObserver {
    func wifiDidChange(previousNetwork: WifiNetwork, newNetwork: WifiNetwork)
}

class WifiManager: NSObject {
    
    var delegate: WifiObserver?
    
    private let wifiScanInterval :NSTimeInterval = 2;
    private let wifiInterface = CWWiFiClient.sharedWiFiClient().interface()
    private var scanningTimer: NSTimer!
    
    private var previousNetwork: WifiNetwork!
    private var currentNetwork: WifiNetwork!
    
    override init() {
        super.init()
        scanningTimer = NSTimer(timeInterval: wifiScanInterval, target: self, selector: Selector("checkSSID"), userInfo: nil, repeats: true)
    }
    
    func startWifiScanning() {
        NSRunLoop.mainRunLoop().addTimer(scanningTimer, forMode: NSRunLoopCommonModes)
    }
    
    func stopWifiScanning() {
        scanningTimer.invalidate()
    }
    
    internal func checkSSID() {
        if wifiInterface?.powerOn() == true {
            
            if (previousNetwork == nil) {
                if let interface = wifiInterface {
                    let network = WifiNetwork.init(ssidString: interface.ssid()!, ssidData: interface.ssidData()!)
                    previousNetwork = network
                    currentNetwork = network
                    delegate?.wifiDidChange(previousNetwork, newNetwork: currentNetwork)
                }
                return;
            }
            
            if let interface = wifiInterface {
                currentNetwork = WifiNetwork.init(ssidString: interface.ssid(), ssidData: interface.ssidData())
                if (previousNetwork != currentNetwork) {
                    delegate?.wifiDidChange(previousNetwork, newNetwork: currentNetwork)
                    previousNetwork = currentNetwork
                }
            }
        }
    }
    
    func currentWifiNetwork() -> WifiNetwork? {
        return currentNetwork
    }
}
