//
//  FeedbackViewController.swift
//  HomeCare
//
//  Created by Nguyen Van Tho on 3/24/18.
//  Copyright © 2018 Viettel. All rights reserved.
//

import UIKit
import RAMAnimatedTabBarController

class FeedbackViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var isLogin = false
    let loginTag = 1
    var frame:CGRect!
    
    @IBOutlet weak var imgBuilding: UIImageView!
    @IBOutlet weak var tvBuildingName: UILabel!
    @IBOutlet weak var tvAddress: UILabel!
    @IBOutlet weak var tvPhone: UILabel!
    @IBOutlet weak var tvAverageRate: UILabel!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    @IBOutlet weak var tvSumRate: UILabel!
    @IBOutlet weak var view5: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var tbComment: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if frame == nil {
            frame = self.view.frame
        }
        navigationController?.navigationBar.tintColor = GlobalUtil.getGrayColor()
        let backButton = UIBarButtonItem(title: "Góp ý", style: UIBarButtonItemStyle.done, target: nil, action: nil)
        backButton.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: 20)], for: .normal)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        NotificationCenter.default.addObserver(self, selector: #selector(reloadForm), name: NotificationConstant.loginNotification, object: nil)
        isLogin = GlobalUtil.getBoolPreference(key: GlobalUtil.isLogin)
        if !isLogin {
            
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    @objc func reloadForm() {
        self.viewDidLoad()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.showTabar(isShow: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.showTabar(isShow: false)
    }
    func showTabar(isShow:Bool)  {
        let animatedTabBar = self.tabBarController as! RAMAnimatedTabBarController
        animatedTabBar.animationTabBarHidden(!isShow)
    }
}
