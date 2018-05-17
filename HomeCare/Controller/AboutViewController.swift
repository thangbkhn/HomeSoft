//
//  AboutViewController.swift
//  HomeCare
//
//  Created by Thang BKHN on 4/17/18.
//  Copyright © 2018 Viettel. All rights reserved.
//

import UIKit
import RAMAnimatedTabBarController

class AboutViewController: UIViewController {

    @IBOutlet weak var imgLogo: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //imgLogo.image = imgLogo.changeImageColor(color: .white)
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = GlobalUtil.getMainColor()
        let backButton = UIBarButtonItem(title: "Giới thiệu", style: UIBarButtonItemStyle.done, target: nil, action: nil)
        backButton.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: 20)], for: .normal)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
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
