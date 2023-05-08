//
//  ProfileTblDateCell.swift
//  POST_sdk
//
//  Created by Apple on 17/04/23.
//

import UIKit

class ProfileTblDateCell: UITableViewCell {

    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var vWRoundView: UIView!
    @IBOutlet weak var imgOptionView: UIImageView!
    
    weak var delegate: formValueChangedDelegate?
    var objFormFieldsModel : FormFieldsModel?
    var datePicker = UIDatePicker()
    let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
    var selectedRow : Int?


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        vWRoundView.setCornerRadious(corner: vWRoundView.frame.height / 2)
        vWRoundView.setBorder(width: 1, color: UIColor.init(hexString: "DDDDDD"))
        txtField.delegate = self
        setupDatePicker()


    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupDatePicker(){
        
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        datePicker.maximumDate = Date()
        
        // add toolbar to textField
        txtField.inputAccessoryView = toolbar
        
        // add datepicker to textField
        txtField.inputView = datePicker
        
        //toolbar properties
        toolbar.barStyle = .default
        toolbar.backgroundColor = .white
        toolbar.barTintColor = .white
        toolbar.tintColor = .white
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donedatePicker))
        done.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0.208424896, blue: 0.3607267141, alpha: 1)], for: .normal)
        
        //toolbar action
        datePicker.addTarget(self, action: #selector(changedatePicker), for: .valueChanged)
        
        let items = [flexSpace, done]
        toolbar.items = items
        toolbar.sizeToFit()
        
    }
    
    @objc func donedatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.DateFormats.dd_MM_yyyy
        txtField.text = formatter.string(from: datePicker.date)
        formatter.dateFormat = Constants.DateFormats.yyyy_MM_dd
        txtField.accessibilityHint = formatter.string(from: datePicker.date)
        self.endEditing(true)
    }
    
    @objc func changedatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.DateFormats.dd_MM_yyyy
        txtField.text = formatter.string(from: datePicker.date)
        formatter.dateFormat = Constants.DateFormats.yyyy_MM_dd
        txtField.accessibilityHint = formatter.string(from: datePicker.date)
    }
    
    @objc func cancelDatePicker(){
        self.endEditing(true)
    }
    
    
    
    func setupData(obj : FormFieldsModel?, row : Int?){
        objFormFieldsModel = obj
        txtField.placeholder = obj?.placeholder
        imgOptionView.isHidden = false
        txtField.text = obj?.value
        selectedRow = row

    }
    
}

extension ProfileTblDateCell : UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        objFormFieldsModel?.value = textField.text
        objFormFieldsModel?.valueKey = textField.accessibilityHint
        delegate?.formValueChanged(obj: objFormFieldsModel, row: selectedRow)
    }
    
}
