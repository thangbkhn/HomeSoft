//
//  NewResidentViewController.swift
//  HomeCare
//
//  Created by Nguyen Van Tho on 3/28/18.
//  Copyright © 2018 Viettel. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import BEMCheckBox
import DatePickerDialog

protocol UpdateSuccess {
    func result(isSuccess:Bool)
}
class NewResidentViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var imgProfile: UIButton!
    @IBOutlet var txtFullName: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet var txtIdentityNo: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet var txtPhone: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet var txtMail: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet var isOwner: BEMCheckBox!
    @IBOutlet var loading: UIActivityIndicatorView!
    @IBOutlet var btMale: UIButton!
    @IBOutlet var btFemale: UIButton!
    @IBOutlet var txtBirthday: SkyFloatingLabelTextFieldWithIcon!
    
    var gender:String = "Nam"
    var delegate : UpdateSuccess?
    var isEdit = false
    var accout:Account?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard)))
        imgProfile.cornerRadius = imgProfile.frame.width / 2
        imgProfile.clipsToBounds = true
        loading.isHidden = true
        txtFullName.delegate = self
        txtMail.delegate = self
        txtPhone.delegate = self
        txtPhone.keyboardType = UIKeyboardType.numberPad
        txtIdentityNo.delegate = self
        if isEdit{
            txtFullName.text = accout?.fullName
            txtIdentityNo.text = accout?.identityNo
            txtMail.text = accout?.email
            txtBirthday.text = accout?.birdthDay?.substring(with: 0..<10)
            txtPhone.text = accout?.mobile
            if accout?.gender == "Nam"{
                selectButton(btView: btFemale, isSelect: false)
                selectButton(btView: btMale, isSelect: true)
            }else{
                selectButton(btView: btFemale, isSelect: true)
                selectButton(btView: btMale, isSelect: false)
            }
        }
    }
    //keyboard
    @objc func dismissKeyBoard(){
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyBoard()
        return true
    }
    @IBAction func btSaveAction(_ sender: Any) {
        if !validateScreen() {
            return
        }
        loading.startAnimating()
        loading.isHidden = false
        var account = Account()
        if isEdit{
            account = self.accout!
        }
        account.fullName = txtFullName.text?.trimmingCharacters(in: .whitespaces)
        account.birdthDay = txtBirthday.text?.trimmingCharacters(in: .whitespaces)
        account.identityNo = txtIdentityNo.text?.trimmingCharacters(in: .whitespaces)
        account.mobile = txtPhone.text?.trimmingCharacters(in: .whitespaces)
        account.email = txtMail.text?.trimmingCharacters(in: .whitespaces)
        account.gender = self.gender
        account.isOwner =  isOwner.isSelected ? "1":"0"
        account.roomId = GlobalInfo.sharedInstance.userInfo?.roomId
        updateResident(resident: account)
    }
    
    @IBAction func btCancelAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btMaleAction(_ sender: Any) {
        selectButton(btView: btFemale, isSelect: false)
        selectButton(btView: btMale, isSelect: true)
        gender = "Nam"
    }
    @IBAction func btFemaleAction(_ sender: Any) {
        selectButton(btView: btFemale, isSelect: true)
        selectButton(btView: btMale, isSelect: false)
        gender = "Nữ"
    }
    func selectButton(btView:UIButton, isSelect:Bool) {
        if isSelect{
            btView.backgroundColor = GlobalUtil.getMainColor()
            btView.setTitleColor(.white, for: .normal)
        }else{
            btView.backgroundColor = UIColor.white
            btView.setTitleColor(GlobalUtil.getMainColor(), for: .normal)
        }
    }
    
    @IBAction func dateAction(_ sender: Any) {
        self.view.endEditing(true)
        DispatchQueue.main.asyncAfter(deadline: .now()
            + 0.2) {
                DatePickerDialog().show("DatePicker", doneButtonTitle: "Xong", cancelButtonTitle: "Huỷ", datePickerMode: .date) {
                    (date) -> Void in
                    if let dt = date {
                        let formatter = DateFormatter()
                        formatter.dateFormat = Constant.dateFormatStr
                        self.txtBirthday.text = formatter.string(from: dt)
                        
                    }
                }
        }
    }
    
    
    @IBAction func btOwner(_ sender: Any) {
        isOwner.setOn(!isOwner.on, animated: true)
    }
    
    func validateScreen() -> Bool {
        if txtFullName.text?.trimmingCharacters(in: .whitespaces) == ""{
            GlobalUtil.showToast(context: self, message: "Bạn phải nhập họ và tên")
            return false
        }
        let phone = txtPhone.text
        if  phone?.trimmingCharacters(in: .whitespaces) != ""{
            if !(phone?.isPhoneNumber)!{
                GlobalUtil.showToast(context: self, message: "Sai định dạng số điện thoại")
                return false
            }
        }
        let mail = txtMail.text
        if  mail?.trimmingCharacters(in: .whitespaces) != ""{
            if !(mail?.isEmail)!{
                GlobalUtil.showToast(context: self, message: "Sai định dạng mail")
                return false
            }
        }
        return true
    }
    func updateResident(resident:Account) {
        let residentUpdateRequest = UpdateRequest()
        residentUpdateRequest.clientId = GlobalInfo.sharedInstance.userInfo?.clientId
        residentUpdateRequest.userId = GlobalInfo.sharedInstance.userInfo?.id
        residentUpdateRequest.info = resident.toDict()
        ServiceApi.shareInstance.postWebService(objc: UpdateResidentResponse.self, urlStr: Constant.updateResidentURL, headers: ServiceApi.shareInstance.getHeader(), completion: { (isSuccess, dataResponse) in
            if isSuccess{
                let result = dataResponse as! UpdateResidentResponse
                if result.resultCode == "200"{
                    self.delegate?.result(isSuccess: true)
                    self.navigationController?.popViewController(animated: true)
                }else{
                    GlobalUtil.showToast(context: self, message: "Không thể cập nhật thông tin thành viên")
                }
            }else{
                GlobalUtil.showToast(context: self, message: "Không thể cập nhật thông tin thành viên")
            }
            self.loading.isHidden = true
        }, parameter: residentUpdateRequest.toDict())
    }
}
