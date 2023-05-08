//
//  APIHandler.swift
//  POST_sdk
//
//  Created by Apple on 15/04/23.
//

import Foundation
import SwiftyJSON

enum ResponseKeys: String {
    case data
}

extension APIEndPoints {
    
    func handle(data: Any) -> AnyObject? {
        switch self {
    
        case .authenticate_sdk_user:
            do {
                let jsonData = try JSON(data).rawData()
                let jsonDecoder = JSONDecoder()
                let apiResponse = try jsonDecoder.decode(sdkResponseModel.self, from: jsonData)
                return apiResponse as AnyObject?
            } catch let jsonError as NSError {
                print("sdkResponseModel issue",String(describing: jsonError))
            }
            return [] as AnyObject?
            
        case .generate_otp:
            do {
                let jsonData = try JSON(data).rawData()
                let jsonDecoder = JSONDecoder()
                let apiResponse = try jsonDecoder.decode(loginResponseModel.self, from: jsonData)
                return apiResponse as AnyObject?
            } catch let jsonError as NSError {
                print("loginResponseModel issue",String(describing: jsonError))
            }
            return [] as AnyObject?

            
        case .authenticate:
            do {
                let jsonData = try JSON(data).rawData()
                let jsonDecoder = JSONDecoder()
                let apiResponse = try jsonDecoder.decode(UserResponseModel.self, from: jsonData)
                return apiResponse as AnyObject?
            } catch let jsonError as NSError {
                print("UserResponseModel issue",String(describing: jsonError))
            }
            return [] as AnyObject?
            
            
        default:
            return data as AnyObject
        }
    }
    
}
