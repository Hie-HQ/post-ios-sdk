//
//  LoginVC.swift
//  POST_sdk
//
//  Created by Apple on 09/04/23.
//

import Foundation
import UIKit
import IQKeyboardManager
import Kingfisher

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
    @IBOutlet weak var btnCountryCode: UIButton!
    @IBOutlet weak var imgApp: UIImageView!
    @IBOutlet weak var imgBackGround: UIImageView!

    weak var delegate: LoginVCDelegate?
    var loginModel = LoginModel()
    var objSdkDetailsModel : sdkDetailsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtPhoneNumber.text = "9998605056"
        setUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(SignupSuccess(notification:)), name: Notification.Name(Constants.NotificationCenterKey.KSignupSuccess), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SignupFailure(notification:)), name: Notification.Name(Constants.NotificationCenterKey.KSignupFailure), object: nil)
        
        callAuthAPI()
        
        
    }
    
    func setupSDKData(){
    
        
        if let appImage = objSdkDetailsModel?.customForm?.brandLogo,let urlStr = URL(string: "\(Constants.Base_Url.Base_Url_AWS_Dev)\(appImage)"){
            imgApp.isHidden = false
            imgApp.kf.setImage(with: urlStr)
            lblAppName.isHidden = true
        }
        else{
            imgApp.isHidden = true
            
            if let appName = objSdkDetailsModel?.customForm?.brandName{
                lblAppName.isHidden = false
                lblAppName.text = appName
                
            }
            else{
                lblAppName.isHidden = true
            }
        }
        
        if let brandNameColor = objSdkDetailsModel?.customForm?.backgroundColor {
            lblAppName.textColor = UIColor.init(hexString: brandNameColor)
        }
        
        if let imgBG = objSdkDetailsModel?.customForm?.backgroundImage,let urlStr = URL(string: "\(Constants.Base_Url.Base_Url_AWS_Dev)\(imgBG)"){
            imgBackGround.kf.setImage(with: urlStr)
        }
        else{
            if let colorBG = objSdkDetailsModel?.customForm?.backgroundColor{
                self.view.backgroundColor = UIColor.init(hexString: colorBG)
            }
        }
        
        
        if let btnData = objSdkDetailsModel?.customForm?.customForm?["step1Btn"]{
            
            if let btnText = btnData["text"].string{
                 btnContinue.setTitle(btnText, for: .normal)
            }
            
            if let btnColor = btnData["color"].string{
                btnContinue.setTitleColor(UIColor.init(hexString: btnColor), for: .normal)
            }
            
        }
        
        if let buttonTextColor = objSdkDetailsModel?.customForm?.buttonTextColor {
            btnContinue.setTitleColor(UIColor.init(hexString: buttonTextColor), for: .normal)
        }
        
        if let buttonColor = objSdkDetailsModel?.customForm?.buttonColor {
            btnContinue.backgroundColor = UIColor.init(hexString: buttonColor)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        IQKeyboardManager.shared().isEnabled = true
        
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
        if isValid(){
            callLoginAPI()
        }
        // let otpVC = OtpVC.instance()
        //  self.navigationController?.pushViewController(otpVC, animated: true)
    }
    @IBAction func btnGoogleClicked(_ sender: UIButton) {
    }
    @IBAction func btnFacebookClicked(_ sender: UIButton) {
    }
    @IBAction func btnSnapChatClicked(_ sender: UIButton) {
    }
    
    func isValid() -> Bool{
        
        if txtPhoneNumber.text ?? "" == "" {
            CommonMethodsClass.showAlertViewOnWindow(titleStr: "", messageStr: "Please enter your phone number", okBtnTitleStr: "OK")
            return false
        }
        if txtPhoneNumber.text?.count ?? 0 < 10{
            CommonMethodsClass.showAlertViewOnWindow(titleStr: "", messageStr: "Please enter valid phone number", okBtnTitleStr: "OK")
            return false
        }
    
        return true
    }
    
    func callAuthAPI(){
        
        APIManager.shared.request(with: APIEndPoints.authenticate_sdk_user(clientId: "post_test_5de9665a-4629-4992-b721-4ad0c13cceb4", clientSecret: "post_test_78f699b7-79df-44e2-a578-d3d82e14eafe"), isLoaderNeeded: true) { [weak self]
            response in
            
            switch response {
            case let .success(response):
                print(response)
                
                if let model = response as? sdkResponseModel {
                
                    self?.objSdkDetailsModel = model.data
                    self?.setupSDKData()
                    
                    DBManager.setValueInUserDefaults(value: model.data?.tokens?.access?.token ?? "", forKey: Constants.UserDefultKey.kAccessToken)
                    
                    DBManager.setValueInUserDefaults(value: model.data?.tokens?.refresh?.token ?? "", forKey: Constants.UserDefultKey.kRefreshToken)
                    
                    DBManager.setValueInUserDefaults(value: model.data?.tokens?.access?.expires ?? "", forKey: Constants.UserDefultKey.kAccessTokenExpire)
                    
                }

                
            case let .failure(msg, _):
                print(msg)
                
            case let .Warning(msg):
                print(msg)
                
            }
        }
    }
    
    func callLoginAPI(){
        
        let countryCode = btnCountryCode.title(for: .normal) ?? "+91"
        
        APIManager.shared.request(with: APIEndPoints.generate_otp(countryCode: countryCode.replacingOccurrences(of: "+", with: ""), mobile: txtPhoneNumber.text ?? ""), isLoaderNeeded: true) { [weak self]
            response in
            
            switch response {
            case let .success(response):
                print(response)
                
                if let model = response as? loginResponseModel, let otp = model.data?.otp{
                    
                    let loginModel = LoginModel.init(mobile: self?.txtPhoneNumber.text ?? "", countryCode: countryCode.replacingOccurrences(of: "+", with: ""), otp: otp)
                    let otpVC = OtpVC.instance()
                    otpVC.loginModel = loginModel
                    otpVC.objSdkDetailsModel = self?.objSdkDetailsModel
                    self?.navigationController?.pushViewController(otpVC, animated: true)
                    
                }
                
                
            case let .failure(msg, _):
                print(msg)
                
            case let .Warning(msg):
                print(msg)
                
            }
        }
    }
}
