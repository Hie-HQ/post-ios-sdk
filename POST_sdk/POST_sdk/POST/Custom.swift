//
//  Custom.swift
//  POST_sdk
//
//  Created by Apple on 15/04/23.
//

import Foundation
import UIKit
import SVProgressHUD

struct Constants {
    
    static var shared = Constants()
      
    enum DateFormats {
        static var dd_MM_yyyy = "dd/MM/yyyy"
        static var MM_dd_yyyy = "MM-dd-yyyy"
        static var yyyy_MM_dd = "yyyy-MM-dd"
        static var dd_MMM_yyyy = "dd MMM yyyy"
        static var yyyy_mm_dd_hh_mm_ss = "yyyy-MM-dd HH:mm:ss"
        static var mm_dd_yyyy_hh_mm_a = "MM-dd-yyyy HH:mm"
        static var mm_dd_yyyy_hh_mm_aa = "MM-dd-yyyy hh:mm a"
        static var yyyy_mm_dd_hh_mm_ssT = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        static var yyyy_mm_dd_hh_mm_ssZ = "yyyy-MM-dd HH:mm:ss Z"
        static var MMM_d = "MMMM d"
        static var timeFormatAMPM = "h:mm a"
        static var timeFormat24 = "HH:mm"
        static var timeFormat = "HH:mm:ss"
        static var datePickerFormat = "yyyy-MM-dd HH:mm:ss Z"
        static var appDobFormat = "MMMM d, yyyy"
        static var yyyy_mm_ddT_hh_mm_ss = "yyyy-MM-dd'T'HH:mm:ss"
        static var dd = "dd"
        static var MMM = "MMM"
        static var yyyy = "yyyy"
    }
        
    enum NotificationCenterKey{
        static var KSignupSuccess = "signupSuccess"
        static var KSignupFailure = "signupFailure"
    }
    
    enum Base_Url {
        static var Base_Url_Dev = "http://localhost:5000/api/v1/"
    }
    
    enum UserDefultKey{
        static var kAccessToken = "accessToken"
        static var kRefreshToken = "refreshToken"
        static var kAccessTokenExpire = "accessTokenExpire"

    }

    
    
}


class CommonMethodsClass: NSObject {
    
    class func startAnimating(){
        SVProgressHUD.show()
        SVProgressHUD.setBackgroundColor(.clear)
        SVProgressHUD.setForegroundColor(.app_purple)
        SVProgressHUD.setBackgroundLayerColor(.clear)
    }
    
    class func startAnimatingProgress(progress : Float){
        SVProgressHUD.setOffsetFromCenter(UIOffset.init(horizontal: 0, vertical: 70))
        SVProgressHUD.show(UIImage.init(named: "upload")!, status: "\(progress) Uploading")
        SVProgressHUD.setBackgroundColor(.clear)
        SVProgressHUD.setForegroundColor(.app_purple)
    }
    
    class func stopAnimating(){
        SVProgressHUD.dismiss()
    }
    
    
    class func showAlertViewWithActionOnWindow(titleStr: String, messageStr: String, okBtnTitleStr: String, cncelBtnTitleStr: String, completion: @escaping CompletionHandler)
    {
        let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertController.Style.alert)

        let alertAction = UIAlertAction(title: okBtnTitleStr, style: .default) { _ in

            completion(true)
        }

        alert.addAction(UIAlertAction(title: cncelBtnTitleStr, style: UIAlertAction.Style.default, handler: nil))
        alert.addAction(alertAction)
        alert.view.tintColor = UIColor.black
        ez.topMostVC?.present(alert, animated: true, completion: nil)
    }

    class func showAlertViewWithCancelActionOnWindow(titleStr: String, messageStr: String, okBtnTitleStr: String, cncelBtnTitleStr: String, completion: @escaping CompletionHandler)
    {
        let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertController.Style.alert)

        let alertAction = UIAlertAction(title: okBtnTitleStr, style: .default) { _ in

            completion(true)
        }

        let cancelAction = UIAlertAction(title: cncelBtnTitleStr, style: .default) { _ in

            completion(false)
        }

        alert.addAction(cancelAction)
        alert.addAction(alertAction)
        alert.view.tintColor = UIColor.black
        ez.topMostVC?.present(alert, animated: true, completion: nil)
    }

    class func showAlertViewWithSingleActionOnWindow(titleStr title: String? = "", messageStr: String, okBtnTitleStr: String, completion: @escaping CompletionHandler)
    {
        let alert = UIAlertController(title: title, message: messageStr, preferredStyle: UIAlertController.Style.alert)

        let alertAction = UIAlertAction(title: okBtnTitleStr, style: .default) { _ in

            completion(true)
        }
        alert.addAction(alertAction)
        alert.view.tintColor = UIColor.black
        ez.topMostVC?.present(alert, animated: true, completion: nil)
    }

    class func showAlertViewOnWindow(titleStr _: String, messageStr: String?, okBtnTitleStr: String) {
        let alert = UIAlertController(title: "", message: messageStr ?? "", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: okBtnTitleStr, style: UIAlertAction.Style.default, handler: nil))
        alert.view.tintColor = UIColor.black
        ez.topMostVC?.present(alert, animated: true, completion: nil)
    }
    
    class func getRefreshToken() -> String {
        if let token = DBManager.accessUserDefaultsForKey(keyStr: Constants.UserDefultKey.kRefreshToken) as? String {
            return token
        }
        return ""
    }
    
    class func getAccessTokenExpire() -> String {
        if let token = DBManager.accessUserDefaultsForKey(keyStr: Constants.UserDefultKey.kAccessTokenExpire) as? String {
            return token
        }
        return ""
    }
    
    class func minutesBetweenDates(_ oldDate: Date, _ newDate: Date) -> CGFloat {

        //get both times sinces refrenced date and divide by 60 to get minutes
        let newDateMinutes = newDate.timeIntervalSinceReferenceDate/60
        let oldDateMinutes = oldDate.timeIntervalSinceReferenceDate/60
        //then return the difference
        return CGFloat(oldDateMinutes - newDateMinutes)
    }
    
}

struct ez {
    static var topMostVC: UIViewController? {
       let topVC = UIApplication.topViewController()
       if topVC == nil {
           print("EZSwiftExtensions Error: You don't have any views set. You may be calling them in viewDidLoad. Try viewDidAppear instead.")
       }
       return topVC
   }
}


extension UIApplication {

    class func topViewController(_ base: UIViewController? = Constants.shared.appDelegate.window?.rootViewController) -> UIViewController? {
    if let nav = base as? UINavigationController {
        return topViewController(nav.visibleViewController)
    }
    if let tab = base as? UITabBarController {
        if let selected = tab.selectedViewController {
            return topViewController(selected)
        }
    }
    if let presented = base?.presentedViewController {
        return topViewController(presented)
    }
    return base
}

}
