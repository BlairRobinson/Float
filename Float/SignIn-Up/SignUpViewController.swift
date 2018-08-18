//
//  SignUpViewController.swift
//  Float
//
//  Created by Blair Robinson on 15/07/2018.
//  Copyright © 2018 Blair Robinson. All rights reserved.
//

import UIKit
import Firebase
import Photos

class SignUpViewController: UITableViewController {
    
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var signUpBtn: UIButton!
    
    var picker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatLayers()
        self.hideKeyboardWhenTapped()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailTextField.becomeFirstResponder()
        picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.delegate = self
    }
    
    @IBAction func changeProfileBtnPressed(_ sender: Any) {
        self.present(picker, animated: true, completion: nil)
    }
    
    
    @IBAction func signUpBtnPressed(_ sender: Any) {
        guard let fullName = fullNameTextField.text else {return}
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        guard let profilePic = profileImage.image else {return}
        
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                if error == nil && user != nil {
                    self.uploadProfileImage(profilePic, completion: { (url) in
                        if url != nil {
                            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                            changeRequest?.displayName = fullName
                            changeRequest?.photoURL = url
                            changeRequest?.commitChanges(completion: { (error) in
                                if error == nil {
                                    print("Worked")
                                    self.saveProfileImage(name: fullName, email: email, profileImageURL: url!) { success in
                                        if success {
                                            self.loadNextVC()
                                        } else {
                                            self.presentErrorPopUp(message: (error?.localizedDescription)!)
                                        }
                                    }
                                } else {
                                    self.presentErrorPopUp(message: (error?.localizedDescription)!)
                                }
                            })
                        } else {
                            self.presentErrorPopUp(message: (error?.localizedDescription)!)
                        }
                        
                    })
                } else {
                    self.presentErrorPopUp(message: (error?.localizedDescription)!)
                }
            
        }
    }
    
    func uploadProfileImage(_ image:UIImage, completion: @escaping ((_ url:URL?)->())) {
        guard let userId = Auth.auth().currentUser?.uid else {return}
        let storageRef = Storage.storage().reference().child("user/\(userId)")
        guard let imageData = UIImageJPEGRepresentation(image, 0.75) else {return}
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        storageRef.putData(imageData, metadata: metaData) { (metaData, error) in
            if error == nil && metaData != nil {
                storageRef.downloadURL(completion: { (url, error) in
                    if let url = url{
                        print("Success")
                        completion(url)
                    } else {
                        print("Not working")
                        completion(nil)
                        
                    }
                })
            } else {
                print("Failed to upload image")
                completion(nil)
            }
        }
    }
    
    func saveProfileImage(name: String, email:String, profileImageURL: URL, completion: @escaping ((_ success:Bool)->())) {
        guard let userId = Auth.auth().currentUser?.uid else {return}
        let databaseRef = Database.database().reference().child("users/profile/\(userId)")
        let userObj = [
            "name": name,
            "email": email,
            "photoURL": profileImageURL.absoluteString
            ] as [String:Any]
        databaseRef.setValue(userObj) { (error, ref) in
            completion(error == nil)
        }
    }
    
    func formatLayers(){
        profileImage.layer.cornerRadius = profileImage.frame.height / 2.0
    }
    
    func presentErrorPopUp(message: String) {
        let alert = UIAlertController(title: "Error: Can't Sign up", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func loadNextVC() {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "floatNavigation") as? UITabBarController {
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }

}
