//
//  UIView.swift
//  POST_sdk
//
//  Created by Apple on 09/04/23.
//

import Foundation
import UIKit


public extension UIView{
    
    func setCornerRadious(corner : CGFloat){
        self.layer.cornerRadius = corner
        self.layer.masksToBounds = true
    }
    
    func setBorder(width : CGFloat, color : UIColor){
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
}
