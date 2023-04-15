//
//  ViewController.swift
//  POST_sdk
//
//  Created by Apple on 07/04/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let onboarding = OnboardingVC.init(frame: self.view.bounds)
        onboarding.openLogin(vc: self)
        onboarding.delegate = self

//        let loginVC = LoginVC.instance()
//        loginVC.delegate = self
//        self.navigationController?.pushViewController(loginVC, animated: true)
        // Do any additional setup after loading the view.
    }

}


extension ViewController : OnboardingVCDelegate{
    
    func OnboardingSuccess() {
        debugPrint(OnboardingSuccess)
    }
    
    func OnboardingFailed() {
        debugPrint(OnboardingFailed)
    }
    
}
