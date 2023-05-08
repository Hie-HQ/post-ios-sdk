//
//  ProfileVC.swift
//  POST_sdk
//
//  Created by Apple on 11/04/23.
//

import Foundation
import UIKit
import IQKeyboardManager

protocol ProfileVCDelegate : class {
    func profileBackClicked()
    func profileBtnContinueClicked()
}

class ProfileVC: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgApp: UIImageView!
    @IBOutlet weak var imgBackGround: UIImageView!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var tblProfile: UITableView!
    @IBOutlet weak var tblProfileHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnTerms: UIButton!
    @IBOutlet weak var btnTermsCheck: UIButton!
    @IBOutlet weak var vWTermsCheck: UIView!
    
    @IBOutlet weak var btnSaveAddress: UIButton!
    @IBOutlet weak var btnAddNewAddress: UIButton!
    @IBOutlet weak var vwStackProfile: UIStackView!
    @IBOutlet weak var vwStackAddress: UIStackView!
    @IBOutlet weak var tblAddress: UITableView!
    @IBOutlet weak var tblAddressHeightConstraint: NSLayoutConstraint!

    weak var delegate: ProfileVCDelegate?
    var objSdkDetailsModel : sdkDetailsModel?
    var objUserDataModel : UserDataModel?
    var formIndex : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setupSDKData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        IQKeyboardManager.shared().isEnabled = true
        
    }
       
    func setupSDKData(){
        
        
        if let appImage = objSdkDetailsModel?.customForm?.brandLogo,let urlStr = URL(string: "\(Constants.Base_Url.Base_Url_AWS_Dev)\(appImage)"){
            imgApp.isHidden = false
            imgApp.kf.setImage(with: urlStr)
            lblTitle.isHidden = true
        }
        else{
            imgApp.isHidden = true
            
            if let appName = objSdkDetailsModel?.customForm?.brandName{
                lblTitle.isHidden = false
                lblTitle.text = appName
                
            }
            else{
                lblTitle.isHidden = true
            }
        }
        
        if let brandNameColor = objSdkDetailsModel?.customForm?.backgroundColor {
            lblTitle.textColor = UIColor.init(hexString: brandNameColor)
        }
        
        if let imgBG = objSdkDetailsModel?.customForm?.backgroundImage,let urlStr = URL(string: "\(Constants.Base_Url.Base_Url_AWS_Dev)\(imgBG)"){
            imgBackGround.kf.setImage(with: urlStr)
        }
        else{
            if let colorBG = objSdkDetailsModel?.customForm?.backgroundColor{
                self.view.backgroundColor = UIColor.init(hexString: colorBG)
            }
        }
        
        if let url = objUserDataModel?.customForm?.teamCondition{
            vWTermsCheck.isHidden = false
        }
        
        if objUserDataModel?.customForm?.customForm?.count ?? 0 > 0{
            formIndex = 0
            if let index = formIndex{
                tblProfileHeightConstraint.constant = CGFloat((objUserDataModel?.customForm?.customForm?[index].fields?.count ?? 0) * 72)
                
                if objUserDataModel?.customForm?.customForm?[index].key == "address",objUserDataModel?.user?.addresses?.count ?? 0 > 0{
                        tblAddressHeightConstraint.constant = CGFloat((objUserDataModel?.user?.addresses?.count ?? 0) * 72)
                        self.tblAddress.reloadData()
                        showAddressSetup(isShow: true)
                }
                else{
                    showAddressSetup(isShow: false)

                }

            }
            self.tblProfile.reloadData()
            
        }
        
        
    
    }
        
    func setUI(){
        
        btnContinue.setCornerRadious(corner: btnContinue.frame.height / 2)
        btnSaveAddress.setCornerRadious(corner: btnSaveAddress.frame.height / 2)
        btnAddNewAddress.setCornerRadious(corner: btnAddNewAddress.frame.height / 2)

        let bundle = Bundle(for: ProfileVC.self)

        tblProfile.register(UINib.init(nibName: "ProfileTblCell", bundle: bundle), forCellReuseIdentifier: "ProfileTblCell")
        tblProfile.register(UINib.init(nibName: "ProfileTblTextCell", bundle: bundle), forCellReuseIdentifier: "ProfileTblTextCell")
        tblProfile.register(UINib.init(nibName: "ProfileTblDateCell", bundle: bundle), forCellReuseIdentifier: "ProfileTblDateCell")
        tblProfile.register(UINib.init(nibName: "ProfileTblSelectCell", bundle: bundle), forCellReuseIdentifier: "ProfileTblSelectCell")
        tblProfile.register(UINib.init(nibName: "ProfileTblTextareaCell", bundle: bundle), forCellReuseIdentifier: "ProfileTblTextareaCell")
        tblProfile.register(UINib.init(nibName: "ProfileTblNumberCell", bundle: bundle), forCellReuseIdentifier: "ProfileTblNumberCell")

        tblAddress.register(UINib.init(nibName: "ProfileTblAddressCell", bundle: bundle), forCellReuseIdentifier: "ProfileTblAddressCell")
        tblAddress.register(UINib.init(nibName: "ProfileTblCell", bundle: bundle), forCellReuseIdentifier: "ProfileTblCell")


    }
    
    func isValid() -> Bool{
        
        if let index = formIndex, let array = objUserDataModel?.customForm?.customForm?[index].fields{
                        
            for (indexObj, Obj) in array.enumerated(){
                
                if Obj.required ?? false{
                    
                    if Obj.valueKey ?? "" == ""{
                        if Obj.value ?? "" == ""{
                            CommonMethodsClass.showAlertViewOnWindow(titleStr: "", messageStr: "\(Obj.label ?? "") is required", okBtnTitleStr: "Ok")
                            return false
                        }
                    }
                }
                
            }
        }
        return true
    }
    
    func isValidSaveAddress() -> Bool{
        
        if let index = formIndex, let array = objUserDataModel?.user?.addresses{
            var isDefultAddressID = ""
            for (indexObj, Obj) in array.enumerated(){
                
                if Obj.isDefault ?? false{
                    isDefultAddressID = Obj._id ?? ""
                }
            }
            
            if isDefultAddressID == ""{
                CommonMethodsClass.showAlertViewOnWindow(titleStr: "", messageStr: "Please select any one address", okBtnTitleStr: "Ok")
                return false
            }
        }
        return true
    }
    
    func showAddressSetup(isShow : Bool = false){
        if isShow{
            vwStackAddress.isHidden = false
            vwStackProfile.isHidden = true
        }
        else{
            vwStackAddress.isHidden = true
            vwStackProfile.isHidden = false
        }
    }
    
    @IBAction func btnAddNewAddressClicked(_ sender: UIButton) {
        showAddressSetup(isShow: false)
    }
    
    @IBAction func btnSaveAddressClicked(_ sender: UIButton) {
        if isValidSaveAddress(){
            if let id = objUserDataModel?.user?.id, let address = objUserDataModel?.user?.addresses?.first(where: {$0.isDefault == true}){
                var payload = [String:String]()
                payload["id"] = address._id
                callUpdateProfile(id: id, step: "address", payload: payload)
            }
        }
    }
    
    @IBAction func btnBackClicked(_ sender: UIButton) {
        
    }
    
    @IBAction func btnTermsClicked(_ sender: UIButton) {
        btnTermsCheck.isSelected = !btnTermsCheck.isSelected
    }
    
    @IBAction func btnTemrsURLClicked(_ sender: UIButton) {
        let otpVC = WebViewVC.instance()
        otpVC.url = objUserDataModel?.customForm?.teamCondition
        self.navigationController?.pushViewController(otpVC, animated: true)
    }
    
    
    @IBAction func btnContinueClicked(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        if isValid(){
            if let id = objUserDataModel?.user?.id, let index = formIndex, let array = objUserDataModel?.customForm?.customForm?[index].fields{
                
                var payload = [String:String]()
                for (indexObj, Obj) in array.enumerated(){
                    if let value = Obj.valueKey {
                        payload[Obj.key ?? ""] = value
                    }
                    else{
                        payload[Obj.key ?? ""] = Obj.value
                    }
                }
                
                if index == 0, vWTermsCheck.isHidden == false,btnTermsCheck.isSelected{
                    vWTermsCheck.isHidden = true
                    callUpdateProfile(id: id, step: objUserDataModel?.customForm?.customForm?[index].key ?? "", payload: payload)
                }
                else{
                    callUpdateProfile(id: id, step: objUserDataModel?.customForm?.customForm?[index].key ?? "", payload: payload)
                }
            }
        }
        
      
           
        
    }
}



