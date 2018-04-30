//
//  OtherViewController.swift
//  HomeCare
//
//  Created by Nguyen Van Tho on 3/24/18.
//  Copyright © 2018 Viettel. All rights reserved.
//

import UIKit
import Firebase

class OtherViewController: UIViewController {
    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var txtFullname: UILabel!
    @IBOutlet var txtPhone: UILabel!
    @IBOutlet var txtRoom: UILabel!
    @IBOutlet weak var tvLanguage: UILabel!
    
    var isLogin = false
    let loginTag = 1
    var frame:CGRect!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        if frame == nil {
            frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - (self.navigationController?.navigationBar.frame.height)! - (self.tabBarController?.tabBar.frame.height)!)
        }
        let language = GlobalUtil.getStringPreference(key: GlobalUtil.keyLanguage)
        tvLanguage.text = language == "english" ? "English" : "Tiếng Việt"
        setNavigationBar()
        imgProfile.layer.cornerRadius = imgProfile.frame.height/2
        imgProfile.clipsToBounds = true
        NotificationCenter.default.addObserver(self, selector: #selector(reloadForm), name: NotificationConstant.loginNotification, object: nil)
        isLogin = GlobalUtil.getBoolPreference(key: GlobalUtil.isLogin)
        if !isLogin {
            let loginStoryboard :UIStoryboard = UIStoryboard(name: "OtherNotLogin", bundle: nil)
            let loginView = loginStoryboard.instantiateViewController(withIdentifier: "otherNotLogin") as! OtherNotLoginViewController
            self.addChildViewController(loginView)
            loginView.view.frame = frame
            let addView = loginView.view
            addView?.tag = loginTag
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                self.view.addSubview(addView!)
                loginView.didMove(toParentViewController: self)
            }
            
        }else{
            
            if let viewWithTag = self.view.viewWithTag(loginTag){
                viewWithTag.removeFromSuperview()
            }
            txtFullname.text = GlobalInfo.sharedInstance.userInfo?.fullName
            txtPhone.text = GlobalInfo.sharedInstance.userInfo?.mobile != nil ? GlobalInfo.sharedInstance.userInfo?.mobile : "Chưa có số"
            txtRoom.text = GlobalInfo.sharedInstance.userInfo?.roomCode
        }
    }
    @objc func reloadForm() {
        self.viewDidLoad()
    }
    @IBAction func btChangeLanguage(_ sender: Any) {
        let language = GlobalUtil.getStringPreference(key: GlobalUtil.keyLanguage)
        var vietnameLang = true
        if language == "english"{
            vietnameLang = false
        }
        let dialog = SelectionDialog(title: "Chọn ngôn ngữ", closeButtonTitle: "Đóng")
        dialog.addItem(item: "English", icon: UIImage(named: "english")!,isChecked:!vietnameLang, didTapHandler: { () in
            GlobalUtil.showToast(context: self, message: "You have just selected english")
            self.tvLanguage.text = "English"
            GlobalUtil.setPreference(value: "english", key: GlobalUtil.keyLanguage)
            dialog.close()
        })
        dialog.addItem(item: "Việt Nam", icon: UIImage(named: "vietnam")!,isChecked:vietnameLang, didTapHandler: { () in
            GlobalUtil.showToast(context: self, message: "Bạn đã chọn tiếng việt")
            GlobalUtil.setPreference(value: "vietnam", key: GlobalUtil.keyLanguage)
            self.tvLanguage.text = "Tiếng Việt"
            dialog.close()
        })
        dialog.show()
    }
    
    @IBAction func btHelp(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Help", bundle: nil)
        let helpVC = storyboard.instantiateViewController(withIdentifier: "helpVC") as! HelpViewController
        //self.present(helpVC, animated: true, completion: nil)
        self.navigationController?.pushViewController(helpVC, animated: true)
    }
    
    @IBAction func btComment(_ sender: Any) {
    }
    
    @IBAction func btMember(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "ResidentManager", bundle:nil)
        let residentViewController = storyBoard.instantiateViewController(withIdentifier: "residentViewController") as! ResidentViewController
        self.navigationController?.pushViewController(residentViewController, animated: true)
        //self.present(residentViewController, animated: true)
        
    }
    @IBAction func btChangePass(_ sender: Any) {
        let alert = UIAlertController(title: "Thay đổi mật khẩu", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField { (password) in
            password.placeholder = "Mật khẩu cũ"
            password.isSecureTextEntry = true
            let heightConstraint = NSLayoutConstraint(item: password, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)
            password.addConstraint(heightConstraint)
        }
        alert.addTextField { (newPassword) in
            newPassword.placeholder = "Mật khẩu mới"
            newPassword.isSecureTextEntry = true
            let heightConstraint = NSLayoutConstraint(item: newPassword, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)
            newPassword.addConstraint(heightConstraint)
        }
        alert.addTextField { (confirmPassword) in
            confirmPassword.placeholder = "Nhập lại mật khẩu"
            confirmPassword.isSecureTextEntry = true
            let heightConstraint = NSLayoutConstraint(item: confirmPassword, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)
            confirmPassword.addConstraint(heightConstraint)
        }
        alert.addAction(UIAlertAction(title: "Lưu lại", style: UIAlertActionStyle.default, handler: { (changeFunction) in
            let textPassword = alert.textFields![0]
            let textNewPassword = alert.textFields![1]
            let textConfirmPassword = alert.textFields![2]
            if(textPassword.text?.trimmingCharacters(in: .whitespaces) == "" || textNewPassword.text?.trimmingCharacters(in: .whitespaces) == "" || textConfirmPassword.text?.trimmingCharacters(in: .whitespaces) == "" ){
                GlobalUtil.showToast(context: self, message: "Không được phép để trống trường nào")
                return
            }
            if(textNewPassword.text != textConfirmPassword.text){
                GlobalUtil.showToast(context: self, message: "Mật khẩu mới không khớp nhau")
                return
            }
            let requestChange = ChangePasswordRequest()
            requestChange.username = GlobalInfo.sharedInstance.userInfo?.email
            requestChange.password = textPassword.text
            requestChange.newpassword = textNewPassword.text
            ServiceApi.shareInstance.postWebService(objc: ChangePasswordResponse.self, urlStr: Constant.changePasswordURL, headers: ServiceApi.shareInstance.getHeader(), completion: { (isSuccess, responseData) in
                if isSuccess{
                    let result = responseData as! ChangePasswordResponse
                    if result.resultCode == "200"{
                        GlobalUtil.showToast(context: self, message: "Đổi mật khẩu thành công")
                    }else{
                        GlobalUtil.showToast(context: self, message: result.errorMes!)
                    }
                }else{
                    GlobalUtil.showToast(context: self, message: "Không thể thay đổi mật khẩu")
                }
            }, parameter: requestChange.toDict())
        }))
        alert.addAction(UIAlertAction(title: "Huỷ bỏ", style: UIAlertActionStyle.destructive, handler: { (cancelFunction) in
            
        }))
        self.present(alert, animated: true, completion: nil)
        self.view.endEditing(true)
    }
    
    @IBAction func btLogout(_ sender: Any) {
        GlobalUtil.setPreference(value: false, key: GlobalUtil.isLogin)
        NotificationCenter.default.post(name: NotificationConstant.loginNotification, object: nil)
        
        /// Unsubcrible topics
        if let groupFCM = GlobalInfo.sharedInstance.groupFCM {
            for fcm in groupFCM {
                Messaging.messaging().unsubscribe(fromTopic: fcm)
            }
        }
        //
    }
    @IBAction func btAboutAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "About", bundle: nil)
        let aboutVC = storyboard.instantiateViewController(withIdentifier: "aboutVC") as! AboutViewController
        self.navigationController?.pushViewController(aboutVC, animated: true)
    }
    
    func setNavigationBar() {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.barTintColor = GlobalUtil.getMainColor()
        navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = .white
        self.definesPresentationContext = true;
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = GlobalUtil.getMainColor()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = .white
    }
}
