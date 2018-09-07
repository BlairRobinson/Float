//
//  AddFloatViewController.swift
//  Float
//
//  Created by Blair Robinson on 23/07/2018.
//  Copyright © 2018 Blair Robinson. All rights reserved.
//

import UIKit
import Firebase

class AddFloatViewController: UIViewController, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
 
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var floatTextView: UITextView!
    @IBOutlet weak var floatTitle: UITextField!
    @IBOutlet weak var floatCategory: UITextField!
    var picker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        floatTextView.delegate = self
        self.addBtn.layer.cornerRadius = 15
        floatTextView.text = "Write your idea here..."
        floatTextView.textColor = UIColor.lightGray
       
        NotificationCenter.default.addObserver(self, selector: #selector(AddFloatViewController.updateTextView(notification:)), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddFloatViewController.updateTextView(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        picker.delegate = self
        picker.dataSource = self
        floatCategory.inputView = picker
    }

    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.loadNextVC()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if floatTextView.text == "Write your idea here..." {
            floatTextView.text = ""
            floatTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            floatTextView.text = "Write your idea here..."
            floatTextView.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            floatTextView.resignFirstResponder()
        }
        return true
    }
    
    @objc func updateTextView(notification: Notification){
        let userInfo = notification.userInfo!
        let keyboardEndFrameScreenCoord = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardEndFrame = self.view.convert(keyboardEndFrameScreenCoord, to: view.window)
        if notification.name == Notification.Name.UIKeyboardWillHide {
            floatTextView.contentInset = UIEdgeInsets.zero
        } else {
            floatTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardEndFrame.height, right: 0)
            floatTextView.scrollIndicatorInsets = floatTextView.contentInset
        }
        floatTextView.scrollRangeToVisible(floatTextView.selectedRange)
        
    }
    
    @IBAction func addFloatBtnPressed(_ sender: Any) {
        guard let userProfile = UserService.currentUserProf else {return}
        
        let postRef = Connections.databaseRefFloats.childByAutoId()
        if(floatTextView.text != "Write your idea here..."){
            let postObject = [
                "author": [
                    "name": userProfile.fullName,
                    "uid":userProfile.uid,
                    "email": userProfile.email,
                    "photoURL": userProfile.profileURL.absoluteString
                ],
                "title": floatTitle.text,
                "floatDescription": floatTextView.text,
                "timestamp": [".sv":"timestamp"],
                "comments": 0,
                "peopleWholikes": ["0"],
                "likes": 0,
                "category": floatCategory.text
                ] as [String:Any]
            
            postRef.setValue(postObject) { (error, ref) in
                if error == nil {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.presentErrorPopUp(message: (error?.localizedDescription)!)
                }
            }
            
        } else {
            self.presentErrorPopUp(message: "Nothing has been entered")
        }
    }
    
    func presentErrorPopUp(message: String) {
        let alert = UIAlertController(title: "Error: Cannot post Float", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func loadNextVC() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "floatNavigation")
        self.present(vc!, animated: true, completion: nil)
    }
    
    var categorys = ["Charity", "General", "Education", "Health", "Technology", "Music", "Jobs" ]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categorys.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        floatCategory.text = categorys[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categorys[row]
    }

}
