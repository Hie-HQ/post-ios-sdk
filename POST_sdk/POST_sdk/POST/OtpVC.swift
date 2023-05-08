//
//  OtpVC.swift
//  POST_sdk
//
//  Created by Apple on 09/04/23.
//

import Foundation
import UIKit
import IQKeyboardManager

protocol OtpVCDelegate : class {
    func otpBackClicked()
    func otpValidate()
}

class OtpVC: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblResend: UILabel!
    @IBOutlet weak var lblResendTimer: UILabel!
    @IBOutlet weak var vWResend: UIView!
    @IBOutlet weak var btnResend: UIButton!
    @IBOutlet weak var imgApp: UIImageView!
    @IBOutlet weak var imgBackGround: UIImageView!


    @IBOutlet weak var vWOTP1: UIView!
    @IBOutlet weak var vWOTP2: UIView!
    @IBOutlet weak var vWOTP3: UIView!
    @IBOutlet weak var vWOTP4: UIView!
    @IBOutlet weak var vWOTP5: UIView!
    @IBOutlet weak var vWOTP6: UIView!

    @IBOutlet weak var txtOTP1: SingleDigitTextField!
    @IBOutlet weak var txtOTP2: SingleDigitTextField!
    @IBOutlet weak var txtOTP3: SingleDigitTextField!
    @IBOutlet weak var txtOTP4: SingleDigitTextField!
    @IBOutlet weak var txtOTP5: SingleDigitTextField!
    @IBOutlet weak var txtOTP6: SingleDigitTextField!
    
    weak var delegate: OtpVCDelegate?
    var counter = 30
    var timer = Timer()
    var loginModel = LoginModel()
    var objSdkDetailsModel : sdkDetailsModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtOTP1.text = "1"
        txtOTP2.text = "1"
        txtOTP3.text = "1"
        txtOTP4.text = "1"
        txtOTP5.text = "1"
        txtOTP6.text = "1"

        setUI()
        setupSDKData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        IQKeyboardManager.shared().isEnabled = true
        
    }
       
    func setupSDKData(){
        
        
        if let appImage = objSdkDetailsModel?.customForm?.brandLogo,let urlStr = URL(string: "\(Constants.Base_Url.Base_Url_AWS_Dev)\(appImage)"){
            imgApp.isHidden = false
            imgApp.kf.setImage(with: urlStr)
            lblTitle.isHidden = true
        }
        else{
            imgApp.isHidden = true
            
            if let appName = objSdkDetailsModel?.customForm?.brandName{
                lblTitle.isHidden = false
                lblTitle.text = appName
                
            }
            else{
                lblTitle.isHidden = true
            }
        }
        
        if let brandNameColor = objSdkDetailsModel?.customForm?.backgroundColor {
            lblTitle.textColor = UIColor.init(hexString: brandNameColor)
        }
        
        if let imgBG = objSdkDetailsModel?.customForm?.backgroundImage,let urlStr = URL(string: "\(Constants.Base_Url.Base_Url_AWS_Dev)\(imgBG)"){
            imgBackGround.kf.setImage(with: urlStr)
        }
        else{
            if let colorBG = objSdkDetailsModel?.customForm?.backgroundColor{
                self.view.backgroundColor = UIColor.init(hexString: colorBG)
            }
        }
    
        
    }
    
    func setUI(){
        
        lblDesc.text = "+\(loginModel.countryCode) \(loginModel.mobile)"
        
        vWResend.setCornerRadious(corner: vWResend.frame.height / 2)
        vWResend.setBorder(width: 1, color: UIColor.init(hexString: "666666"))
        
        vWOTP1.setCornerRadious(corner: vWOTP1.frame.width / 2)
        vWOTP2.setCornerRadious(corner: vWOTP2.frame.width / 2)
        vWOTP3.setCornerRadious(corner: vWOTP3.frame.width / 2)
        vWOTP4.setCornerRadious(corner: vWOTP4.frame.width / 2)
        vWOTP5.setCornerRadious(corner: vWOTP5.frame.width / 2)
        vWOTP6.setCornerRadious(corner: vWOTP6.frame.width / 2)

        startTimer()
        
        setupTextfiled()
       
    }
    
    func setupTextfiled(){
        
        [txtOTP1,txtOTP2,txtOTP3,txtOTP4,txtOTP5,txtOTP6].forEach
        {
            $0?.delegate = self
            $0?.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        }
        
        txtOTP1.isUserInteractionEnabled = true
        txtOTP1.becomeFirstResponder()
        
//        txtOTP1.inputAccessoryView = UIView()
//        txtOTP2.inputAccessoryView = UIView()
//        txtOTP3.inputAccessoryView = UIView()
//        txtOTP4.inputAccessoryView = UIView()
//        txtOTP5.inputAccessoryView = UIView()
//        txtOTP6.inputAccessoryView = UIView()

    }
    
    func startTimer(){
        
        lblResend.text = "Resend SMS in"
        lblResendTimer.text = "\(counter) secs"
        btnResend.isEnabled = false
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    func stopTimer(){
        timer.invalidate()
    }
    
    @objc func timerAction() {
        counter -= 1
        lblResendTimer.text = "\(counter) secs"
        if counter <= 0{
            stopTimer()
            lblResend.text = "Resend SMS"
            btnResend.isEnabled = true
            lblResendTimer.text = ""
        }
    }
    
    @IBAction func btnBackClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnOtpValidateClicked(_ sender: UIButton) {
        //let profileVC = ProfileVC.instance()
       // self.navigationController?.pushViewController(profileVC, animated: true)
        
        callResendOtpAPI()
    }
    
    func callResendOtpAPI(){
        
        APIManager.shared.request(with: APIEndPoints.generate_otp(countryCode: loginModel.countryCode ?? "", mobile: loginModel.mobile ?? ""), isLoaderNeeded: true) { [weak self]
            response in
            
            switch response {
            case let .success(response):
                print(response)
                
                if let model = response as? loginResponseModel, let otp = model.data?.otp{
                    self?.loginModel.otp = otp
                }
                
            case let .failure(msg, _):
                print(msg)
                
            case let .Warning(msg):
                print(msg)
                
            }
        }
    }
    
    func callVerifyOtpAPI(otp : String){
        
        APIManager.shared.request(with: APIEndPoints.authenticate(countryCode: loginModel.countryCode ?? "", mobile: loginModel.mobile ?? "", otp: otp), isLoaderNeeded: true) { [weak self]
            response in
            
            switch response {
            case let .success(response):
                print(response)
                                
                if let model = response as? UserResponseModel{
                    let profileVC = ProfileVC.instance()
                    profileVC.objUserDataModel = model.data
                    profileVC.objSdkDetailsModel = self?.objSdkDetailsModel
                    self?.navigationController?.pushViewController(profileVC, animated: true)
                }
                
            case let .failure(msg, _):
                print(msg)
                
            case let .Warning(msg):
                print(msg)
                
            }
        }
    }
}


