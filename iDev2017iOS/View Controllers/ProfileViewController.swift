//
//  ProfileViewController.swift
//  iDev2017iOS
//
//  Created by Justin Domnitz on 7/30/17.
//  Copyright © 2017 Lowyoyo, LLC. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices

class ProfileViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        //Clear the profile image.
        self.imageView.image = nil
        
        CloudKitUtils.fetchProfilePhoto() { photo, error in
            
            if let error = error {
                //to do  - error handling
                print(error.debugDescription)
                self.imageView.contentMode = .center
                self.imageView.image = UIImage(named: "ic_not_interested_black_48dp")
            } else {
                //Set the profile image we recieved from CloudKit.
                self.imageView.image = photo
            }
            
        }
    }
    
    @IBAction func editPhoto(_ sender: Any) {
        let _ = startMediaBrowserFromViewController(controller: self, delegate: self, addEditOptionsFlag: true)
    }
    
    func startMediaBrowserFromViewController(controller: UIViewController?, delegate: AnyObject?, addEditOptionsFlag: Bool = false ) -> Bool {
        if controller == nil || delegate == nil ||
            //Verify our passed in delegate conforms to the required protocols.
            delegate as? UIImagePickerControllerDelegate & UINavigationControllerDelegate == nil
        {
            return false
        }
        
        let mediaUI = UIImagePickerController()
        
        // Hides the controls for moving & scaling pictures, or for
        // trimming movies. To instead show the controls, use YES.
        mediaUI.allowsEditing = false
        
        mediaUI.delegate = (delegate as! UIImagePickerControllerDelegate & UINavigationControllerDelegate)
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        //Setting the popoverPresentationController values is required for iPad support.
        alert.popoverPresentationController?.sourceView = view
        alert.popoverPresentationController?.sourceRect = CGRect(x: editButton.center.x,
                                                                 y: editButton.center.y,
                                                                 width: 1,
                                                                 height: 1)
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            alert.addAction(UIAlertAction(title: "Choose Photo", style: .destructive) { action in
                self.photoLibraryAccess() { access in
                    if access {
                        mediaUI.sourceType = .photoLibrary
                        mediaUI.mediaTypes = [kUTTypeImage as String] //Only support photos, no videos.
                        self.present(mediaUI, animated: true, completion: nil)
                    }
                }
            })
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
        
        return true
    }
    
    func photoLibraryAccess( completion: @escaping (_ access: Bool) -> Void) {
        //Check to see if we have permission to the photo library.
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            completion(true)
        case .denied, .restricted:
            //Error handling
            completion(false)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization() { access in
                if access != .authorized {
                    //Error handling
                    completion(false)
                }
                else {
                    completion(true)
                }
            }
        }
    }

}

extension ProfileViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        if info[UIImagePickerControllerMediaType] as! String == (kUTTypeImage as String) {
            if let image = (info[UIImagePickerControllerEditedImage] as? UIImage) ??
                           (info[UIImagePickerControllerOriginalImage] as? UIImage) ?? nil {
                imageView.image = image
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
