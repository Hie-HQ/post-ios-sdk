//
//  OnboardingVC.swift
//  POST_sdk
//
//  Created by Apple on 13/04/23.
//

import UIKit

public protocol OnboardingVCDelegate : class {
    func OnboardingSuccess()
    func OnboardingFailed()
}

public class OnboardingVC: UIView {

    var viewController : UIViewController?
    public weak var delegate: OnboardingVCDelegate?

    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func openLogin(vc : UIViewController){
        viewController = vc
        let loginVC = LoginVC.instance()
        loginVC.delegate = self
        let navController = UINavigationController(rootViewController: loginVC)
        navController.navigationBar.isHidden = true
        navController.modalPresentationStyle = .fullScreen
        viewController?.present(navController, animated:false, completion: nil)
    }
    
}


extension OnboardingVC : LoginVCDelegate{
    public func loginSuccess() {
        viewController?.dismiss(animated: false)
        delegate?.OnboardingSuccess()
    }
    
    public func loginFailure() {
        delegate?.OnboardingFailed()
    }
    
}
