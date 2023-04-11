//
//  OtpVC.swift
//  POST_sdk
//
//  Created by Apple on 09/04/23.
//

import Foundation
import UIKit

public protocol OtpVCDelegate : class {
    func otpBackClicked()
    func otpValidate()
}

public class OtpVC: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblResend: UILabel!
    @IBOutlet weak var lblResendTimer: UILabel!
    @IBOutlet weak var vWResend: UIView!
    
    @IBOutlet weak var vWOTP1: UIView!
    @IBOutlet weak var vWOTP2: UIView!
    @IBOutlet weak var vWOTP3: UIView!
    @IBOutlet weak var vWOTP4: UIView!
    
    @IBOutlet weak var txtOTP1: UITextField!
    @IBOutlet weak var txtOTP2: UITextField!
    @IBOutlet weak var txtOTP3: UITextField!
    @IBOutlet weak var txtOTP4: UITextField!
    
    public weak var delegate: OtpVCDelegate?

    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func setUI(){
        
        vWResend.setCornerRadious(corner: vWResend.frame.height / 2)
        vWResend.setBorder(width: 1, color: UIColor.init(hexString: "DDDDDD"))
        
        vWOTP1.setCornerRadious(corner: vWResend.frame.height / 2)
        vWOTP2.setCornerRadious(corner: vWResend.frame.height / 2)
        vWOTP3.setCornerRadious(corner: vWResend.frame.height / 2)
        vWOTP4.setCornerRadious(corner: vWResend.frame.height / 2)

    }
    
    @IBAction func btnBackClicked(_ sender: UIButton) {
        delegate?.otpBackClicked()
    }
    
    @IBAction func btnOtpValidateClicked(_ sender: UIButton) {
        delegate?.otpValidate()
    }
    
}
