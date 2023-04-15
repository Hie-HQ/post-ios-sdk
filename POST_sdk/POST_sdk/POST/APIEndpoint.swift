//
//  APIEndpoint.swift
//  POST_sdk
//
//  Created by Apple on 15/04/23.
//

import Foundation
//import Alamofire
import SwiftUI

typealias OptionalDictionary = [String: Any]?

protocol Router {
    var route: String { get }
    var baseURL: String { get }
    var parameters: OptionalDictionary { get }
    var method: Alamofire.HTTPMethod { get }
    var header: HTTPHeaders { get }
    func handle(data: Any) -> AnyObject?
}

extension Sequence where Iterator.Element == Keys {
    func map(values: [Any?]) -> OptionalDictionary {
        var params = [String: Any]()

        for (index, element) in zip(self, values) {
            if element != nil {
                params[index.rawValue] = element
            }
        }
        return params
    }
}


enum APIEndPoints {
    

    case authenticate_sdk_user(clientId: String, clientSecret: String)
    case generate_otp(countryCode: String, mobile: String)
    case authenticate(countryCode: String, mobile: String, otp: String)
    case refresh_token(refreshToken: String)
    case get_user_profile(id : Int)
    case update_user_profile(id : Int)

}


extension APIEndPoints: Router {
   
    var route: String {
        
        switch self {
            
        case .authenticate_sdk_user: return APIConstants.authenticate_sdk_user

        case .generate_otp: return APIConstants.generate_otp

        case .authenticate: return APIConstants.authenticate

        case .refresh_token: return APIConstants.refresh_token
       
        case let .get_user_profile(id): return "\(APIConstants.get_user_profile)/\(id)"
            
        case let .update_user_profile(id): return "\(APIConstants.update_user_profile)/\(id)"

       
        }
    }

    var parameters: OptionalDictionary {
        return format()
    }

    var method: Alamofire.HTTPMethod {
        
        switch self {
            
        case .get_user_profile  : return .get
            
        case .update_user_profile : return .put

        default: return .post
        }
    }

    var baseURL: String {
        return Constants.Base_Url.Base_Url_Dev
    }


    var header: HTTPHeaders {
        if let accessToken = DBManager.accessUserDefaultsForKey(keyStr: Constants.UserDefultKey.kAccessToken) as? String {
            return ["Authorization": "Bearer \(accessToken)"]
        } else { return [:] }
    }

    func format() -> OptionalDictionary {
        switch self {
        case let .authenticate_sdk_user(clientId, clientSecret):
            return Parameters.authenticate_sdk_user.map(values: [clientId, clientSecret])
            
        case let .generate_otp(countryCode, mobile):
            return Parameters.generate_otp.map(values: [countryCode, mobile])
            
        case let .authenticate(countryCode, mobile, otp):
            return Parameters.authenticate.map(values: [countryCode, mobile, otp])
            
        case let .refresh_token(refreshToken):
            return Parameters.refresh_token.map(values: [refreshToken])
            

        default:
            return nil
        }
    }
}
