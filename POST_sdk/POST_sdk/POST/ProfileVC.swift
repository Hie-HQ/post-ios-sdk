//
//  ProfileVC.swift
//  POST_sdk
//
//  Created by Apple on 11/04/23.
//

import Foundation
import UIKit

public protocol ProfileVCDelegate : class {
    func profileBackClicked()
    func profileBtnContinueClicked()
}

public class ProfileVC: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var tblProfile: UITableView!
    @IBOutlet weak var tblProfileHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnTerms: UIButton!
    @IBOutlet weak var btnTermsCheck: UIButton!

    var arrPofile = [ProfileModel]()
    public weak var delegate: ProfileVCDelegate?

    public override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
        
    func setUI(){
        
        btnContinue.setCornerRadious(corner: btnContinue.frame.height / 2)
        
        let bundle = Bundle(for: ProfileVC.self)

        tblProfile.register(UINib.init(nibName: "ProfileTblCell", bundle: bundle), forCellReuseIdentifier: "ProfileTblCell")
        
        
        arrPofile.append(ProfileModel.init(placeholder: "Auto generated signup ID", isDateField: false))
        arrPofile.append(ProfileModel.init(placeholder: "Full Name", isDateField: false))
        arrPofile.append(ProfileModel.init(placeholder: "Last Name", isDateField: false))
        arrPofile.append(ProfileModel.init(placeholder: "Date of Birth", isDateField: true))


        tblProfileHeightConstraint.constant = CGFloat(arrPofile.count * 72)
    }
    
    @IBAction func btnBackClicked(_ sender: UIButton) {
        delegate?.profileBackClicked()
    }
    
    @IBAction func btnContinueClicked(_ sender: UIButton) {
        delegate?.profileBtnContinueClicked()
    }
    
}



extension ProfileVC : UITableViewDelegate, UITableViewDataSource{
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrPofile.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTblCell") as! ProfileTblCell
        cell.setupData(obj: arrPofile[indexPath.row])
        return cell
    }
    
    
    
}
