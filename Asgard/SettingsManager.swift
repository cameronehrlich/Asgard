//
//  SettingsManager.swift
//  Asgard
//
//  Created by Cameron Ehrlich on 1/14/16.
//  Copyright © 2016 Cameron Ehrlich. All rights reserved.
//

import Foundation

class SettingsManager: NSObject {

    func passwordOnWake(Enabled: Bool) -> Void {
        
        // defaults write com.apple.screensaver askForPasswordDelay 0
        // Needs to get set, but it appears that it only picks up the changes after a login/out 
        
        let enabledString: NSString = Enabled ? "true" : "false"
        let command: String = "tell application \"System Events\" to set " +
                                "require password to wake of security preferences to \(enabledString)"
        
        let task = NSTask()
        task.launchPath = "/usr/bin/osascript"
        task.arguments = ["-e", command]
        
        let pipe = NSPipe()
        task.standardOutput = pipe
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output: String = String(data: data, encoding: NSUTF8StringEncoding)!
        
        print(output)
    }
}