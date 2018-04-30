//
//  RateViewController.swift
//  HomeCare
//
//  Created by Thang BKHN on 4/30/18.
//  Copyright © 2018 Viettel. All rights reserved.
//

import UIKit

protocol CustomAlertViewDelegate: class {
    func okButtonTapped(rateLevel: Int, commentStr: String)
    func cancelButtonTapped()
}

class RateViewController: UIViewController {

    @IBOutlet var alertView: UIView!
    @IBOutlet weak var edtComment: UITextField!
    @IBOutlet weak var btnRate: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var star1: UIButton!
    @IBOutlet weak var star2: UIButton!
    @IBOutlet weak var star3: UIButton!
    @IBOutlet weak var star4: UIButton!
    @IBOutlet weak var star5: UIButton!

    var delegate: CustomAlertViewDelegate?
    var level = 0
    let alertViewGrayColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)
    let notRate:UIImage = UIImage(named: "star")!
    let rate:UIImage = UIImage(named: "star2")!
    @IBAction func btRate(_ sender: Any) {
        if (self.level == 0 || edtComment.text == ""){
            GlobalUtil.showToast(context: self, message: "Bạn chưa đánh giá chất lượng")
            return
        }
        edtComment.resignFirstResponder()
        delegate?.okButtonTapped(rateLevel: level, commentStr: edtComment.text!)
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
    @IBAction func btStar1(_ sender: Any) {
        level = 1
        setRate(level: 1)
    }
    
    @IBAction func btStar2(_ sender: Any) {
        level = 2
        setRate(level: 2)
    }
    
    @IBAction func btStar3(_ sender: Any) {
        level = 3
        setRate(level: 3)
    }
    
    @IBAction func btStar4(_ sender: Any) {
        level = 4
        setRate(level: 4)
    }
    
    @IBAction func btStar5(_ sender: Any) {
        level = 5
        setRate(level: 5)
    }
    
    func setRate(level:Int) {
        let starList:[UIButton] = [self.star1,self.star2 ,self.star3 , self.star4,  self.star5]
        for i in 0 ..< level{
            starList[i].setImage(self.rate, for: .normal)
        }
        for i in level..<starList.count{
            starList[i].setImage(self.notRate, for: .normal)
        }
    }
}