extension ProfileVC : UITableViewDelegate, UITableViewDataSource{
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         
         if  tableView == tblProfile{
             
             if let index = formIndex{
                 return objUserDataModel?.customForm?.customForm?[index].fields?.count ?? 0
             }
             else
             {
                 return 0
             }
             
         }
         else{
             return objUserDataModel?.user?.addresses?.count ?? 0
         }
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
         if  tableView == tblProfile{
             
             
             if let index = formIndex, let formData = objUserDataModel?.customForm?.customForm?[index].fields?[indexPath.row]{
                 
                 switch formData.type{
                 case FormFieldType.text.rawValue:
                     let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTblTextCell") as! ProfileTblTextCell
                     cell.setupData(obj: formData, row: indexPath.row)
                     cell.delegate = self
                     return cell
                 case FormFieldType.date.rawValue:
                     let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTblDateCell") as! ProfileTblDateCell
                     cell.setupData(obj: formData, row: indexPath.row)
                     cell.delegate = self
                     return cell
                 case FormFieldType.select.rawValue:
                     let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTblSelectCell") as! ProfileTblSelectCell
                     cell.setupData(obj: formData, row: indexPath.row)
                     cell.delegate = self
                     return cell
                 case FormFieldType.textarea.rawValue:
                     let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTblTextareaCell") as! ProfileTblTextareaCell
                     cell.setupData(obj: formData, row: indexPath.row)
                     cell.delegate = self
                     return cell
                 case FormFieldType.number.rawValue:
                     let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTblNumberCell") as! ProfileTblNumberCell
                     cell.setupData(obj: formData, row: indexPath.row)
                     cell.delegate = self
                     return cell
                 default:
                     let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTblCell") as! ProfileTblCell
                     return cell
                 }
             }
             else{
                 let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTblCell") as! ProfileTblCell
                 return cell
             }
             
         }
         else{
             if let addressData = objUserDataModel?.user?.addresses?[indexPath.row]{
                 
                 let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTblAddressCell") as! ProfileTblAddressCell
                 cell.setupData(obj: addressData, row: indexPath.row)
                 cell.delegate = self
                 return cell
             }
             else{
                 let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTblCell") as! ProfileTblCell
                 return cell
             }
         }

    }
    
}


