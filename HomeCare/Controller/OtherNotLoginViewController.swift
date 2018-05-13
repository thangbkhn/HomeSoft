//
//  OtherNotLoginViewController.swift
//  HomeCare
//
//  Created by Nguyen Van Tho on 3/26/18.
//  Copyright © 2018 Viettel. All rights reserved.
//
//https://github.com/kciter/SelectionDialog

import UIKit

class OtherNotLoginViewController: UIViewController {
    override func viewDidLoad() {
        let language = GlobalUtil.getStringPreference(key: GlobalUtil.keyLanguage)
        tvLanguage.text = language == "english" ? "English" : "Tiếng Việt"
    }
    
    @IBOutlet weak var tvLanguage: UILabel!
    @IBAction func btLoginAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "LoginScreen", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "loginView") as! LoginViewController
        self.present(loginVC, animated: true, completion: nil)
    }
    @IBAction func changeLanguageAction(_ sender: Any) {
        let language = GlobalUtil.getStringPreference(key: GlobalUtil.keyLanguage)
        var vietnameLang = true
        if language == "english"{
            vietnameLang = false
        }
        let dialog = SelectionDialog(title: "Chọn ngôn ngữ", closeButtonTitle: "Đóng")
        dialog.addItem(item: "English", icon: UIImage(named: "english")!,isChecked:!vietnameLang, didTapHandler: { () in
            GlobalUtil.showToast(context: self, message: "You have just selected english")
            GlobalUtil.setPreference(value: "english", key: GlobalUtil.keyLanguage)
            self.tvLanguage.text = "English"
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
    
    @IBAction func guideAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Help", bundle: nil)
        let helpVC = storyboard.instantiateViewController(withIdentifier: "helpVC") as! HelpViewController
        //self.present(helpVC, animated: true, completion: nil)
        self.navigationController?.pushViewController(helpVC, animated: true)
    }
    
    @IBAction func aboutAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "About", bundle: nil)
        let aboutVC = storyboard.instantiateViewController(withIdentifier: "aboutVC") as! AboutViewController
        self.navigationController?.pushViewController(aboutVC, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = GlobalUtil.getMainColor()
    }
}
