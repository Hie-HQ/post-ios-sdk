//
//  ProfileTblSelectCell.swift
//  POST_sdk
//
//  Created by Apple on 17/04/23.
//

import UIKit


class ProfileTblSelectCell: UITableViewCell {

    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var vWRoundView: UIView!
    
    var objFormFieldsModel : FormFieldsModel?
    weak var delegate: formValueChangedDelegate?
    var selectPicker = UIPickerView()
    let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
    var selectedRow : Int?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        vWRoundView.setCornerRadious(corner: vWRoundView.frame.height / 2)
        vWRoundView.setBorder(width: 1, color: UIColor.init(hexString: "DDDDDD"))
        txtField.delegate = self

        setupSelectPicker()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupData(obj : FormFieldsModel?, row : Int?){
        objFormFieldsModel = obj
        txtField.placeholder = obj?.placeholder
        txtField.text = obj?.value
        txtField.accessibilityHint = obj?.valueKey
        selectedRow = row

        if obj?.options?.count ?? 0 > 0{
            selectPicker.selectRow(0, inComponent: 0, animated: true)
        }
        selectPicker.reloadAllComponents()
    }
    
    func setupSelectPicker()
    {
        selectPicker.delegate = self
        selectPicker.dataSource = self
        
        // add toolbar to textField
        txtField.inputAccessoryView = toolbar
        
        // add datepicker to textField
        txtField.inputView = selectPicker
        
        //toolbar properties
        toolbar.barStyle = .default
        toolbar.backgroundColor = .white
        toolbar.barTintColor = .white
        toolbar.tintColor = .white
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(DoneNewsletterPicker))
        done.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0.208424896, blue: 0.3607267141, alpha: 1)], for: .normal)
        
        let items = [flexSpace, done]
        toolbar.items = items
        toolbar.sizeToFit()
    }
    
    @objc func DoneNewsletterPicker(){
        txtField.text = objFormFieldsModel?.options?[selectPicker.selectedRow(inComponent: 0)].label
        txtField.accessibilityHint = objFormFieldsModel?.options?[selectPicker.selectedRow(inComponent: 0)].key
        self.endEditing(true)
    }
    
}

extension ProfileTblSelectCell : UIPickerViewDelegate, UIPickerViewDataSource{
    
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return objFormFieldsModel?.options?.count ?? 0
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return objFormFieldsModel?.options?[row].label
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            txtField.text = objFormFieldsModel?.options?[row].label
            txtField.accessibilityHint = objFormFieldsModel?.options?[row].key

        }
    
}


extension ProfileTblSelectCell : UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        objFormFieldsModel?.valueKey = textField.accessibilityHint
        objFormFieldsModel?.value = textField.text
        delegate?.formValueChanged(obj: objFormFieldsModel, row: selectedRow)
    }
}
