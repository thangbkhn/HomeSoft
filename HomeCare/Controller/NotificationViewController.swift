//
//  NotificationViewController.swift
//  HomeCare
//
//  Created by Nguyen Van Tho on 3/19/18.
//  Copyright © 2018 Viettel. All rights reserved.
//

import UIKit
import MGSwipeTableCell
import RAMAnimatedTabBarController

class NotificationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tbNotification: UITableView!
    @IBOutlet weak var isLoading: UIActivityIndicatorView!
    
    var isLogin = false
    var frame:CGRect!
    var notificationList :[NotificationItem] = []
    var networkAvalible = true
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:NotificationTableCell = tableView.dequeueReusableCell(withIdentifier: "CellItem", for: indexPath) as! NotificationTableCell
        let item = notificationList[indexPath.row]
        cell.tvTitle.text = item.title != nil ? "Tiêu đề: \(item.title ?? "")" : "Tiêu đề: "
        cell.tvDate.text = item.updatedDatetime != nil ? item.updatedDatetime?.substring(with: 0..<10) : ""
        cell.tvToPerson.text = "Tới: \(item.ownerName ?? "")"
        cell.tvContent.text = "Mô tả: \(item.desc ?? "")"
        cell.imgAttachment.isHidden = item.urlAttach == nil ? true:false
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = backgroundView
        cell.selectionStyle = .none
        
        cell.backgroundColor = .white
        cell.rightButtons = [MGSwipeButton(title: "Xoá", icon: nil, backgroundColor: UIColor.gray, insets: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15), callback: { (edit) -> Bool in
            
            return true
        }), MGSwipeButton(title: " Xem", icon: nil, backgroundColor: UIColor.brown, insets: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15), callback: { (open) -> Bool in
            let item = self.notificationList[indexPath.row]
            let storyBoard : UIStoryboard = UIStoryboard(name: "ReplyComment", bundle:nil)
            let commentViewController = storyBoard.instantiateViewController(withIdentifier: "replyComment") as! ReplyCommentViewController
            commentViewController.type = ReplyCommentViewController.NOTIFICATION
            commentViewController.notificationItem = item
            self.navigationController?.pushViewController(commentViewController, animated: true)
            return true
        })]
        cell.rightSwipeSettings.transition = .rotate3D
        cell.alpha = 0
        UIView.animate(withDuration: 1.5, animations: { cell.alpha = 1 })
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
        //navigationController?.navigationBar.tintColor = GlobalUtil.getGrayColor()
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = GlobalUtil.getMainColor()
        let backButton = UIBarButtonItem(title: "   Thông báo", style: UIBarButtonItemStyle.done, target: nil, action: nil)
        backButton.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: 20)], for: .normal)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
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
    func loadDatabase() {
        var notification = NotificationItem()
        self.notificationList = SqliteHelper.shareInstance.getDataList(tableName: Constant.NotificationTable, keyIdList: [], keyValueList: [], classtype: &notification)
    }
    func loadNotification(page:Int) {
        self.startLoading(mIsLoading: true)
         let notificationRequest = GetListRequest()
        notificationRequest.clientId = GlobalInfo.sharedInstance.getUserInfo().clientId
        notificationRequest.isPagging = true
        notificationRequest.page = page
        ServiceApi.shareInstance.postWebService(objc: NotificationResponnse.self, urlStr: Constant.sharedInstance.getAllNotificationURL(), headers: ServiceApi.shareInstance.getHeader(), completion: { (isSuccess, responseData) in
            if isSuccess{
                let notificationResponse = responseData as! NotificationResponnse
                if notificationResponse.resultCode == "200"{
                    var notification = NotificationItem()
                    self.notificationList = notificationResponse.list!
                    SqliteHelper.shareInstance.insertOrUpdateList(tableName: Constant.NotificationTable, dataList: notificationResponse.list!, keyId: "id", classtype: &notification)
                    self.tbNotification.reloadData()
                }else{
                    GlobalUtil.showToast(context: self, message: "Không thể lấy danh sách thông báo")
                }
            }
            self.startLoading(mIsLoading: false)
        }, parameter: notificationRequest.toDict())
    }
    //keyboard
    @objc func dismissKeyBoard(){
        self.view.endEditing(true)
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
