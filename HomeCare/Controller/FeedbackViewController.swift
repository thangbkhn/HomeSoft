//
//  FeedbackViewController.swift
//  HomeCare
//
//  Created by Nguyen Van Tho on 3/24/18.
//  Copyright © 2018 Viettel. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController {
    var isLogin = false
    let loginTag = 1
    var frame:CGRect!
    override func viewDidLoad() {
        super.viewDidLoad()
        if frame == nil {
            frame = self.view.frame
        }
        NotificationCenter.default.addObserver(self, selector: #selector(reloadForm), name: NotificationConstant.loginNotification, object: nil)
        isLogin = GlobalUtil.getBoolPreference(key: GlobalUtil.isLogin)
        if !isLogin {
            let loginStoryboard :UIStoryboard = UIStoryboard(name: "NotLoginScreen", bundle: nil)
            let loginView = loginStoryboard.instantiateViewController(withIdentifier: "loginView") as! NotLoginViewController
            self.addChildViewController(loginView)
            loginView.view.frame = frame
            let addView = loginView.view
            addView?.tag = loginTag
            self.view.addSubview(addView!)
            loginView.didMove(toParentViewController: self)
        }else{
            if let viewWithTag = self.view.viewWithTag(loginTag){
                viewWithTag.removeFromSuperview()
            }
        }
    }
    @objc func reloadForm() {
        self.viewDidLoad()
    }
}
