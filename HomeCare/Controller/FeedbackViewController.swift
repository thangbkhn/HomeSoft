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
    var rateList:[Double] = [1 , 3, 6,34,100]
    var isLogin = false
    let loginTag = 1
    var frame:CGRect!
    let notRate = UIImage(named: "star")
    let rateLess = UIImage(named: "star4")
    let rate12 = UIImage(named: "star3")
    let rateMore = UIImage(named: "star5")
    let rateFull = UIImage(named: "star2")
    
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
            view1.setNeedsLayout()
            view1.layoutIfNeeded()
            view2.setNeedsLayout()
            view2.layoutIfNeeded()
            view3.setNeedsLayout()
            view3.layoutIfNeeded()
            view4.setNeedsLayout()
            view4.layoutIfNeeded()
            view5.setNeedsLayout()
            view5.layoutIfNeeded()
            setUpRateView()
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
        return 80
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
    @IBAction func btRate(_ sender: Any) {
        let reviewStoryboard :UIStoryboard = UIStoryboard(name: "ReviewDialog", bundle: nil)
        let customAlert = reviewStoryboard.instantiateViewController(withIdentifier: "reviewDialog") as! RateViewController
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        customAlert.delegate = self
        self.present(customAlert, animated: true, completion: nil)
    }
    func setUpRateView() {
        var sum = 0.0
        var sumRate = 0.0
        for i in 0..<rateList.count{
            sum += rateList[i]
            sumRate += rateList[i] * (Double)(i+1)
        }
        tvAverageRate.text = "\(NSString(format: "%.1f", sumRate/sum))"
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let max = self.rateList.max()
            self.changeWidth(max: max!, view: self.view1, i: 0)
            self.changeWidth(max: max!, view: self.view2, i: 1)
            self.changeWidth(max: max!, view: self.view3, i: 2)
            self.changeWidth(max: max!, view: self.view4, i: 3)
            self.changeWidth(max: max!, view: self.view5, i: 4)
        }
        let b = round(10 * sumRate/sum)
        setStar(starList: [star1,star2,star3,star4,star5], rate: Double(b/10))
    }
    func  changeWidth(max:Double, view:UIView, i :Int) {
        let frame = view.frame
        view.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.size.width * (CGFloat)(rateList[i]/max), height: frame.height)
    }
    func setStar(starList:[UIImageView], rate:Double) {
        let a = (Int)(rate) - 1
        // To diem rate
        for i in 0...a {
            starList[i].image = rateFull
        }
        // To diem k rate
        if a < 3{
            for i in (a+2)...4{
                starList[i].image = notRate
            }
        }
        //To diem hien tai
        let b = ((Int)(rate * 10)) % 10
        if b == 5 {
            starList[a+1].image = rate12
        }else if b<5{
            starList[a+1].image = rateLess
        }else{
            starList[a+1].image = rateMore
        }
    }
}
extension FeedbackViewController:CustomAlertViewDelegate{
    func okButtonTapped(rateLevel: Int, commentStr: String) {
        GlobalUtil.showToast(context: self, message: "Cảm ơn bạn đã đánh giá")
        print("Kết quả đánh giá\n  - Mức độ hài lòng\(rateLevel)\n  - \(commentStr)")
    }
    
    func cancelButtonTapped() {
        GlobalUtil.showToast(context: self, message: "Huỷ đánh giá")
    }
    
    
}
