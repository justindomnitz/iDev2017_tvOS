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
    @IBOutlet weak var systemButton: UIButton!
    @IBOutlet weak var plainButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let hashtagValue = UserDefaults.standard.value(forKey: "hashtag") as? String {
            hashtag.text = hashtagValue
        }
    }
    
    @IBAction func hashtagEditingDidEnd(_ sender: UITextField) {
        
        UserDefaults.standard.setValue(sender.text, forKey: "hashtag")
        UserDefaults.standard.synchronize()
        NSUbiquitousKeyValueStore.default.set(sender.text, forKey: "hashtag")
    }
    
    @IBAction func saveChanges(_ sender: UIButton) {
        hashtag.resignFirstResponder()
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
