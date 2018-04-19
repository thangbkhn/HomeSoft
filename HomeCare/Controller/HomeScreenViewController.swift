//
//  HomeScreenViewController.swift
//  HomeCare
//
//  Created by Nguyen Van Tho on 4/5/18.
//  Copyright © 2018 Viettel. All rights reserved.
//

import UIKit
import Firebase

class HomeScreenViewController: UIViewController {
    @IBOutlet var imgAdvert: UIImageView!
    @IBOutlet var pageControll: UIPageControl!
    @IBOutlet var tvName: UILabel!
    @IBOutlet var tvLogin: UIButton!
    @IBOutlet var tvUse: UILabel!
    
    var timer: Timer!
    var updateCounter:Int!
    let imgListStr = ["anh1","anh2","anh3"]
    
    var isLogin = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Messaging.messaging().subscribe(toTopic: "alert")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "logo")
        imageView.image = image
        navigationItem.titleView = imageView
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        //Load page cotroll
        updateCounter = 0
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        //Load page cotroll
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadForm), name: NotificationConstant.loginNotification, object: nil)
        isLogin = GlobalUtil.getBoolPreference(key: GlobalUtil.isLogin)
        reloadForm()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = .white
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = GlobalUtil.getMainColor()
    }
    @objc internal func updateTimer(){
        if (updateCounter <= 2){
            pageControll.currentPage = updateCounter
            imgAdvert.image = UIImage(named: imgListStr[updateCounter])
            updateCounter = updateCounter + 1
        }else{
            updateCounter = 0
        }
    }
    @objc func reloadForm() {
        isLogin = GlobalUtil.getBoolPreference(key: GlobalUtil.isLogin)
        if !isLogin {
            tvLogin.setTitle("Đăng nhập", for:.normal)
            tvUse.isHidden = false
            tvName.text = "Xin chào"
        }else{
            tvLogin.setTitle("Đăng xuất", for:.normal)
            tvUse.isHidden = true
            tvName.text = "\(GlobalInfo.sharedInstance.userInfo?.fullName ?? "")"
        }
    }
    @IBAction func btNotification(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let notifitionVC = sb.instantiateViewController(withIdentifier: "notification") as! NotificationViewController
        self.navigationController?.pushViewController(notifitionVC, animated: true)
    }
    
    @IBAction func btPayment(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let paymentVC = sb.instantiateViewController(withIdentifier: "payment") as! PaymentViewController
        self.navigationController?.pushViewController(paymentVC, animated: true)
    }
    
    @IBAction func btComment(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let feeabackVC = sb.instantiateViewController(withIdentifier: "feeaback") as! FeedbackViewController
        self.navigationController?.pushViewController(feeabackVC, animated: true)
    }
    
    @IBAction func btSetting(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "ResidentManager", bundle:nil)
        let residentViewController = storyBoard.instantiateViewController(withIdentifier: "residentViewController") as! ResidentViewController
        self.navigationController?.pushViewController(residentViewController, animated: true)
    }
    
    @IBAction func btLoginAction(_ sender: Any) {
        if !isLogin {
            GlobalUtil.startAnimate(sender: sender as! UIButton, action: {
                let storyboard = UIStoryboard(name: "LoginScreen", bundle: nil)
                let loginVC = storyboard.instantiateViewController(withIdentifier: "loginView") as! LoginViewController
                self.present(loginVC, animated: true, completion: nil)
            })
            
        }else{
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
    }
}