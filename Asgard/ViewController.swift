//
//  ViewController.swift
//  Asgard
//
//  Created by Cameron Ehrlich on 1/13/16.
//  Copyright © 2016 Cameron Ehrlich. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, WifiObserver {

    @IBOutlet var ssidField: NSTextField!
    var wifiManager: WifiManager = WifiManager()
    var settingsManager: SettingsManager = SettingsManager()
    
    // Set the SSIDs that you would like to disable the wake from sleep login prompt for
    let ssidsWhiteListed: Array<String> = ["DDW365.45F686-2.4G", "🌚"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wifiManager.delegate = self
        wifiManager.startWifiScanning()
    }
    
    // MARK : WifiObserver
    
    func wifiDidChange(previousNetwork: WifiNetwork, newNetwork: WifiNetwork) {

        let newNetworkName = newNetwork.ssidString
        
        var labelString: String!
        
        let whiteListed = ssidsWhiteListed.contains(newNetworkName)
        if whiteListed {
            settingsManager.passwordOnWake(false)
            labelString = "\(newNetworkName) - Password Disabled"
        }
        else {
            settingsManager.passwordOnWake(true)
            labelString = "\(newNetworkName) - Password Enabled"
        }
        
        // Update UI
        ssidField.stringValue = labelString
    }
}

