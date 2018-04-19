//
//  NotLoginViewController.swift
//  HomeCare
//
//  Created by Nguyen Van Tho on 3/20/18.
//  Copyright © 2018 Viettel. All rights reserved.
//

import UIKit

class NotLoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func loginAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "LoginScreen", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "loginView") as! LoginViewController
        self.present(loginVC, animated: true, completion: nil)
    }
}
