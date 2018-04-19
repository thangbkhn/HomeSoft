//
//  AboutViewController.swift
//  HomeCare
//
//  Created by Thang BKHN on 4/17/18.
//  Copyright © 2018 Viettel. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var imgLogo: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imgLogo.image = imgLogo.changeImageColor(color: .white)
    }
}
