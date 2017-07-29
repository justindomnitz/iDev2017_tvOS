//
//  SettingsViewController.swift
//  iDev2017tvOS
//
//  Created by Justin Domnitz on 7/11/17.
//  Copyright © 2017 Lowyoyo, LLC. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITabBarControllerDelegate {

    @IBOutlet weak var hashtag: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.delegate = self
        
        if let hashtagValue = UserDefaults.standard.value(forKey: "hashtag") as? String {
            hashtag.text = hashtagValue
        }
    }
    
    @IBAction func hashtagEditingDidEnd(_ sender: UITextField) {
        
        UserDefaults.standard.setValue(sender.text, forKey: "hashtag")
        UserDefaults.standard.synchronize()
        
    }

    // MARK - UITabBarControllerDelegate
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        for vc in tabBarController.viewControllers! {
            if let hvc = vc as? HomeViewController {
                hvc.hashtag = hashtag?.text ?? ""
            }
        }
    }
}
