//
//  SignUpViewController.swift
//  Float
//
//  Created by Blair Robinson on 15/07/2018.
//  Copyright © 2018 Blair Robinson. All rights reserved.
//

import UIKit
import Firebase
import KRProgressHUD
import KRActivityIndicatorView
import Photos


class SignUpViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var verifyPasswordField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var correctEmail: UIImageView!
    
    var picker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatLayers()
        self.hideKeyboardWhenTapped()
        emailTextField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.delegate = self
    }
    
    @IBAction func changeProfileBtnPressed(_ sender: Any) {
        PHPhotoLibrary.requestAuthorization({
            (newStatus) in
            if newStatus ==  PHAuthorizationStatus.authorized {
                /* do stuff here */
                self.present(self.picker, animated: true, completion: nil)
            }
        })
    }
    
    
    @IBAction func signUpBtnPressed(_ sender: Any) {
        guard let fullName = fullNameTextField.text else {return}
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        guard let password2 = verifyPasswordField.text else {return}
        guard let profilePic = profileImage.image else {return}
        
        KRProgressHUD.set(style: .black).set(maskType: .white).show(withMessage: "Loading..", completion: nil)
        if(password == password2){
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
                                            KRProgressHUD.showSuccess(withMessage: "Account created successfully")
                                            self.loadNextVC()
                                        } else {
                                            KRProgressHUD.set(deadlineTime: Double(2)).showError(withMessage: error?.localizedDescription)
                                            AudioServicesPlaySystemSound(1519)
                                        }
                                    }
                                } else {
                                   KRProgressHUD.set(deadlineTime: Double(2)).showError(withMessage: error?.localizedDescription)
                                    AudioServicesPlaySystemSound(1519)
                                }
                            })
                        } else {
                            KRProgressHUD.set(deadlineTime: Double(2)).showError(withMessage: error?.localizedDescription)
                            AudioServicesPlaySystemSound(1519)
                        }
                        
                    })
                } else {
                   KRProgressHUD.set(deadlineTime: Double(2)).showError(withMessage: error?.localizedDescription)
                    AudioServicesPlaySystemSound(1519)
                }
            }
        } else {
            KRProgressHUD.set(deadlineTime: Double(2)).showError(withMessage: "Passwords do not match")
            AudioServicesPlaySystemSound(1519)
        }
    }
    
    func uploadProfileImage(_ image:UIImage, completion: @escaping ((_ url:URL?)->())) {
        let storageRef = Connections.storageRef
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {return}
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
        let databaseRef = Connections.databaseRefUsers
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
        signUpBtn.layer.cornerRadius = 30
    }
    
    func presentErrorPopUp(message: String) {
        let alert = UIAlertController(title: "Error: Can't Sign up", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func loadNextVC() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Onboard")
        self.present(vc!, animated: true, completion: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (emailTextField.text?.contains("@"))! {
            correctEmail.isHidden = false
        }
    }
    
}
