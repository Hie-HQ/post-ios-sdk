//
//  LoginVC.swift
//  POST_sdk
//
//  Created by Apple on 09/04/23.
//

import Foundation
import UIKit

protocol LoginVCDelegate : class {

    func loginSuccess()
    func loginFailure()

}

class LoginVC: UIViewController {

    
    @IBOutlet weak var lblAppName: UILabel!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var vWPhoneNumber: UIView!
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var btnSnapChat: UIButton!
    
    weak var delegate: LoginVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
                
        NotificationCenter.default.addObserver(self, selector: #selector(SignupSuccess(notification:)), name: Notification.Name(Constants.NotificationCenterKey.KSignupSuccess), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SignupFailure(notification:)), name: Notification.Name(Constants.NotificationCenterKey.KSignupFailure), object: nil)

    }
    
    @objc func SignupFailure(notification: NSNotification) {
        self.navigationController?.dismiss(animated: true)
        delegate?.loginFailure()
    }
    
    @objc func SignupSuccess(notification: NSNotification) {
        self.navigationController?.dismiss(animated: true)
        delegate?.loginSuccess()
    }
    
    func setUI(){
        vWPhoneNumber.setCornerRadious(corner: vWPhoneNumber.frame.height / 2)
        vWPhoneNumber.setBorder(width: 1, color: UIColor.init(hexString: "DDDDDD"))
        btnGoogle.setCornerRadious(corner: btnGoogle.frame.height / 2)
        btnFacebook.setCornerRadious(corner: btnFacebook.frame.height / 2)
        btnSnapChat.setCornerRadious(corner: btnSnapChat.frame.height / 2)
        btnGoogle.setBorder(width: 1, color: UIColor.init(hexString: "DDDDDD"))
        btnFacebook.setBorder(width: 1, color: UIColor.init(hexString: "DDDDDD"))
        btnSnapChat.setBorder(width: 1, color: UIColor.init(hexString: "DDDDDD"))
        btnContinue.setCornerRadious(corner: btnContinue.frame.height / 2)

    }
    
    @IBAction func btnContinueClicked(_ sender: UIButton) {
        let otpVC = OtpVC.instance()
        self.navigationController?.pushViewController(otpVC, animated: true)
    }
    @IBAction func btnGoogleClicked(_ sender: UIButton) {
    }
    @IBAction func btnFacebookClicked(_ sender: UIButton) {
    }
    @IBAction func btnSnapChatClicked(_ sender: UIButton) {
    }
}
