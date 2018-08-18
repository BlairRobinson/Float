//
//  SignImViewController.swift
//  Float
//
//  Created by Blair Robinson on 18/07/2018.
//  Copyright © 2018 Blair Robinson. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UITableViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInBtn.layer.cornerRadius = 30
        self.hideKeyboardWhenTapped()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailTextField.becomeFirstResponder()

    }
    
    @IBAction func signInBtnPressed(_ sender: Any) {
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
         let sv = UIViewController.displaySpinner(onView: self.view)
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error == nil && user != nil {
                UIViewController.removeSpinner(spinner: sv)
               self.loadNextVC()
            }
            else {
                self.presentErrorPopUp()
            }
        }
    }
    
    func presentErrorPopUp() {
        let alert = UIAlertController(title: "Error: Can't Sign in", message: "Email or Password is incorrect. Please try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
        func loadNextVC() {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "floatNavigation") as? UITabBarController
            self.present(vc!, animated: true, completion: nil)
        }
}
