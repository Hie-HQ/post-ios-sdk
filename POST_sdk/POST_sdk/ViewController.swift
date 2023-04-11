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
        
        let loginVC = LoginVC()
        loginVC.delegate = self
        self.navigationController?.pushViewController(loginVC, animated: true)
        // Do any additional setup after loading the view.
    }


}

extension ViewController : LoginVCDelegate{
    func loginBtnContinueClicked() {
        let otpVC = OtpVC()
        otpVC.delegate = self
        self.navigationController?.pushViewController(otpVC, animated: true)
    }
    
    func loginBtnFacebookClicked() {
        
    }
    
    func loginBtnSnapchatClicked() {
        
    }
    
    func loginBtnGoogleClicked() {
        
    }
    
    
}

extension ViewController : OtpVCDelegate{
    
    func otpBackClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func otpValidate() {
        let profileVC = ProfileVC()
        profileVC.delegate = self
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
}

extension ViewController : ProfileVCDelegate{
    
    func profileBackClicked() {
        self.navigationController?.popViewController(animated: true)

    }
    
    func profileBtnContinueClicked() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    
}
