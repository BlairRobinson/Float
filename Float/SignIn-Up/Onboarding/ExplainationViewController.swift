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
        let descFont = UIFont(name: "Avenir-Book", size: 14)!
        
        return [
            OnboardingItemInfo(informationImage: UIImage(named: "create")!,
                           title: "Float Up Your Idea",
                           description: "Have an idea and want to see what others think? Float up your thoughts and get feedback.",
                           pageIcon: UIImage(),
                           color: backgroundColourOne,
                           titleColor: UIColor.white,
                           descriptionColor: UIColor.white,
                           titleFont: titleFont,
                           descriptionFont: descFont),
            OnboardingItemInfo(informationImage: UIImage(named: "Idea")!,
                               title: "Like Other's Ideas",
                               description: "If you think someone has a good idea, why not give it a like, by lighting up their bulb.",
                               pageIcon: UIImage(),
                               color: backgroundColourTwo,
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.white,
                               titleFont: titleFont,
                               descriptionFont: descFont),
            OnboardingItemInfo(informationImage: UIImage(named: "comment")!,
                               title: "Comment On Other Ideas",
                               description: "Tell others what you think, or what they could improve, by leaving them a comment.",
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
