//
//  PaymentViewController.swift
//  HomeCare
//
//  Created by Nguyen Van Tho on 3/19/18.
//  Copyright © 2018 Viettel. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import RAMAnimatedTabBarController

class PaymentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var paymentList:[PaymentTestItem] = []
    var feeList:[FeeItem] = []
    var isLogin = false
    let loginTag = 1
    let viewChartTag = 2
    var frame:CGRect!
    var currentYear = GlobalUtil.getYearList()[10]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeList.count
    }
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var isLoading: UIActivityIndicatorView!
    let chartButton:UIButton = {
        let chartNavigationIcon = UIButton(type: .system)
        chartNavigationIcon.setImage(UIImage(named: "stats_ic_64"), for: .normal)
        chartNavigationIcon.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        chartNavigationIcon.tintColor = GlobalUtil.getGrayColor()
        return chartNavigationIcon
    }()
    let paymentButton:UIButton = {
        let paymentNavigationIcon = UIButton(type: .system)
        paymentNavigationIcon.setImage(UIImage(named: "controls3"), for: .normal)
        paymentNavigationIcon.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        paymentNavigationIcon.tintColor = GlobalUtil.getGrayColor()
        paymentNavigationIcon.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20)
        return paymentNavigationIcon
    }()
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PaymentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "paymentItem", for: indexPath) as! PaymentTableViewCell
        let item = feeList[indexPath.row]
        cell.tvDate.text = "Tháng \(item.month)/\(currentYear)"
        cell.tvMotorFee.text = "\(GlobalUtil.formatMoney(value: item.paymentParking))"
        cell.tvServiceFee.text = "\(GlobalUtil.formatMoney(value: item.paymentService))"
        cell.tvWaterFee.text = "\(GlobalUtil.formatMoney(value: item.paymentWater))"
        cell.tvElectricFee.text = "\(GlobalUtil.formatMoney(value: item.paymentElectric))"
        cell.tvSumFee.text = "Tổng: \(GlobalUtil.formatMoney(value: item.paymentParking + item.paymentService + item.paymentWater + item.paymentElectric))"
        cell.tvNotifyDate.text = "Ngày thông báo: \(item.createdDatetime?.substring(with: 0..<10) ?? "")"
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = backgroundView
        cell.selectionStyle = .none
