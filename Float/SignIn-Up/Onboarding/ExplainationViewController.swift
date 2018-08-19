//
//  ExplainationViewController.swift
//  Float
//
//  Created by Blair Robinson on 18/08/2018.
//  Copyright © 2018 Blair Robinson. All rights reserved.
//

import UIKit
import paper_onboarding

class ExplainationViewController: UIViewController, PaperOnboardingDataSource, PaperOnboardingDelegate {

    @IBOutlet weak var onboardingView: Onboarding!
    @IBOutlet weak var getStartedBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onboardingView.dataSource = self
        onboardingView.delegate = self
    }
    
    func onboardingItemsCount() -> Int {
        return 3
    }
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        let backgroundColourOne = UIColor(red: 255/255, green: 74/255, blue: 0/255, alpha: 1)
        let backgroundColourTwo = UIColor(red: 69/255, green: 179/255, blue: 157/255, alpha: 1)
        let titleFont = UIFont(name: "Avenir-Black", size: 28)!
        let descFont = UIFont(name: "Avenir-Book", size: 13)!
        
        return [
            OnboardingItemInfo(informationImage: UIImage(named: "create")!,
                           title: "Float up your idea",
                           description: "Have an idea and want to see what others think? Float up an idea and get feeback on your idea.",
                           pageIcon: UIImage(),
                           color: backgroundColourOne,
                           titleColor: UIColor.white,
                           descriptionColor: UIColor.white,
                           titleFont: titleFont,
                           descriptionFont: descFont),
            OnboardingItemInfo(informationImage: UIImage(named: "Idea")!,
                               title: "Like others ideas",
                               description: "We all associate a bulb lighting up when someone has a good idea. So click the bulb to light it up if you think its a good idea.",
                               pageIcon: UIImage(),
                               color: backgroundColourTwo,
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.white,
                               titleFont: titleFont,
                               descriptionFont: descFont),
            OnboardingItemInfo(informationImage: UIImage(named: "comment")!,
                               title: "Comment on other idas",
                               description: "Contribute to others ideas by telling them what you think, by leaving them a comment.",
                               pageIcon: UIImage(),
                               color: backgroundColourOne,
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.white,
                               titleFont: titleFont,
                               descriptionFont: descFont)
        ][index]
    }

    
    func onboardingWillTransitonToIndex(_ index: Int) {
        if index == 1 {
            if self.getStartedBtn.alpha == 1 {
                UIView.animate(withDuration: 0.2) {
                    self.getStartedBtn.alpha = 0
                }
            }
        }
    }
    
    func onboardingDidTransitonToIndex(_ index: Int) {
        if index == 2 {
            UIView.animate(withDuration: 0.4) {
                self.getStartedBtn.alpha = 1
            }
        }
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
    }
    
}
