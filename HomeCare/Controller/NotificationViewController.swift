//
//  NotificationViewController.swift
//  HomeCare
//
//  Created by Nguyen Van Tho on 3/19/18.
//  Copyright © 2018 Viettel. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class NotificationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tbNotification: UITableView!
    var isLogin = false
    var frame:CGRect!
    var notificationList :[NotificationItem] = []
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:NotificationTableCell = tableView.dequeueReusableCell(withIdentifier: "CellItem", for: indexPath) as! NotificationTableCell
        let item = notificationList[indexPath.row]
        cell.tvTitle.text = item.title != nil ? "Tiêu đề: \(item.title ?? "")" : "Tiêu đề: "
        cell.tvDate.text = item.updatedDatetime != nil ? item.updatedDatetime?.substring(with: 0..<10) : ""
        cell.tvToPerson.text = "Tới: \(item.ownerName ?? "")"
        //cell.tvContent.text = item.desc != nil ? "Mô tả: \(item.desc ?? "")" : "Mô tả: "
        cell.tvContent.text = "Mô tả: \(item.desc ?? "")"
        cell.imgAttachment.isHidden = item.urlAttach == nil ? true:false
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = backgroundView
        cell.selectionStyle = .none
        
        cell.backgroundColor = .white
        cell.layer.borderColor = GlobalUtil.getSeperateColor().cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 3
        cell.clipsToBounds = true
        cell.rightButtons = [MGSwipeButton(title: "Xoá", icon: nil, backgroundColor: UIColor.gray, insets: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15), callback: { (edit) -> Bool in
            
            return true
        }), MGSwipeButton(title: " Xem", icon: nil, backgroundColor: UIColor.brown, insets: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15), callback: { (open) -> Bool in
            let item = self.notificationList[indexPath.row]
            GlobalUtil.showInfoDialog(context: self, title: item.title ?? "", message: item.desc ?? "Nội dung không có sẵn")
            return true
        })]
        cell.rightSwipeSettings.transition = .rotate3D
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! NotificationTableCell
        cell.showSwipe(.rightToLeft, animated: true)
    }
    override func viewDidLoad() {
        if frame == nil {
            frame = self.view.frame
        }
        NotificationCenter.default.addObserver(self, selector: #selector(reloadForm), name: NotificationConstant.loginNotification, object: nil)
        isLogin = GlobalUtil.getBoolPreference(key: GlobalUtil.isLogin)
        let tap = UITapGestureRecognizer(target: self, action:#selector(dismissKeyBoard))
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
        if !isLogin {
            let loginStoryboard :UIStoryboard = UIStoryboard(name: "NotLoginScreen", bundle: nil)
            let loginView = loginStoryboard.instantiateViewController(withIdentifier: "loginView") as! NotLoginViewController
            self.addChildViewController(loginView)
            loginView.view.frame = frame
            let addView = loginView.view
            addView?.tag = 100
            self.view.addSubview(addView!)
            loginView.didMove(toParentViewController: self)
        }else{
            self.tbNotification.separatorStyle = .none
            if let viewWithTag = self.view.viewWithTag(100){
                viewWithTag.removeFromSuperview()
            }
            loadNotification(page: 1)
        }
    }
    @objc func reloadForm() {
        isLogin = GlobalUtil.getBoolPreference(key: GlobalUtil.isLogin)
        self.viewDidLoad()
    }
    func loadNotification(page:Int) {
         let notificationRequest = GetListRequest()
        notificationRequest.clientId = GlobalInfo.sharedInstance.userInfo?.clientId
        notificationRequest.isPagging = true
        notificationRequest.page = page
        ServiceApi.shareInstance.postWebService(objc: NotificationResponnse.self, urlStr: Constant.getAllNotificationURL, headers: ServiceApi.shareInstance.getHeader(), completion: { (isSuccess, responseData) in
            if isSuccess{
                let notificationResponse = responseData as! NotificationResponnse
                if notificationResponse.resultCode == "200"{
                    self.notificationList = notificationResponse.list!
                    self.tbNotification.reloadData()
                }else{
                    GlobalUtil.showToast(context: self, message: "Không thể lấy danh sách thông báo")
                }
            }
        }, parameter: notificationRequest.toDict())
    }
    //keyboard
    @objc func dismissKeyBoard(){
        self.view.endEditing(true)
    }
}
