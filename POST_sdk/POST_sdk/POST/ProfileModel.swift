//
//  ProfileModel.swift
//  POST_sdk
//
//  Created by Apple on 11/04/23.
//

import Foundation
import UIKit
import SwiftyJSON

class ProfileModel : Codable{
    var placeholder : String = ""
    var isDateField : Bool = false
    
    init(placeholder: String, isDateField: Bool) {
        self.placeholder = placeholder
        self.isDateField = isDateField
    }
    
    init() {
        
    }
}

class LoginModel : Codable{
    var mobile : String = ""
    var countryCode : String = ""
    var otp : String = ""

    init(mobile: String, countryCode: String, otp: String) {
        self.mobile = mobile
        self.countryCode = countryCode
        self.otp = otp
    }
    
    init() {
        
    }
}


struct sdkResponseModel: Codable {
    let status: Bool?
    let message: String?
    let statusCode: Int?
    let data: sdkDetailsModel?
    let error: String?
}

struct sdkDetailsModel: Codable {
    let company: sdkDetailsCompanyModel?
    let customForm: sdkDetailsCustomFormModel?
    let tokens: Token_Access_Refresh?
}


struct sdkDetailsCustomFormModel: Codable{
    let backgroundColor: String?
    let backgroundImage: String?
    let brandLogo: String?
    let brandName: String?
    let customForm: JSON?
    let formName: String?
    let brandNameColor: String?
    let buttonTextColor : String?
    let buttonColor: String?
    
}

struct sdkDetailsCompanyModel: Codable {
    let _id: String?
    let companyEmployees: [String]?
    let companySecrets: [String]?
    let isApproved: Bool?
    let name: String?
}

struct Token_Access_Refresh: Codable {
    let access : Token?
    let refresh : Token?
}

struct Token: Codable {
    let token : String?
    let expires : String?
}

struct loginResponseModel: Codable {
    let status: Bool?
    let message: String?
    let statusCode: Int?
    let data: loginDataModel?
    let error: String?
}

struct loginDataModel: Codable {
    let otp : String?
}

struct UserResponseModel: Codable {
    let status: Bool?
    let message: String?
    let statusCode: Int?
    var data: UserDataModel?
    let error: String?
}

struct UserDataModel: Codable {
    var customForm : UserCustomFormModel?
    var user : UserDetailModel?
}

struct UserDetailModel: Codable {
    var addresses : [UserAddressModel]?
    let dob : String?
    let firstName : String?
    let gender : String?
    let id : String?
    let isActive : Bool?
    let lastName : String?
    let username : String?
}

struct UserAddressModel: Codable {
    let _id : String?
    let address1 : String?
    let address2 : String?
    let city : String?
    let country : String?
    let isActive : Bool?
    var isDefault : Bool? = false
    let landmark : String?
    let pinCode : String?
    let state : String?
    let type : String?

}

struct UserCustomFormModel: Codable {
    let backgroundColor : String?
    let backgroundImage : String?
    let brandLogo : String?
    let brandName : String?
    let brandLogoBorderColor: String?
    let brandNameColor: String?
    let buttonColor: String?
    let buttonTextColor: String?
    let fieldBorderColor: String?
    let fieldLabelColor: String?
    let fieldTextColor: String?
    let teamCondition: String?
    var customForm : [CustomFormModel]?
}

struct CustomFormModel: Codable {
    var fields : [FormFieldsModel]?
    var key : String?
    var skipAble : Bool?
}

struct FormFieldsModel: Codable {
    let key : String?
    let label : String?
    let placeholder : String?
    let required : Bool?
    let type : String?
//    let validations : JSON?
    let validations : [FormValidationsModel]?
    let options : [FormOptionsModel]?
    var value : String?
    var valueKey : String?

}

struct FormOptionsModel: Codable {
    let key : String?
    let label : String?
}

struct FormValidationsModel: Codable {
    let message : String?
    let min : Int?
    let max : Int?
}

extension Dictionary where Key == String, Value: Any {

    func object<T: Decodable>() -> T? {
        if let data = try? JSONSerialization.data(withJSONObject: self, options: []) {
            return try? JSONDecoder().decode(T.self, from: data)
        } else {
            return nil
        }
    }
}
