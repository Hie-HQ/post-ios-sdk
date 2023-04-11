//
//  LoginVC.swift
//  POST_sdk
//
//  Created by Apple on 09/04/23.
//

import Foundation
import UIKit

public protocol LoginVCDelegate : class {
    func loginBtnContinueClicked()
    func loginBtnFacebookClicked()
    func loginBtnSnapchatClicked()
    func loginBtnGoogleClicked()

}

public class LoginVC: UIViewController {
    
    @IBOutlet weak var lblAppName: UILabel!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var vWPhoneNumber: UIView!
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var btnSnapChat: UIButton!
    
    public weak var delegate: LoginVCDelegate?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
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
        delegate?.loginBtnContinueClicked()
    }
    @IBAction func btnGoogleClicked(_ sender: UIButton) {
        delegate?.loginBtnGoogleClicked()
    }
    @IBAction func btnFacebookClicked(_ sender: UIButton) {
        delegate?.loginBtnFacebookClicked()
    }
    @IBAction func btnSnapChatClicked(_ sender: UIButton) {
        delegate?.loginBtnSnapchatClicked()
    }
}
