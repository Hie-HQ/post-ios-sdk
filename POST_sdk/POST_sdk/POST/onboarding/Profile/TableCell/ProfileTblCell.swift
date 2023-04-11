//
//  ProfileTblCell.swift
//  POST_sdk
//
//  Created by Apple on 11/04/23.
//

import UIKit

class ProfileTblCell: UITableViewCell {

    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var vWRoundView: UIView!
    @IBOutlet weak var imgOptionView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        vWRoundView.setCornerRadious(corner: vWRoundView.frame.height / 2)
        vWRoundView.setBorder(width: 1, color: UIColor.init(hexString: "DDDDDD"))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupData(obj : ProfileModel){
        txtField.placeholder = obj.placeholder
        imgOptionView.isHidden = !obj.isDateField
    }
    
}
