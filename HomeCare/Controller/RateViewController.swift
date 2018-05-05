//
//  RateViewController.swift
//  HomeCare
//
//  Created by Thang BKHN on 4/30/18.
//  Copyright © 2018 Viettel. All rights reserved.
//

import UIKit

protocol CustomAlertViewDelegate: class {
    func okButtonTapped(commentStr: String)
    func cancelButtonTapped()
}

class RateViewController: UIViewController {

    @IBOutlet var alertView: UIView!
    @IBOutlet weak var edtComment: UITextField!
    @IBOutlet weak var btnRate: UIButton!
    @IBOutlet weak var btnCancel: UIButton!

    var delegate: CustomAlertViewDelegate?
    var level = 0
    let alertViewGrayColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)
    let notRate:UIImage = UIImage(named: "star")!
    let rate:UIImage = UIImage(named: "star2")!
    @IBAction func btRate(_ sender: Any) {
        if (edtComment.text == ""){
            GlobalUtil.showToast(context: self, message: "Bạn chưa nhập nội dung")
            return
        }
        edtComment.resignFirstResponder()
        delegate?.okButtonTapped(commentStr: edtComment.text!)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btCancel(_ sender: Any) {
        delegate?.cancelButtonTapped()
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        animateView()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
        btnCancel.layer.addBorder(edge: .top, color: alertViewGrayColor, thickness: 1)
        btnCancel.layer.addBorder(edge: .left, color: alertViewGrayColor, thickness: 1)
        btnRate.layer.addBorder(edge: .top, color: alertViewGrayColor, thickness: 1)
    }
    func setupView() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    func animateView() {
        alertView.alpha = 0;
        self.alertView.frame.origin.y = self.alertView.frame.origin.y + 50
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.alertView.alpha = 1.0;
            self.alertView.frame.origin.y = self.alertView.frame.origin.y - 50
        })
    }
}
