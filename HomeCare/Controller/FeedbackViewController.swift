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
    
    var isLogin = false
    let loginTag = 1
    var frame:CGRect!
    var feedbackList:[FeedbackItem] = []
    let ITEM_LIMIT = 10
    var refresher: UIRefreshControl!
    var isLoadMore = true
    let footerView = FooterView()
    var page = 1
    @IBOutlet weak var tbComment: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if frame == nil {
            frame = self.view.frame
        }
        //Shadow navigation line
        navigationController?.navigationBar.setBackgroundImage(UIColor.clear.as1ptImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIColor.gray.as1ptImage()
        
        navigationController?.navigationBar.tintColor = GlobalUtil.getGrayColor()
        let backButton = UIBarButtonItem(title: "Góp ý", style: UIBarButtonItemStyle.done, target: nil, action: nil)
        backButton.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: 20)], for: .normal)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        NotificationCenter.default.addObserver(self, selector: #selector(reloadForm), name: NotificationConstant.loginNotification, object: nil)
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
            tbComment.separatorStyle = .none
            if let viewWithTag = self.view.viewWithTag(loginTag){
                viewWithTag.removeFromSuperview()
            }
            refresher = UIRefreshControl()
            refresher.addTarget(self, action: #selector(refreshData), for: UIControlEvents.valueChanged)
            tbComment.addSubview(refresher)
            tbComment.tableFooterView?.isHidden = true
            if let window = UIApplication.shared.keyWindow {
                footerView.backgroundColor = UIColor.clear
                footerView.frame.size = CGSize(width: window.frame.width, height: 48)
                footerView.activityIndicatorView.startAnimating()
                tbComment.tableFooterView = footerView
            }
            page = 1
            getFeedbackList()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedbackList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentTableViewCell
        let item = feedbackList[indexPath.row]
        //cell.tvComment.lineBreakMode = NSLineBreakMode.byWordWrapping
        //cell.preservesSuperviewLayoutMargins = false
        cell.selectionStyle = .none
        cell.tvUser.text = item.ownerName
        cell.tvComment.text = item.content
        cell.tvDate.text =  item.updatedDatetime != nil ? item.updatedDatetime?.substring(with: 0..<10) : ""
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "ReplyComment", bundle:nil)
        let replyCommentViewController = storyBoard.instantiateViewController(withIdentifier: "replyComment") as! ReplyCommentViewController
        replyCommentViewController.type = ReplyCommentViewController.FEEEDBACK
        replyCommentViewController.feedbackItem = feedbackList[indexPath.row]
        self.navigationController?.pushViewController(replyCommentViewController, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isLoadMore{
            let lastItem = self.feedbackList.count - 1
            if indexPath.item == lastItem{
                page = page + 1
                getFeedbackList()
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    @objc func refreshData() {
        page = 1
        getFeedbackList()
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
    func getFeedbackList() {
        let request = GetFeedbackRequest()
        request.clientId = GlobalInfo.sharedInstance.getUserInfo().clientId
        request.isPagging = true
        request.page = "1"
        request.username = GlobalInfo.sharedInstance.getUserInfo().mobile
        ServiceApi.shareInstance.postWebService(objc: GetFeedbackResponse.self, urlStr: Constant.sharedInstance.getFeedbackListUrl(), headers: ServiceApi.shareInstance.getHeader(), completion: { (isSuccess, dataResponse) in
            if self.page == 1{
                self.feedbackList = []
            }
            if isSuccess{
                let result = dataResponse as! GetFeedbackResponse
                if result.resultCode == "200"{
                    if let list = result.list {
                        self.handleListResult(dataList: list)
                    }
                }else{
                    GlobalUtil.showToast(context: self, message: "Không thể lấy danh sách góp ý")
                }
            }else{
                GlobalUtil.showToast(context: self, message: "Không thể lấy danh sách góp ý")
            }
            self.tbComment.reloadData()
            if (self.refresher != nil && self.refresher.isRefreshing) {
                self.refresher.endRefreshing()
                self.refresher.isHidden = true
            }
            self.footerView.isHidden = true
        }, parameter: request.toDict())
    }
    func handleListResult(dataList:[FeedbackItem]) {
        if feedbackList.count < self.ITEM_LIMIT {
            self.tbComment.tableFooterView?.frame.size = CGSize(width: (self.tbComment.tableFooterView?.frame.width)!, height: 0)
            self.tbComment.tableFooterView?.isHidden = true
            self.isLoadMore = false
        } else if !self.isLoadMore {
            self.tbComment.tableFooterView?.frame.size = CGSize(width: (self.tbComment.tableFooterView?.frame.width)!, height: 48)
            self.tbComment.tableFooterView?.isHidden = false
            self.footerView.activityIndicatorView.startAnimating()
            self.isLoadMore = true
        }
        self.feedbackList.append(contentsOf: dataList)
        self.tbComment.reloadData()
    }
    func addFeedback(content:String) {
        let info = FeedbackItem()
        info.content = content
        info.ownerId = GlobalInfo.sharedInstance.getUserInfo().id
        info.ownerName = GlobalInfo.sharedInstance.getUserInfo().fullName
        info.roomId = GlobalInfo.sharedInstance.getUserInfo().roomId
        info.roomCode = GlobalInfo.sharedInstance.getUserInfo().roomCode
        info.roomName = GlobalInfo.sharedInstance.getUserInfo().roomName
        
        let request = AddObjectRequest()
        request.clientId = GlobalInfo.sharedInstance.getUserInfo().clientId
        request.userId = GlobalInfo.sharedInstance.getUserInfo().id
        request.info = info.toDict()
        
        ServiceApi.shareInstance.postWebService(objc: AddFeedbackResponse.self, urlStr: Constant.sharedInstance.addFeedback(), headers: ServiceApi.shareInstance.getHeader(), completion: { (isSuccess, dataResponse) in
            if isSuccess{
                let data = dataResponse as! AddFeedbackResponse
                if data.resultCode == "200"{
                    if data.info != nil{
                        let newItem = [data.info!]
                        self.handleListResult(dataList: newItem)
                    }
                    
                }else{
                    GlobalUtil.showToast(context: self, message: "Không thể gửi góp ý")
                }
            }else{
                GlobalUtil.showToast(context: self, message: "Không thể gửi góp ý")
            }
        }, parameter: request.toDict())
    }
}
extension FeedbackViewController:CustomAlertViewDelegate{
    func okButtonTapped( commentStr: String) {
        self.addFeedback(content: commentStr)
    }
    
    func cancelButtonTapped() {
        GlobalUtil.showToast(context: self, message: "Huỷ đánh giá")
    }
    
    
}
