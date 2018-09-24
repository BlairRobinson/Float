//
//  ProfileViewController.swift
//  Float
//
//  Created by Blair Robinson on 15/07/2018.
//  Copyright © 2018 Blair Robinson. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var changePasswordBtn: UIButton!
    @IBOutlet weak var logOutBtn: UIButton!
    @IBOutlet weak var profileBackGround: UIView!
    
    
    var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator = UIActivityIndicatorView(style:
            UIActivityIndicatorView.Style.gray)
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.isHidden = true
        activityIndicator.center = view.center;
        view.addSubview(activityIndicator)
        setUpProfileImageAndButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadUserData()
    }

    @IBAction func logoutBtnPressed(_ sender: Any) {
        try! Auth.auth().signOut()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "homeController")
        self.present(vc!, animated: true, completion: nil)
    }
    
    
    func loadUserData() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        let currentId = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child("profile").child(currentId!).observeSingleEvent(of: .value) { (snapshot) in
                    if let dict = snapshot.value as? [String:Any],
                    let name = dict["name"] as? String,
                    let email = dict["email"] as? String,
                    let profileURL = dict["photoURL"] as? String,
                    let url = URL(string: profileURL) {
                    
                    ImageService.getImage(withURL: url) { (image) in
                        self.profileImage.image = image
                    }
                    self.emailLabel.text = email
                    self.nameLabel.text = name
                        
                } else {
                    print("error occurred")
                }
        }
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    @IBAction func changePassBtnPressed(_ sender: Any) {
        Auth.auth().sendPasswordReset(withEmail: emailLabel.text!) { error in
            if error == nil{
                self.presentErrorPopUp(message: "An email has been sent to reset your password, once you change it log back in.", title: "Change Password")
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(6), execute: {
                    try! Auth.auth().signOut()
                })
            } else {
                self.presentErrorPopUp(message: (error?.localizedDescription)!, title: "Error: Somethig went wrong")
            }
        }
    }
    
    func presentErrorPopUp(message: String, title: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func setUpProfileImageAndButton() {
        profileImage.layer.cornerRadius = profileImage.frame.height / 2.0
        profileBackGround.layer.cornerRadius = profileBackGround.frame.height / 2.0
        profileBackGround.layer.shadowColor = UIColor.black.cgColor
        profileBackGround.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        profileBackGround.layer.shadowOpacity = 0.4
        profileBackGround.layer.shadowRadius = 4.0
        changePasswordBtn.layer.cornerRadius = 10
        changePasswordBtn.layer.shadowColor = UIColor.black.cgColor
        changePasswordBtn.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        changePasswordBtn.layer.shadowOpacity = 0.5
        changePasswordBtn.layer.shadowRadius = 4.0
    }

}
