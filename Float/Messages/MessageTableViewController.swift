//
//  MessageTableViewController.swift
//  Float
//
//  Created by Blair Robinson on 28/08/2018.
//  Copyright © 2018 Blair Robinson. All rights reserved.
//

import UIKit
import Firebase

class MessageTableViewController: UITableViewController {

    @IBOutlet weak var newMessageBtn: UIButton!
    var messages = [Message]()
    var messageDictionary = [String : Message]()
    var activityIndicator: UIActivityIndicatorView!
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newMessageBtn.layer.cornerRadius = 15
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        activityIndicator = UIActivityIndicatorView(style:
            UIActivityIndicatorView.Style.gray)
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.isHidden = true
        activityIndicator.center = view.center;
        tableView.addSubview(activityIndicator)
        messages.removeAll()
        messageDictionary.removeAll()
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        observeUserMessages()
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messages.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "message", for: indexPath) as! MessagesTableViewCell
        let message = messages[indexPath.item]
        cell.message = message

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        
        let ref = Database.database().reference().child("users").child("profile").child(message.chatPartnerId()!)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let dict = snapshot.value as? [String: Any] else {return}
            if let name = dict["name"] as? String,
                let email = dict["email"] as? String,
                let photoURL = dict["photoURL"] as? String,
                let url = URL(string: photoURL) {
                let user = User(uid: snapshot.key, email: email, profileURL: url, fullName: name)
                self.showChatControllerForUser(user: user)
            }
            
        }
    }
    
    @IBAction func newBtnPressed(_ sender: Any) {
        NewMessageTableViewController.messagesController = self
    }
    
    func showChatControllerForUser(user: User) {
        let chatController = ChatViewController(collectionViewLayout: UICollectionViewFlowLayout())
        chatController.user = user
        self.navigationController?.pushViewController(chatController, animated: true)
    }
    
    func observeUserMessages() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        guard let uid = Auth.auth().currentUser?.uid else {return}
         let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded) { (snapshot) in
            let userId = snapshot.key
            Database.database().reference().child("user-messages").child(uid).child(userId).observe(.childAdded, with: { (snapshot) in
                let messageId = snapshot.key
                let messageRef = Database.database().reference().child("messages").child(messageId)
                messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    if let dict = snapshot.value as? [String : AnyObject] {
                        let message = Message(fromId: dict["fromId"] as! String, text: dict["text"] as! String, toId: dict["toId"] as! String, timeStamp: dict["timestamp"] as! Int)
                        self.messageDictionary[message.chatPartnerId()!] = message
                    }
                    self.attemptReloadOfTable()

                })
            })
        }
        
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    private func attemptReloadOfTable() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    
    @objc func handleReloadTable() {
        self.messages = Array(self.messageDictionary.values)
        self.messages.sort(by: { (message1, message2) -> Bool in
            return Int(message1.timeStamp) > Int(message2.timeStamp)
        })
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}
