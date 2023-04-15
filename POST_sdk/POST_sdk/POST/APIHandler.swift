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
    
        case .authenticate, .generate_otp, .authenticate_sdk_user:
            do {
                let jsonData = try JSON(data).rawData()
                let jsonDecoder = JSONDecoder()
                let apiResponse = try jsonDecoder.decode(ProfileModel.self, from: jsonData)
                return apiResponse as AnyObject?
            } catch let jsonError as NSError {
                print("ProfileModel issue",String(describing: jsonError))
            }
            return [] as AnyObject?

        default:
            return data as AnyObject
        }
    }
    
}
