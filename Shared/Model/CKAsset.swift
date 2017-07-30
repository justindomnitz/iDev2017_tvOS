//
//  Model.swift
//  iDev2017tvOS
//
//  Created by Justin Domnitz on 7/11/17.
//  Copyright © 2017 Lowyoyo, LLC. All rights reserved.
//

import CloudKit
import UIKit

extension CKAsset {
    func toUIImage() -> UIImage? {
        if let data = NSData(contentsOf: self.fileURL) {
            return UIImage(data: data as Data)
        }
        return nil
    }
}
