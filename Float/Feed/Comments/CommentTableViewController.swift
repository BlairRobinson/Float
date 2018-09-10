//
//  CommentTableViewController.swift
//  Float
//
//  Created by Blair Robinson on 08/08/2018.
//  Copyright © 2018 Blair Robinson. All rights reserved.
//

import UIKit
import Firebase

class CommentTableViewController: UITableViewController, UITextFieldDelegate  {

    @IBOutlet var noCommentsView: UIView!
    @IBOutlet weak var addButton: UIButton!
    var comments = [Comment]()
    var activityIndicator: UIActivityIndicatorView!
    
    static var floatId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle:
            UIActivityIndicatorViewStyle.gray)
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.isHidden = true
        activityIndicator.center = view.center;
        tableView.addSubview(activityIndicator)
        tableView.keyboardDismissMode = .interactive
    }
    
    override func viewWillAppear(_ animated: Bool) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        observeComments()
    }
    
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
                    if CommentTableViewController.floatId == floatId {
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
    
    lazy var inputText: UITextField = {
        let inputTextField = UITextField()
        inputTextField.placeholder = "Enter Comment Here..."
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        inputTextField.delegate = self
        return inputTextField
    }()
    
    lazy var inputContainerView: UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        containerView.backgroundColor = UIColor.white
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Add", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(addCommentBtnPressed), for: .touchUpInside)
        containerView.addSubview(sendButton)
        //place on screen
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        containerView.addSubview(inputText)
        //place on screen
        inputText.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        inputText.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputText.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputText.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        let seperaterLineView = UIView()
        seperaterLineView.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        seperaterLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(seperaterLineView)
        //place on screen
        seperaterLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        seperaterLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        seperaterLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        seperaterLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return containerView
    }()
    
    @objc func addCommentBtnPressed() {
        guard let userProfile = UserService.currentUserProf else {return}
        
        let ref = Connections.databaseRefComments
        let childRef = ref.childByAutoId()
        if let text = inputText.text, inputText.text != "" {
            let values = ["author": userProfile.fullName, "photoURL": userProfile.profileURL.absoluteString, "text": text, "floatId": CommentTableViewController.floatId, "timestamp": [".sv":"timestamp"]] as [String : Any]
            childRef.updateChildValues(values)
        }
        Database.database().reference().child("floats").child(CommentTableViewController.floatId).child("comments").observeSingleEvent(of: .value) { (snapshot) in
            let comments = snapshot.value as? Int
            snapshot.ref.setValue(comments! + 1)
        }
        self.inputText.text = nil
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return inputContainerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addCommentBtnPressed()
        return true
    }
}
