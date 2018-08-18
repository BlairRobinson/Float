//
//  CommentTableViewController.swift
//  Float
//
//  Created by Blair Robinson on 08/08/2018.
//  Copyright © 2018 Blair Robinson. All rights reserved.
//

import UIKit
import Firebase

class CommentTableViewController: UITableViewController {

    @IBOutlet var noCommentsView: UIView!
    @IBOutlet weak var addButton: UIButton!
    var comments = [Comment]()
    var activityIndicator: UIActivityIndicatorView!
    
    static var floatId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addButton.layer.cornerRadius = 15
        self.tableView.separatorStyle = .none
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle:
            UIActivityIndicatorViewStyle.gray)
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.isHidden = true
        activityIndicator.center = view.center;
        tableView.addSubview(activityIndicator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        observeComments()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(comments.count == 0){
            tableView.backgroundView = noCommentsView
            return 0
        } else {
            tableView.backgroundView = nil
            return comments.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "comment", for: indexPath) as! CommentTableViewCell

        if(comments.count == 0){
            cell.textLabel?.text = "No Comments yet..."
        }
        let comment = comments[indexPath.row]
        cell.comment = comment


        return cell
    }
    
    func loadNextVC() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "floatNavigation")
        self.present(vc!, animated: true, completion: nil)
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.loadNextVC()
    }
    
    func observeComments() {
        let floatRef = Database.database().reference().child("Comments")
        floatRef.observe(.value) { (snapshot) in
            var tempComments = [Comment]()
            
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String:Any],
                    let floatId = dict["floatId"] as? String,
                    let author = dict["author"] as? String,
                    let text = dict["text"] as? String,
                    let timestamp = dict["timestamp"] as? Double,
                    let profileURL = dict["photoURL"] as? String,
                    let url = URL(string: profileURL){
                    if floatId == CommentTableViewController.floatId {
                        let comment = Comment(floatId: floatId, author: author, text: text, timestamp: timestamp, photoURL: url)
                        tempComments.append(comment)
                    } else {
                        continue
                    }
                }
            }
            self.comments = tempComments
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }
}
