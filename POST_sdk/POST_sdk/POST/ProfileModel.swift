//
//  ProfileModel.swift
//  POST_sdk
//
//  Created by Apple on 11/04/23.
//

import Foundation
import UIKit


class ProfileModel {
    var placeholder : String = ""
    var isDateField : Bool = false
    
    init(placeholder: String, isDateField: Bool) {
        self.placeholder = placeholder
        self.isDateField = isDateField
    }
    
    init() {
        
    }
}
