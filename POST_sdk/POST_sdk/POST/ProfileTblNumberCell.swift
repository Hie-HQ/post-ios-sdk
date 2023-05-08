//
//  ProfileTblNumberCell.swift
//  POST_sdk
//
//  Created by Apple on 17/04/23.
//

import UIKit

class ProfileTblNumberCell: UITableViewCell {

    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var vWRoundView: UIView!
    
    var objFormFieldsModel : FormFieldsModel?
    weak var delegate: formValueChangedDelegate?
    var selectedRow : Int?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        vWRoundView.setCornerRadious(corner: vWRoundView.frame.height / 2)
        vWRoundView.setBorder(width: 1, color: UIColor.init(hexString: "DDDDDD"))
        txtField.delegate = self

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupData(obj : FormFieldsModel?, row : Int?){
        objFormFieldsModel = obj
        txtField.placeholder = obj?.placeholder
        txtField.text = obj?.value
        selectedRow = row

    }
    
}

extension ProfileTblNumberCell : UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        objFormFieldsModel?.value = textField.text
        delegate?.formValueChanged(obj: objFormFieldsModel, row: selectedRow)
    }
}
