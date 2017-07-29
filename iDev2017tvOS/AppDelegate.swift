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
        cloudKitSetup(application)
        return true
    }
    
    //MARK: CloudKit
    
    private func cloudKitSetup(_ application: UIApplication) {
        if subscriptionIsLocallyCached { return }
        
        let subscription = CKDatabaseSubscription(subscriptionID: "shared-changes")
        
        let notificationInfo = CKNotificationInfo()
        notificationInfo.shouldSendContentAvailable = true
        subscription.notificationInfo = notificationInfo
        
        application.registerForRemoteNotifications()
        
        let operation = CKModifySubscriptionsOperation(subscriptionsToSave: [subscription], subscriptionIDsToDelete: [])
        operation.modifySubscriptionsCompletionBlock = { subscription, messages, error in
            if error != nil { } // Handle the error
            else { self.subscriptionIsLocallyCached = true }
        }
        
        operation.qualityOfService = .utility
        //self.shareDB.add(operation) //to do
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        let dict = userInfo as! [String: NSObject]
        let notification = CKNotification(fromRemoteNotificationDictionary: dict)
        
        if (notification.subscriptionID == "shared-changes") {
            fetchSharedChanges {
                completionHandler(UIBackgroundFetchResult.newData)
            }
        }
    }
    
    func fetchSharedChanges(_ callback: @escaping () -> Void) {
        let changesOperation = CKFetchDatabaseChangesOperation(previousServerChangeToken: sharedDBChangeToken) //previously cached
        
        changesOperation.fetchAllChanges = true
        changesOperation.recordZoneWithIDChangedBlock = { zoneId in /* to do */ } // collect zone IDs.
        changesOperation.recordZoneWithIDWasDeletedBlock = { zoneId in /* to do */ } //delete local cache
        changesOperation.changeTokenUpdatedBlock = { zoneId in /* to do */ } //delete local cache
        
        changesOperation.fetchDatabaseChangesCompletionBlock = {
            (newToken, more, error) in
            //error handling here
            self.sharedDBChangeToken = newToken!
            self.fetchSharedChanges {
                //to do - callback //using CKFetchRecordZoneChangesOperation
            }
        }
        //self.shareDB.add(changesOperation) to do
    }

}

