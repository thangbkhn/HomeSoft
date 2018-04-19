//
//  CustomTabBarController.swift
//  HomeCare
//
//  Created by Nguyen Van Tho on 3/19/18.
//  Copyright © 2018 Viettel. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillLayoutSubviews() {
        self.tabBar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 70)
//        self.tabBar.barTintColor = GlobalUtil.getMainColor()
//        self.tabBar.tintColor = UIColor.white
//        self.tabBar.unselectedItemTintColor = UIColor(red: 241, green: 248, blue: 233, alpha: 0.5)
        super.viewWillLayoutSubviews()
    }
}
