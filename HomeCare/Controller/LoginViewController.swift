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
        let url = Constant.sharedInstance.getLoginURL()
        ServiceApi.shareInstance.postWebService(objc: LoginResponse.self, urlStr: url, headers: ServiceApi.shareInstance.getHeader(), completion: { (isSuccess, dataResponse) in
            if (isSuccess && dataResponse != nil){
                let loginResponse = dataResponse as! LoginResponse
                if(loginResponse.resultCode == "200"){
                    GlobalUtil.setPreference(value: true, key: GlobalUtil.isLogin)
                    let savedAccount = SavedAccount(account: loginResponse.accountInfo!)
                    GlobalInfo.sharedInstance.setUser(_userInfo: savedAccount)
                    GlobalUtil.saveObject(object: savedAccount)
                    if let groupFCM = loginResponse.groupFCM{
                        var groupString:[String] = []
                        for fcm in groupFCM {
                            if let topic = fcm.groupName{
                                groupString.append(topic)
                                Messaging.messaging().subscribe(toTopic: topic)
                            }
                        }
                        GlobalInfo.sharedInstance.setGroupFCM(_groupFCM: groupString)
                        GlobalUtil.setPreference(value: groupString, key: GlobalUtil.groupFCM)
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
    @IBAction func btChangeHost(_ sender: Any) {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Some Title", message: "Enter a text", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = Constant.sharedInstance.getBaserUrl()
            textField.placeholder = Constant.sharedInstance.getBaserUrl()
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            Constant.sharedInstance.setBaseUrl(url: (textField?.text)!)
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
}
