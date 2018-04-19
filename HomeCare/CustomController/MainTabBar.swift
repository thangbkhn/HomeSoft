//
//  MainTabBar.swift
//  HomeCare
//
//  Created by Nguyen Van Tho on 3/19/18.
//  Copyright © 2018 Viettel. All rights reserved.
//

import UIKit

class MainTabBar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.tabBar.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 70, width: UIScreen.main.bounds.width, height: 70)
    }
}
