//
//  DashboardViewController.swift
//  iDev2017tvOS
//
//  Created by Justin Domnitz on 7/11/17.
//  Copyright © 2017 Lowyoyo, LLC. All rights reserved.
//

import UIKit

class FocusableUIView: UIView {
    override var canBecomeFocused: Bool {
        return true
    }
}

class ProfileViewController: UIViewController {

    @IBOutlet weak var focusableUIView: FocusableUIView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.adjustsImageWhenAncestorFocused = true
        imageView.clipsToBounds = false
    }
    
    // MARK: - UIFocusEnvironment
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)
        
        // to do - do any animations you want when focusableUIView recieves focus
        
    }

}