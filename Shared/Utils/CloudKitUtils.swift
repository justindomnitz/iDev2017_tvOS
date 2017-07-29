//
//  CloudKitUtils.swift
//  iDev2017tvOS
//
//  Created by Justin Domnitz on 7/29/17.
//  Copyright © 2017 Lowyoyo, LLC. All rights reserved.
//

import UIKit
import CloudKit

class CloudKitUtils {

    //MARK: CloudKit
    
    static func cloudKitSetup(_ application: UIApplication, subscriptionIsLocallyCached: Bool, _ callback: @escaping (Bool) -> Void) {
        if subscriptionIsLocallyCached { callback(true) }
        
        let subscription = CKDatabaseSubscription(subscriptionID: "shared-changes")
        
        let notificationInfo = CKNotificationInfo()
        notificationInfo.shouldSendContentAvailable = true
        subscription.notificationInfo = notificationInfo
        
        application.registerForRemoteNotifications()
        
        let operation = CKModifySubscriptionsOperation(subscriptionsToSave: [subscription], subscriptionIDsToDelete: [])
        operation.modifySubscriptionsCompletionBlock = { subscription, messages, error in
            if error != nil { } // Handle the error
            else { callback(true) }
        }
        
        operation.qualityOfService = .utility
        //self.shareDB.add(operation) //to do
    }
    
    static func fetchSharedChanges(sharedDBChangeToken: CKServerChangeToken?, _ callback: @escaping (CKServerChangeToken?) -> Void) {
        let changesOperation = CKFetchDatabaseChangesOperation(previousServerChangeToken: sharedDBChangeToken) //previously cached
        
        changesOperation.fetchAllChanges = true
        changesOperation.recordZoneWithIDChangedBlock = { zoneId in /* to do */ } // collect zone IDs.
        changesOperation.recordZoneWithIDWasDeletedBlock = { zoneId in /* to do */ } //delete local cache
        changesOperation.changeTokenUpdatedBlock = { zoneId in /* to do */ } //delete local cache
        
        changesOperation.fetchDatabaseChangesCompletionBlock = {
            (newToken, more, error) in
            //error handling here
            callback(newToken)
            self.fetchSharedChanges(sharedDBChangeToken: sharedDBChangeToken) { sharedDBChangeToken in
                //to do - callback //using CKFetchRecordZoneChangesOperation
                callback(sharedDBChangeToken)
            }
        }
        //self.shareDB.add(changesOperation) to do
    }
}
