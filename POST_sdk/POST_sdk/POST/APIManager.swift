//
//  APIManager.swift
//  POST_sdk
//
//  Created by Apple on 15/04/23.
//

import Foundation
import SwiftyJSON

class APIManager: NSObject {
    typealias Completion = (Response) -> Void
    static let shared = APIManager()
    private lazy var httpClient = HTTPClient()
    
    func request(with api: Router, isLoaderNeeded: Bool, completion: @escaping Completion) {
        
        if isLoaderNeeded {
            CommonMethodsClass.stopAnimating()
            CommonMethodsClass.startAnimating()
        }
        
        let myGroup = DispatchGroup()
        myGroup.enter()
        
        let tokenExpire: String = CommonMethodsClass.getAccessTokenExpire()
        
        let myDateFormatter = DateFormatter()
        myDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        if let oldDate: Date = myDateFormatter.date(from: tokenExpire){
            debugPrint("Expiry time remain",CommonMethodsClass.minutesBetweenDates(oldDate, Date()))
            debugPrint("Expiry time remain status",CommonMethodsClass.minutesBetweenDates(oldDate, Date()) > 10)
            
            if CommonMethodsClass.minutesBetweenDates(oldDate, Date()) > 15 {
                myGroup.leave()
            }
            else{
                if CommonMethodsClass.getRefreshToken() == ""{
                    myGroup.leave()
                }
                else{
                    requestRefreshToken(with: APIEndPoints.refresh_token(refresh_token: CommonMethodsClass.getRefreshToken()), isLoaderNeeded: true) { response in
                        myGroup.leave()
                    }
                }
            }
        }
        else{
            myGroup.leave()
        }
        
        
        if api.method == .get {
            httpClient.getRequest(withApi: api, success: { data in
                
                DispatchQueue.main.async {
                    CommonMethodsClass.stopAnimating()
                }
                
                guard let response = data else {
                    completion(Response.failure(.none, 200))
                    return
                }
                let json = JSON(response)
                
                let responseType = json[Keys.status_code.rawValue].intValue
                
                if responseType == 200 {
                    let object: AnyObject?
                    object = api.handle(data: response)
                    completion(Response.success(object))
                }
                else if responseType == 401{
                    self.requestRefreshToken(with: APIEndPoints.refresh_token(refresh_token: CommonMethodsClass.getRefreshToken()), isLoaderNeeded: true) { response in
                    }
                }
                else {
                    completion(Response.failure(json[Keys.error.rawValue].stringValue, 200))
                }
                
            }, failure: { _ in
                
                if Connectivity.isConnectedToInternet == false {
                    CommonMethodsClass.showAlertViewOnWindow(titleStr: Keys.error.rawValue, messageStr: "The Internet connection appears to be offline.", okBtnTitleStr: "OK")
                } else {
                    CommonMethodsClass.showAlertViewOnWindow(titleStr: Keys.error.rawValue, messageStr: "Something went wrong. Please try again.", okBtnTitleStr: "OK")
                }
                
                CommonMethodsClass.showAlertViewOnWindow(titleStr: Keys.error.rawValue, messageStr: "Something went wrong. Please try again.", okBtnTitleStr: "OK")
                DispatchQueue.main.async {
                    CommonMethodsClass.stopAnimating()
                }
            })
        } else if api.method == .patch {
            httpClient.patchRequesr(withApi: api, success: { data in
                
                DispatchQueue.main.async {
                    CommonMethodsClass.stopAnimating()
                }
                
                guard let response = data else {
                    completion(Response.failure(.none, 200))
                    return
                }
                let json = JSON(response)
                
                let responseType = json[Keys.status_code.rawValue].intValue
                
                if responseType == 200 {
                    let object: AnyObject?
                    object = api.handle(data: response)
                    completion(Response.success(object))
                } else if responseType == 401{
                    self.requestRefreshToken(with: APIEndPoints.refresh_token(refresh_token: CommonMethodsClass.getRefreshToken()), isLoaderNeeded: true) { response in
                    }
                } else {
                    completion(Response.failure(json[Keys.error.rawValue].stringValue, 200))
                }
                
            }, failure: { _ in
                
                if Connectivity.isConnectedToInternet == false {
                    CommonMethodsClass.showAlertViewOnWindow(titleStr: Keys.error.rawValue, messageStr: "The Internet connection appears to be offline.", okBtnTitleStr: "OK")
                } else {
                    CommonMethodsClass.showAlertViewOnWindow(titleStr: Keys.error.rawValue, messageStr: "Something went wrong. Please try again.", okBtnTitleStr: "OK")
                }
                
                CommonMethodsClass.showAlertViewOnWindow(titleStr: Keys.error.rawValue, messageStr: "Something went wrong. Please try again.", okBtnTitleStr: "OK")
                DispatchQueue.main.async {
                    CommonMethodsClass.stopAnimating()
                }
            })
        } else {
            httpClient.postRequest(withApi: api, success: { data in
                
                DispatchQueue.main.async {
                    CommonMethodsClass.stopAnimating()
                }
                
                guard let response = data else {
                    completion(Response.failure(.none, 200))
                    return
                }
                let json = JSON(response)
                
                let responseType = json[Keys.status_code.rawValue].intValue
                
                if responseType == 200 {
                    let object: AnyObject?
                    object = api.handle(data: response)
                    completion(Response.success(object))
                } else if responseType == 401{
                    self.requestRefreshToken(with: APIEndPoints.refresh_token(refresh_token: CommonMethodsClass.getRefreshToken()), isLoaderNeeded: true) { response in
                    }
                } else {
                    completion(Response.failure(json[Keys.error.rawValue].stringValue, 200))
                }
                
            }, failure: { _ in
                
                if Connectivity.isConnectedToInternet == false {
                    CommonMethodsClass.showAlertViewOnWindow(titleStr: Keys.error.rawValue, messageStr: "The Internet connection appears to be offline.", okBtnTitleStr: "OK")
                } else {
                    CommonMethodsClass.showAlertViewOnWindow(titleStr: Keys.error.rawValue, messageStr: "Something went wrong. Please try again.", okBtnTitleStr: "OK")
                }
                
                CommonMethodsClass.showAlertViewOnWindow(titleStr: Keys.error.rawValue, messageStr: "Something went wrong. Please try again.", okBtnTitleStr: "OK")
                DispatchQueue.main.async {
                    CommonMethodsClass.stopAnimating()
                }
            })
        }
    }
    