extension ProfileVC : formValueChangedDelegate{
    func formValueChanged(obj: FormFieldsModel?, row: Int?) {
        if let index = formIndex, let selectedRow = row, let selectedObj = obj{
            objUserDataModel?.customForm?.customForm?[index].fields?[selectedRow] = selectedObj
//            self.tblProfile.reloadData()
        }
    }
}

extension ProfileVC : AddressValueChangedDelegate{
    
    func addressValueChanged(obj: UserAddressModel?, row: Int?) {
        
        if let array = self.objUserDataModel?.user?.addresses, let selectedRow = row, let selectedObj = obj{
            
            for (indexObj, obj) in array.enumerated(){
                self.objUserDataModel?.user?.addresses?[indexObj].isDefault = false
            }
            
            self.objUserDataModel?.user?.addresses?[selectedRow] = selectedObj
            self.tblAddress.reloadData()

        }
    }
    
}


extension ProfileVC {
    
    func callUpdateProfile(id : String, step : String, payload : [String:String]){
        
        APIManager.shared.request(with: APIEndPoints.update_user_profile(id: id, step: step, payload: payload), isLoaderNeeded: true) { [weak self]
            response in
            
            switch response {
            case let .success(response):
                print(response)
                
                if let index = self?.formIndex,  self?.objUserDataModel?.customForm?.customForm?.count ?? 0 > index + 1{
                    self?.formIndex = index + 1
                    if let index =  self?.formIndex{
                        self?.tblProfileHeightConstraint.constant = CGFloat((self?.objUserDataModel?.customForm?.customForm?[index].fields?.count ?? 0) * 72)
                        
                        if self?.objUserDataModel?.customForm?.customForm?[index].key == "address",self?.objUserDataModel?.user?.addresses?.count ?? 0 > 0{
                            self?.tblAddressHeightConstraint.constant = CGFloat((self?.objUserDataModel?.user?.addresses?.count ?? 0) * 72)
                            self?.tblAddress.reloadData()
                            self?.showAddressSetup(isShow: true)
                        }
                        else{
                            self?.showAddressSetup(isShow: false)
                        }
                    }
                    self?.tblProfile.reloadData()
                }
                else{
                    NotificationCenter.default.post(name: Notification.Name(Constants.NotificationCenterKey.KSignupSuccess), object: nil)
                }
 
                
            case let .failure(msg, _):
                print(msg)
                
            case let .Warning(msg):
                print(msg)
                
            }
        }
    }
}
