//
//  HomeViewController.swift
//  iDev2017tvOS
//
//  Created by Justin Domnitz on 7/11/17.
//  Copyright © 2017 Lowyoyo, LLC. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var twitterTableView: UITableView!
    
    var tweets = [[Tweet]]()
    var hashtag = "360idev"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let value = UserDefaults.standard.value(forKey: "hashtag") as? String {
            hashtag = value
        } else {
            UserDefaults.standard.setValue(hashtag, forKey: "hashtag")
            UserDefaults.standard.synchronize()
        }
        
        //Table View
        twitterTableView.delegate = self
        twitterTableView.dataSource = self
        
        twitterTableView.register(UINib(nibName: "TweetTableViewCell", bundle: nil), forCellReuseIdentifier: "tweetTableViewCell")
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: "tweetTableViewCell", for: indexPath) as? TweetTableViewCell {
            
            cell.tweet = tweets[indexPath.section][indexPath.row]
            
            return cell
        }
    
        return UITableViewCell()
    }
    
}