    func uploadImage(with api: Router, imgData: Data, isLoaderNeeded: Bool, completion: @escaping Completion) {
        DispatchQueue.main.async {
            CommonMethodsClass.startAnimating()
            CommonMethodsClass.stopAnimating()
        }
        print("api@@", api)
        httpClient.uploadImage(api: api, imgData: imgData, success: { data in
            
            DispatchQueue.main.async {
                CommonMethodsClass.stopAnimating()
            }
            
            guard let response = data else {
                completion(Response.failure(.none, 200))
                return
            }
            let json = JSON(response)
            
            let responseType = json[Keys.status_code.rawValue].intValue
            
            if responseType == 200 {
                let object: AnyObject?
                object = api.handle(data: response)
                completion(Response.success(object))
            } else if responseType == 404 || responseType == 403 {
                
            } else {
                completion(Response.failure(json[Keys.error.rawValue].stringValue, 200))
            }
            
        }, failure: { _ in
            
            DispatchQueue.main.async {
                CommonMethodsClass.stopAnimating()
            }
        })
    }
    
    func uploadImages(with api: Router, imgData: [Data], fileType: String, withPrmName: String, isLoaderNeeded: Bool, completion: @escaping Completion) {
        DispatchQueue.main.async {
            CommonMethodsClass.startAnimating()
            CommonMethodsClass.stopAnimating()
        }
        
        httpClient.uploadImages(api: api, imgData: imgData, fileType: fileType, withName: withPrmName, success: { data in
            
            DispatchQueue.main.async {
                CommonMethodsClass.stopAnimating()
            }
            
            guard let response = data else {
                completion(Response.failure(.none, 200))
                return
            }
            let json = JSON(response)
            
            let responseType = json[Keys.status_code.rawValue].intValue
            
            if responseType == 200 {
                let object: AnyObject?
                object = api.handle(data: response)
                completion(Response.success(object))
            } else if responseType == 404 || responseType == 403 {
                DispatchQueue.main.async {
                    //redirect to login screen
                    
                }
            } else {
                completion(Response.failure(json[Keys.error.rawValue].stringValue, 200))
            }
            
        }, failure: { _ in
            
            DispatchQueue.main.async {
                CommonMethodsClass.stopAnimating()
            }
        })
    }
    
    func requestRefreshToken(with api: Router, isLoaderNeeded: Bool, completion: @escaping Completion) {
        if isLoaderNeeded {
            CommonMethodsClass.stopAnimating()
            CommonMethodsClass.startAnimating()
        }
        
            httpClient.postRequest(withApi: api, success: { data in
            
            DispatchQueue.main.async {
                CommonMethodsClass.stopAnimating()
            }
            
            guard let response = data else {
                completion(Response.failure(.none, 200))
                return
            }
            let json = JSON(response)
            
            let responseType = json[Keys.status_code.rawValue].intValue
            
            if responseType == 200 {
                let object: AnyObject?
                object = api.handle(data: response)
               
                completion(Response.success(object))
            } else if responseType == 401 {
                    
            } else {
                completion(Response.failure(json[Keys.error.rawValue].stringValue, 200))
            }
            
        }, failure: { _ in
            
        })
    }
        
}
