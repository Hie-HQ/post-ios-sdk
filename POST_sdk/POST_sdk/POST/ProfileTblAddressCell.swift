//
//  ProfileTblAddressCell.swift
//  POST_sdk
//
//  Created by Apple on 21/04/23.
//

import UIKit

protocol AddressValueChangedDelegate : class {
    
    func addressValueChanged(obj : UserAddressModel?, row : Int?)
    
}

class ProfileTblAddressCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var vWRoundView: UIView!
    @IBOutlet weak var btnSelect: UIButton!

    var objAddressModel : UserAddressModel?
    weak var delegate: AddressValueChangedDelegate?
    var selectedRow : Int?

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
    
    func setupData(obj : UserAddressModel?, row : Int?){
        objAddressModel = obj
        selectedRow = row
        lblTitle.text = "\(obj?.address1 ?? "")" + "\(obj?.address2 ?? "")" + "\(obj?.landmark ?? "")" + "\(obj?.city ?? "")" + "\(obj?.state ?? "")" + "\(obj?.country ?? "")" + "\(obj?.pinCode ?? "")"
        btnSelect.isSelected = obj?.isDefault ?? false
        btnSelect.tintColor = obj?.isDefault ?? false ? UIColor.systemGreen : UIColor.gray
    }
    
    @IBAction func btnSelectClicked(_ sender : UIButton){
        objAddressModel?.isDefault = true
        delegate?.addressValueChanged(obj: objAddressModel, row: selectedRow)
    }
    
}
