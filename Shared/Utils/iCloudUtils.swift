//
//  iCloudUtils.swift
//  iDev2017tvOS
//
//  Created by Justin Domnitz on 7/29/17.
//  Copyright © 2017 Lowyoyo, LLC. All rights reserved.
//

import UIKit

class iCloudUtils {

    //MARK: iCloud Key-Value Store
    
    static func iCloudSetup() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(storeDidChange),
                                               name: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
                                               object: NSUbiquitousKeyValueStore.default)
        NSUbiquitousKeyValueStore.default.synchronize()
    }
    
    @objc private func storeDidChange() {
        
    }
    
}
