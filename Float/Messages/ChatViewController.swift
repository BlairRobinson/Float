//
//  ChatViewController.swift
//  Float
//
//  Created by Blair Robinson on 29/08/2018.
//  Copyright © 2018 Blair Robinson. All rights reserved.
//

import UIKit
import Firebase
import KRProgressHUD
import KRActivityIndicatorView
import AudioToolbox

class ChatViewController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {
    
    var messages = [Message]()
    var user: User? {
        didSet {
            navigationItem.title = user?.fullName
            observeMessages()
        }
    }
    
    func observeMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let userMessagesRef = Database.database().reference().child("user-messages").child(uid)
        userMessagesRef.observe(.childAdded) { (snapshot) in
            let userId = snapshot.key
            print(snapshot)
            Database.database().reference().child("user-messages").child(uid).child(userId).observe(.childAdded, with: { (snapshot) in
                let messageId = snapshot.key
                let messagesRef = Database.database().reference().child("messages").child(messageId)
                messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    guard let dict = snapshot.value as? [String: Any] else {return}
                    if let fromId = dict["fromId"] as? String,
                        let toId = dict["toId"] as? String,
                        let text = dict["text"] as? String,
                        let timestamp = dict["timestamp"] as? Int{
                        let message = Message(fromId: fromId, text: text, toId: toId, timeStamp: timestamp)
                        
                        if message.chatPartnerId() == self.user?.uid {
                            self.messages.append(message)
                            DispatchQueue.main.async {
                                self.collectionView?.reloadData()
                            }
                        }
                        
                    }
                })

            })
            
        }
    }
    
    lazy var inputText: UITextField = {
        let inputTextField = UITextField()
        inputTextField.placeholder = "Enter Message..."
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        inputTextField.delegate = self
        return inputTextField
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        self.collectionView?.alwaysBounceVertical = true
        self.collectionView?.backgroundColor = UIColor.white
        collectionView?.register(MessagesCollectionViewCell.self, forCellWithReuseIdentifier: "test")
        collectionView?.keyboardDismissMode = .interactive
        
//        setUpInputComponents()
//        setUpKeyboardObservers()
    }
    
    lazy var inputContainerView: UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        containerView.backgroundColor = UIColor.white
    
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
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
    
    override var inputAccessoryView: UIView? {
        get {
            return inputContainerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "test", for: indexPath) as! MessagesCollectionViewCell
        let message = messages[indexPath.item]
        cell.textView.text = message.text
        cell.bubbleWidthAnchor.constant = estimatedFrameForText(text: message.text).width + 28
        setUpCell(cell: cell, message: message)
        
        return cell
    }
    
    private func setUpCell(cell: MessagesCollectionViewCell, message: Message) {
        ImageService.getImage(withURL: (self.user?.profileURL)!) { (image) in
            cell.profileImageView.image = image
        }
        
        if message.fromId == Auth.auth().currentUser?.uid {
            //blue
            cell.bubbleView.backgroundColor = UIColor(red: 255/255, green: 96/255, blue: 0/255, alpha: 1.0)
            cell.textView.textColor = UIColor.white
            cell.bubbleViewRightAnchor.isActive = true
            cell.bubbleViewLeftAnchor.isActive  = false
            cell.profileImageView.isHidden = true
        } else {
            //grey
            cell.bubbleView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
            cell.textView.textColor = UIColor.black
            cell.bubbleViewRightAnchor.isActive = false
            cell.bubbleViewLeftAnchor.isActive  = true
            cell.profileImageView.isHidden = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height : CGFloat = 80
        let text = messages[indexPath.item].text
        height = estimatedFrameForText(text: text).height + 20
        let width = UIScreen.main.bounds.width
            return CGSize(width: width, height: height)
    }
    
    private func estimatedFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 210, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16.0)], context: nil)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    var containerViewBottomAnchor: NSLayoutConstraint?
    
    @objc func handleSend() {
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let toId = user?.uid
        let fromId = Auth.auth().currentUser?.uid
        let values = [
            "text": inputText.text!,
            "toId": toId!,
            "fromId": fromId!,
            "timestamp": Int(NSDate().timeIntervalSince1970)
        ] as [AnyHashable : Any]
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                KRProgressHUD.set(deadlineTime: Double(2)).showError(withMessage: error?.localizedDescription)
                AudioServicesPlaySystemSound(1519)
                return
            }
            
            self.inputText.text = nil
            
            let userMessagesRef = Database.database().reference().child("user-messages").child(fromId!).child(toId!)
            let messageKey = childRef.key
            userMessagesRef.updateChildValues([messageKey: 1])
            
            let recepientUserMessagesRef = Database.database().reference().child("user-messages").child(toId!).child(fromId!)
            recepientUserMessagesRef.updateChildValues([messageKey: 1])
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }

}
