//
//  APIConstants.swift
//  POST_sdk
//
//  Created by Apple on 15/04/23.
//

import Foundation
import SwiftUI


internal enum APIConstants {
        
    static let generate_otp = "sdk-user/auth/generate-otp"
    static let authenticate_sdk_user = "sdk-user/auth/sdk"
    static let authenticate = "sdk-user/auth/authenticate"
    static let refresh_token = "sdk-user/auth/refresh-token"
    static let get_user_profile = "sdk-user/profile"
    static let update_user_profile = "sdk-user/profile"

}

enum Parameters {
    
    static let authenticate_sdk_user: [Keys] = [.clientId, .clientSecret]
    static let generate_otp: [Keys] = [.countryCode, .mobile]
    static let authenticate: [Keys] = [.countryCode, .mobile, .otp]
    static let refresh_token: [Keys] = [.refreshToken]
    static let update_user_profile: [Keys] = [.step, .payload]

}

enum Validate: Int {
    case none
    case success = 200
    case failure = 404

    func map(response message: String?) -> String? {
        switch self {
        case .success:
            return message
        case .failure:
            return message
        default:
            return nil
        }
    }
}

enum Response {
    case success(AnyObject?)
    case Warning(String?)
    case failure(String?, Int?)
}

enum Keys: String {
    case message
    case token
    case Success = "Success"
    case error = "error"
    case clientId
    case clientSecret
    case countryCode
    case mobile
    case otp
    case refreshToken
    case status_code = "statusCode"
    case step
    case payload

}

enum FormFieldType: String {
    case text
    case date
    case select
    case number
    case textarea
}
