//
//  LoginViewController.swift
//  HomeCare
//
//  Created by Nguyen Van Tho on 3/20/18.
//  Copyright © 2018 Viettel. All rights reserved.
//

import UIKit
import Alamofire
import Firebase
class LoginViewController: UIViewController {
    @IBOutlet var txtUser: UITextField!
    @IBOutlet var txtPassword: UITextField!
    
    @IBOutlet var loading: UIActivityIndicatorView!
    @IBOutlet var imgLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loading.startAnimating()
        loading.isHidden = true
        txtPassword.isSecureTextEntry = true
        txtUser.attributedPlaceholder = NSAttributedString(string: "Tài khoản",attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        txtPassword.attributedPlaceholder = NSAttributedString(string: "Mật khẩu",attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard)))
        imgLogo.layer.cornerRadius = imgLogo.layer.frame.width/2
        imgLogo.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnLoginAction(_ sender: Any) {
        loading.isHidden = false
        let loginRequest = LoginRequest()
        let token = GlobalUtil.getStringPreference(key: GlobalUtil.tokenFCM)
        loginRequest.tokenFCM = token != "" ? token : "dxEzTqb2QLRWaznHbxeh62JPNVQUoFDIwdwaNOhx4kr3y84hanFU4V0jBuzM1bzpsEPB0TPhXPzkqcYYAnI86-P35X8Gn6P6xc5F2RVQ3rKXOpw755XADxXGkSaTIkao_QK6DYf3Jhpp7RZKAXw-pUncO50GRb-c5HwgsM_1PzER3-P3bbzq0_2vSpFBot_q3pPgjEn26Jla-LnnKjw_ydhhWTU60mDoT0msRr-BjKY"
        loginRequest.username = txtUser.text!
        loginRequest.password = txtPassword.text!
        let url = "http://103.63.109.42:8086/api/Account/Auth"
        ServiceApi.shareInstance.postWebService(objc: LoginResponse.self, urlStr: url, headers: ServiceApi.shareInstance.getHeader(), completion: { (isSuccess, dataResponse) in
            if (isSuccess && dataResponse != nil){
                let loginResponse = dataResponse as! LoginResponse
                if(loginResponse.resultCode == "200"){
                    //GlobalInfo.sharedInstance.userInfo = loginResponse.accountInfo
                    GlobalUtil.setPreference(value: true, key: GlobalUtil.isLogin)
                    let savedAccount = SavedAccount(account: loginResponse.accountInfo!)
                    GlobalUtil.saveObject(object: savedAccount)
                    if let groupFCM = loginResponse.groupFCM{
                        for fcm in groupFCM {
                            if let topic = fcm.groupName{
                                Messaging.messaging().subscribe(toTopic: topic)
                            }
                        }
                    }
                    self.dismiss(animated: true, completion: nil)
                }else{
                    GlobalUtil.showToast(context: self, message: "Tài khoản hoặc mật khẩu không đúng")
                }
            }
            self.loading.isHidden = true
        }, parameter: loginRequest.toDict())
    }
    @IBAction func signUpAction(_ sender: Any) {
    }
    //keyboard
    @objc func dismissKeyBoard(){
        self.view.endEditing(true)
    }
    func checkValidate() -> Bool{
        if ( txtUser.text?.trimmingCharacters(in: .whitespaces) == "" || txtPassword.text?.trimmingCharacters(in: .whitespaces) == "" ){
            GlobalUtil.showToast(context: self, message: "Không được để trống tài khoản/mật khẩu")
            return false
        }
        return true
    }
}
