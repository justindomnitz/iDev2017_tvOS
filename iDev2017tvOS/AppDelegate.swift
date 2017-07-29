//
//  AppDelegate.swift
//  iDev2017tvOS
//
//  Created by Justin Domnitz on 7/11/17.
//  Copyright © 2017 Lowyoyo, LLC. All rights reserved.
//

import UIKit
import CloudKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var subscriptionIsLocallyCached = false
    var sharedDBChangeToken: CKServerChangeToken?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        CloudKitUtils.cloudKitSetup(application, subscriptionIsLocallyCached: subscriptionIsLocallyCached) { cachedResult in
            self.subscriptionIsLocallyCached = cachedResult
        }
        iCloudUtils.iCloudSetup()
        return true
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        let dict = userInfo as! [String: NSObject]
        let notification = CKNotification(fromRemoteNotificationDictionary: dict)
        
        if (notification.subscriptionID == "shared-changes") {
            CloudKitUtils.fetchSharedChanges(sharedDBChangeToken: sharedDBChangeToken) { resultToken in
                self.sharedDBChangeToken = resultToken
                completionHandler(UIBackgroundFetchResult.newData)
            }
        }
    }

}