extension OtpVC : UITextFieldDelegate
{
    @objc func editingChanged(_ textField: SingleDigitTextField)
    {
        if textField.pressedDelete
        {
            textField.pressedDelete = false
            if textField.hasText
            {
                textField.text = ""
            }
            else
            {
                switch textField
                {
                    case txtOTP2, txtOTP3, txtOTP4, txtOTP5, txtOTP6:
                        switch textField {
                        case txtOTP2:
                            txtOTP1.isUserInteractionEnabled = true
                            txtOTP1.becomeFirstResponder()
                            txtOTP1.text = ""
                        case txtOTP3:
                            txtOTP2.isUserInteractionEnabled = true
                            txtOTP2.becomeFirstResponder()
                            txtOTP2.text = ""
                        case txtOTP4:
                            txtOTP3.isUserInteractionEnabled = true
                            txtOTP3.becomeFirstResponder()
                            txtOTP3.text = ""
                        case txtOTP5:
                            txtOTP4.isUserInteractionEnabled = true
                            txtOTP4.becomeFirstResponder()
                            txtOTP4.text = ""
                        case txtOTP6:
                            txtOTP5.isUserInteractionEnabled = true
                            txtOTP5.becomeFirstResponder()
                            txtOTP5.text = ""
                        default:
                            break
                        }
                    default: break
                }
            }
        }
        guard textField.text?.count == 1, textField.text?.last?.isWholeNumber == true else
        {
            textField.text = ""
            return
        }

        switch textField
        {
            case txtOTP1, txtOTP2, txtOTP3, txtOTP4, txtOTP5, txtOTP6:
                switch textField {
                case txtOTP1:
                    txtOTP2.isUserInteractionEnabled = true
                    txtOTP2.becomeFirstResponder()
                case txtOTP2:
                    txtOTP3.isUserInteractionEnabled = true
                    txtOTP3.becomeFirstResponder()
                case txtOTP3:
                    txtOTP4.isUserInteractionEnabled = true
                    txtOTP4.becomeFirstResponder()
                case txtOTP4:
                    txtOTP5.isUserInteractionEnabled = true
                    txtOTP5.becomeFirstResponder()
                case txtOTP5:
                    txtOTP6.isUserInteractionEnabled = true
                    txtOTP6.becomeFirstResponder()
                default: break
                }
            case txtOTP6:
            textFieldDidEndEditing(textField)
            print("forth")
            default: break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        var otp = ""
        [txtOTP1,txtOTP2,txtOTP3,txtOTP4,txtOTP5,txtOTP6].forEach
        {
            otp.append($0.text ?? "")
        }
        if otp.count == 6
        {
//            if otp == loginModel.otp{
                callVerifyOtpAPI(otp: otp)
                
//            }
//            else{
//                CommonMethodsClass.showAlertViewOnWindow(titleStr: "", messageStr: "Incorrect OTP", okBtnTitleStr: "OK")
//            }
            
        }

    }
}
