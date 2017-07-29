//
//  HomeViewController.swift
//  iDev2017tvOS
//
//  Created by Justin Domnitz on 7/11/17.
//  Copyright © 2017 Lowyoyo, LLC. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var twitterTableView: UITableView!
    
    var tweets = [[Tweet]]()
    var hashtag = "360idev"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let value = UserDefaults.standard.value(forKey: "hashtag") as? String {
            hashtag = value
        }
        
        //Table View
        twitterTableView.delegate = self
        twitterTableView.dataSource = self
        
        //Collection View
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        getTwitterData()
    }
    
    func getTwitterData() {
        TwitterInterface().requestTwitterSearchResults(hashtag, completion: { (tweets, error) -> Void in
            //TO-DO: Error handling.
            if error == nil {
                DispatchQueue.main.async(execute: {
                    self.tweets.insert(tweets!, at: 0)
                    self.twitterTableView.reloadData()
                })
            }
        })
    }

    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numRows = 0
        if tweets.count > section {
            numRows = tweets[section].count
        }
        return numRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TwitterCell", for: indexPath) as? TweetTableViewCell {
            
            cell.tweet = tweets[indexPath.section][indexPath.row]
            
            return cell
        }
    
        return UITableViewCell()
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCollectionCell", for: indexPath) as? HomeCollectionViewCell {
            
            cell.backgroundColor = UIColor.brown
            cell.number.text = "\(indexPath.row)"
            
            return cell
        }
    
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    }
    
    // MARK: - UIFocusEnvironment
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)
        
        if let previousItem = context.previouslyFocusedView as? HomeCollectionViewCell {
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                previousItem.backgroundColor = UIColor.brown
            })
        }
        if let nextItem = context.nextFocusedView as? HomeCollectionViewCell {
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                nextItem.backgroundColor = UIColor(red: 51 / 100, green: 67 / 100, blue: 49 / 100, alpha: 0.8)
            })
        }
    }
}

