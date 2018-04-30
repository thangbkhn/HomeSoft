//
//  ChartViewController.swift
//  HomeCare
//
//  Created by Nguyen Van Tho on 3/20/18.
//  Copyright © 2018 Viettel. All rights reserved.
//

import UIKit
import SwiftChart
import ActionSheetPicker_3_0
class ChartViewController: UIViewController {

    //@IBOutlet var txtRoomNumber: UILabel!
    @IBOutlet var chartView: Chart!
    @IBOutlet var btYear: UIButton!
    @IBOutlet weak var isLoading: UIActivityIndicatorView!
    var listFee :[Double] = [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]
    var currentYear = GlobalUtil.getYearList()[10]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startLoading(mIsLoading: false)
//        NotificationCenter.default.addObserver(self, selector: #selector(reloadForm(_:)), name: NotificationConstant.reloadFromPaymentView, object: nil)
        //txtRoomNumber.text = "Căn hộ \(GlobalInfo.sharedInstance.userInfo?.roomName ?? "")"
        btYear.setTitle("\(currentYear)", for: .normal)
        chartView.removeAllSeries()
        let data = [
            (x: 1, y: listFee[0]),
            (x: 2, y: listFee[1]),
            (x: 3, y: listFee[2]),
            (x: 4, y: listFee[3]),
            (x: 5, y: listFee[4]),
            (x: 6, y: listFee[5]),
            (x: 7, y: listFee[6]),
            (x: 8, y: listFee[7]),
            (x: 9, y: listFee[8]),
            (x: 10, y: listFee[9]),
            (x: 11, y: listFee[10]),
            (x: 12, y: listFee[11])
        ]
        let series = ChartSeries(data: data)
        chartView.add(series)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btYearSelector(_ sender: Any) {
        let datePicker = ActionSheetStringPicker(title: "Chọn năm", rows: GlobalUtil.getYearList(), initialSelection: 10, doneBlock: { (picker, value, index) in
            if index != nil{
                self.btYear.setTitle("\((index! as? String)!)", for: .normal)
                self.currentYear = (index! as? String)!
                self.getFeeList(year: Int((index! as? String)!)!)
            }
            return
        }, cancel: nil, origin: (sender as AnyObject).superview!?.superview)
        datePicker?.show()
    }
    
//    @objc func reloadForm(_ notification: NSNotification) {
//        self.reloadData(feeList: (notification.userInfo!["Data"] as? [FeeItem])! )
//        currentYear = (notification.userInfo!["currentYear"] as? String)!
//        self.btYear.setTitle("Năm \(currentYear)", for: .normal)
//    }
    func reloadData(feeList:[FeeItem]) {
        listFee = [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]
        for i in 0 ..< feeList.count {
            let item = feeList[i]
            let month = item.month - 1
            listFee[month] = item.total
        }
        chartView.removeAllSeries()
        let data = [
            (x: 1, y: listFee[0]),
            (x: 2, y: listFee[1]),
            (x: 3, y: listFee[2]),
            (x: 4, y: listFee[3]),
            (x: 5, y: listFee[4]),
            (x: 6, y: listFee[5]),
            (x: 7, y: listFee[6]),
            (x: 8, y: listFee[7]),
            (x: 9, y: listFee[8]),
            (x: 10, y: listFee[9]),
            (x: 11, y: listFee[10]),
            (x: 12, y: listFee[11])
        ]
        let series = ChartSeries(data: data)
        chartView.add(series)
    }
    func getFeeList(year:Int) {
        self.startLoading(mIsLoading: true)
        let getFeeListRequest = GetFeeListRequest()
        getFeeListRequest.clientId = GlobalInfo.sharedInstance.userInfo?.clientId
        getFeeListRequest.roomCode = GlobalInfo.sharedInstance.userInfo?.roomCode
        getFeeListRequest.year = "\(year)"
        getFeeListRequest.isPagging = false
        getFeeListRequest.page = "1"
        ServiceApi.shareInstance.postWebService(objc: GetFeeListResponse.self, urlStr: Constant.getFeeListURL, headers: ServiceApi.shareInstance.getHeader(), completion: { (isSuccess, dataResponse) in
            var feeList:[FeeItem] = []
            if isSuccess{
                let result = dataResponse as! GetFeeListResponse
                if result.resultCode == "200"{
                    feeList = result.list!
                    self.reloadData(feeList: feeList)
                }else{
                    GlobalUtil.showToast(context: self, message: "Không thể lấy danh sách chi phí hàng tháng")
                }
            }else{
                GlobalUtil.showToast(context: self, message: "Không thể lấy danh sách chi phí hàng tháng")
            }
            NotificationCenter.default.post(name: NotificationConstant.reloadFromChartView, object: nil, userInfo: ["Data":feeList,"currentYear":self.currentYear])
            self.startLoading(mIsLoading: false)
        }, parameter: getFeeListRequest.toDict())
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
}
