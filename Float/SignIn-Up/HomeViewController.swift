//
//  HomeViewController.swift
//  Float
//
//  Created by Blair Robinson on 15/07/2018.
//  Copyright © 2018 Blair Robinson. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInBtn.layer.cornerRadius = 30
        signUpBtn.layer.cornerRadius = 30
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            self.loadNextVC()
        }
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
    }
    
    func loadNextVC() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "floatNavigation") as? UITabBarController
        self.present(vc!, animated: true, completion: nil)
    }
}
