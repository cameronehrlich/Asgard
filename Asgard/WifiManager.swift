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
    let ssidData: Data!
}

func ==(lhs: WifiNetwork, rhs: WifiNetwork) -> Bool {
    return lhs.ssidString == rhs.ssidString && lhs.ssidData == rhs.ssidData
}

protocol WifiObserver {
    func wifiDidChange(_ previousNetwork: WifiNetwork, newNetwork: WifiNetwork)
}

class WifiManager: NSObject {
    
    var delegate: WifiObserver?
    
    fileprivate let wifiScanInterval :TimeInterval = 2;
    fileprivate let wifiInterface = CWWiFiClient.shared().interface()
    fileprivate var scanningTimer: Timer!
    
    fileprivate var previousNetwork: WifiNetwork!
    fileprivate var currentNetwork: WifiNetwork!
    
    override init() {
        super.init()
        scanningTimer = Timer(timeInterval: wifiScanInterval, target: self, selector: #selector(WifiManager.checkSSID), userInfo: nil, repeats: true)
    }
    
    func startWifiScanning() {
        RunLoop.main.add(scanningTimer, forMode: RunLoopMode.commonModes)
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