//        cell.layer.borderColor = GlobalUtil.getSeperateColor().cgColor
//        cell.layer.borderWidth = 1
//        cell.layer.cornerRadius = 3
//        cell.clipsToBounds = true
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 197
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 197
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //GlobalUtil.showToast(context: self, message: "test")
    }
    @IBOutlet var tbPayment: UITableView!
    @IBOutlet var tbYear: UIButton!
    
    @IBAction func btYearSelector(_ sender: Any) {
        let datePicker = ActionSheetStringPicker(title: "Chọn năm", rows: GlobalUtil.getYearList(), initialSelection: 10, doneBlock: { (picker, value, index) in
            if index != nil{
                self.tbYear.setTitle("\((index! as? String)!)", for: .normal)
                self.currentYear = (index! as? String)!
                self.getFeeList(year: Int((index! as? String)!)!)
            }
            return
        }, cancel: nil, origin: (sender as AnyObject).superview!?.superview)
        datePicker?.show()
    }
    @objc func chartAction() {
        if isLogin {
            
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            let loginStoryboard :UIStoryboard = UIStoryboard(name: "Chart", bundle: nil)
            let chartView = loginStoryboard.instantiateViewController(withIdentifier: "charView") as! ChartViewController
            for i in 0 ..< feeList.count {
                let item = feeList[i]
                let month = item.month - 1
                chartView.listFee[month] = item.total
            }
            chartView.currentYear = self.currentYear
            self.addChildViewController(chartView)
            chartView.view.frame = mainView.frame
            let addView = chartView.view
            addView?.tag = viewChartTag
            self.view.addSubview(addView!)
            chartView.didMove(toParentViewController: self)
        }else{
            GlobalUtil.showToast(context: self, message: "Bạn phải đăng nhập trước")
        }
        
    }
    @objc func paymentAction() {
        if isLogin {
            NotificationCenter.default.post(name: NotificationConstant.swithPayment, object: nil)
        }else{
            GlobalUtil.showToast(context: self, message: "Bạn phải đăng nhập trước")
        }
    }
    func setNavigationBar() {
        chartButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chartAction)))
        paymentButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(paymentAction)))
        navigationController?.navigationBar.tintColor = GlobalUtil.getGrayColor()
        let backButton = UIBarButtonItem(title: "Chi phí dịch vụ", style: UIBarButtonItemStyle.done, target: nil, action: nil)
        backButton.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: 20)], for: .normal)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        navigationItem.rightBarButtonItems =  [UIBarButtonItem(customView: chartButton),UIBarButtonItem(customView: paymentButton)]
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        if frame == nil {
            frame = self.view.frame
        }
        NotificationCenter.default.addObserver(self, selector: #selector(reloadForm), name: NotificationConstant.loginNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(swithForm), name: NotificationConstant.swithPayment, object: nil)
        isLogin = GlobalUtil.getBoolPreference(key: GlobalUtil.isLogin)
        if !isLogin {
            let loginStoryboard :UIStoryboard = UIStoryboard(name: "NotLoginScreen", bundle: nil)
            let loginView = loginStoryboard.instantiateViewController(withIdentifier: "loginView") as! NotLoginViewController
            self.addChildViewController(loginView)
            loginView.view.frame = frame
            let addView = loginView.view
            addView?.tag = loginTag
            self.view.addSubview(addView!)
            loginView.didMove(toParentViewController: self)
        }else{
            tbPayment.separatorStyle = .none
            NotificationCenter.default.addObserver(self, selector: #selector(reloadFormPayment(_:)), name: NotificationConstant.reloadFromChartView, object: nil)
            tbYear.setTitle("\(currentYear)", for: .normal)
            if let viewWithTag = self.view.viewWithTag(loginTag){
                viewWithTag.removeFromSuperview()
            }
            getFeeList( year: Int(currentYear)!)
            tbPayment.reloadData()
        }
    }
    @objc func reloadForm() {
        isLogin = GlobalUtil.getBoolPreference(key: GlobalUtil.isLogin)
        self.viewDidLoad()
    }
    
    @objc func swithForm (){
        if let viewWithTag = self.view.viewWithTag(viewChartTag){
            viewWithTag.removeFromSuperview()
        }
    }
    func getFeeList(year:Int) {
        self.startLoading(mIsLoading: true)
        let getFeeListRequest = GetFeeListRequest()
        getFeeListRequest.clientId = GlobalInfo.sharedInstance.getUserInfo().clientId
        getFeeListRequest.roomCode = GlobalInfo.sharedInstance.getUserInfo().roomCode
        getFeeListRequest.year = "\(year)"
        getFeeListRequest.isPagging = false
        getFeeListRequest.page = "1"
        ServiceApi.shareInstance.postWebService(objc: GetFeeListResponse.self, urlStr: Constant.sharedInstance.getFeeListURL(), headers: ServiceApi.shareInstance.getHeader(), completion: { (isSuccess, dataResponse) in
            if isSuccess{
                let result = dataResponse as! GetFeeListResponse
                if result.resultCode == "200"{
                    self.feeList = result.list!
                    self.tbPayment.reloadData()
                }else{
                    GlobalUtil.showToast(context: self, message: "Không thể lấy danh sách chi phí hàng tháng")
                }
            }else{
                GlobalUtil.showToast(context: self, message: "Không thể lấy danh sách chi phí hàng tháng")
            }
//            NotificationCenter.default.post(name: NotificationConstant.reloadFromPaymentView, object: nil, userInfo: ["Data":self.feeList,"currentYear":self.currentYear])
            self.startLoading(mIsLoading: false)
        }, parameter: getFeeListRequest.toDict())
    }
    @objc func reloadFormPayment(_ notification: NSNotification) {
        feeList = (notification.userInfo!["Data"] as? [FeeItem])!
        currentYear = (notification.userInfo!["currentYear"] as? String)!
        self.tbYear.setTitle("\(currentYear)", for: .normal)
        tbPayment.reloadData()
    }
    func startLoading(mIsLoading:Bool) {
        if mIsLoading {
            self.isLoading.startAnimating()
            self.isLoading.isHidden = false
        }else{
            self.isLoading.stopAnimating()
            self.isLoading.isHidden = true
        }
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
