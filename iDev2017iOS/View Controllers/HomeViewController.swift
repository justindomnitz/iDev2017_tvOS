//
//  FirstViewController.swift
//  iDev2017iOS
//
//  Created by Justin Domnitz on 7/29/17.
//  Copyright © 2017 Lowyoyo, LLC. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
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
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "TweetTableViewCell", bundle: nil), forCellReuseIdentifier: "tweetTableViewCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Clear Twitter data.
        tweets.removeAll()
        tableView.reloadData()
        
        getTwitterData()
    }

    //MARK: Table view delegate methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numRows = 0
        if tweets.count > section {
            numRows = tweets[section].count
        }
        return numRows
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "tweetTableViewCell", for: indexPath) as? TweetTableViewCell {
            
            cell.tweet = tweets[indexPath.section][indexPath.row]
            
            return cell
        }
        
        let cell = UITableViewCell()
        
        cell.textLabel?.text = "\(indexPath.row)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //noop
    }
    
    //MARK: Helper methods

    func getTwitterData() {
        TwitterInterface().requestTwitterSearchResults(hashtag, completion: { (tweets, error) -> Void in
            //TO-DO: Error handling.
            if error == nil {
                DispatchQueue.main.async(execute: {
                    self.tweets.insert(tweets!, at: 0)
                    self.tableView.reloadData()
                })
            }
        })
    }
}

