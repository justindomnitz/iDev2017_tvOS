//
//  DashboardViewController.swift
//  iDev2017_tvOS
//
//  Created by Justin Domnitz on 7/11/17.
//  Copyright © 2017 Lowyoyo, LLC. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Collection View
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dashboardCollectionCell", for: indexPath) as? DashboardCollectionViewCell {
            
            cell.backgroundColor = UIColor.brown
            cell.number.text = "\(indexPath.row)"
            
            //UIWebView Hack
            let webViewClass : AnyObject.Type = NSClassFromString("UIWebView")!
            let webViewObject : NSObject.Type = webViewClass as! NSObject.Type
            let webview: AnyObject = webViewObject.init()
            let url = URL(string: "https://www.google.com/")
            let request = URLRequest(url: url!)
            webview.loadRequest(request)
            let uiview = webview as! UIView
            uiview.frame = CGRect(x: 0, y: 0, width: cell.webDashboardView.frame.width, height: cell.webDashboardView.frame.height)
            cell.webDashboardView.addSubview(uiview)
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    }
    
    // MARK: - UIFocusEnvironment
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)
        
        if let previousItem = context.previouslyFocusedView as? DashboardCollectionViewCell {
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                previousItem.backgroundColor = UIColor.brown
            })
        }
        if let nextItem = context.nextFocusedView as? DashboardCollectionViewCell {
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                nextItem.backgroundColor = UIColor(red: 51 / 100, green: 67 / 100, blue: 49 / 100, alpha: 0.8)
            })
        }
    }

}
