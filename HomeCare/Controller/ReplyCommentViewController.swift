//
//  ReplyCommentViewController.swift
//  HomeCare
//
//  Created by Thang BKHN on 5/1/18.
//  Copyright © 2018 Viettel. All rights reserved.
//

import UIKit
import RAMAnimatedTabBarController

class ReplyCommentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tvUSer: UILabel!
    @IBOutlet weak var tvContent: UILabel!
    @IBOutlet weak var tvDate: UILabel!
    @IBOutlet weak var tvContentSend: UITextField!
    @IBOutlet weak var tbReply: UITableView!
    let nib = UINib(nibName: "CommentCell", bundle: nil)
    static let TICKET = 1
    static let FEEEDBACK = 2
    static let NOTIFICATION = 3
    var type = 0
    var notificationItem:NotificationItem!
    var requestItem:TicketItem!
    var feedbackItem:FeedbackItem!
    var commentList:[CommentItem] = []
    let ITEM_LIMIT = 10
    var refresher: UIRefreshControl!
    var isLoadMore = true
    let footerView = FooterView()
    var page = 1
    var searchController:UISearchController!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.titleView = self.searchController.searchBar;
        self.searchController.searchBar.isHidden = true
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.tintColor = GlobalUtil.getGrayColor()
        let backButton = UIBarButtonItem(title: "Bình luận", style: UIBarButtonItemStyle.done, target: nil, action: nil)
        backButton.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: 20)], for: .normal)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard)))
        tbReply.register(nib, forCellReuseIdentifier: "commmentCell")
        if type == ReplyCommentViewController.TICKET {
            tvUSer.text = "Loại yêu cầu: \(requestItem.ticketTypeName ?? "")"
            tvContent.text = "Nội dung: \(requestItem.desc ?? "")"
            tvDate.text = requestItem.updatedDatetime != nil ? requestItem.updatedDatetime?.substring(with: 0..<10) : ""
        }else if type == ReplyCommentViewController.NOTIFICATION{
            tvUSer.text = "Tiêu đề: \(notificationItem.title ?? "")"
            tvContent.text = "Nội dung: \(notificationItem.desc ?? "")"
            tvDate.text = notificationItem.updatedDatetime != nil ? notificationItem.updatedDatetime?.substring(with: 0..<10) : ""
        }else if type == ReplyCommentViewController.FEEEDBACK{
            tvUSer.text = "\(feedbackItem.ownerName ?? "")"
            tvContent.text = "Nội dung: \(feedbackItem.content ?? "")"
            tvDate.text = feedbackItem.updatedDatetime != nil ? feedbackItem.updatedDatetime?.substring(with: 0..<10) : ""
        }
        tbReply.separatorStyle = .none
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(refreshData), for: UIControlEvents.valueChanged)
        tbReply.addSubview(refresher)
        tbReply.tableFooterView?.isHidden = true
        if let window = UIApplication.shared.keyWindow {
            footerView.backgroundColor = UIColor.clear
            footerView.frame.size = CGSize(width: window.frame.width, height: 48)
            footerView.activityIndicatorView.startAnimating()
            tbReply.tableFooterView = footerView
        }
        page = 1
        getComment()
    }
    override func viewWillAppear(_ animated: Bool) {
        let animatedTabBar = self.tabBarController as! RAMAnimatedTabBarController
        animatedTabBar.animationTabBarHidden(true)
    }
    @IBAction func btSend(_ sender: Any) {
        postComment()
    }
    @IBAction func btReply(_ sender: Any) {
        tvContentSend.text = "@\(tvUSer.text ?? "") "
        tvContentSend.becomeFirstResponder()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commmentCell", for: indexPath) as! ReplyCommentTableViewCell
        cell.tvContent.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.preservesSuperviewLayoutMargins = false
        cell.replyAction = {
            self.tvContentSend.text = "@\(cell.tvUser.text ?? "") "
            self.tvContentSend.becomeFirstResponder()
        }
        let item = commentList[indexPath.row]
        cell.tvUser.text = item.ownerFullname!
        cell.tvContent.text = item.content
        cell.tvDate.text = item.updatedDatetime != nil ? item.updatedDatetime?.substring(with: 0..<10) : ""
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isLoadMore{
            let lastItem = self.commentList.count - 1
            if indexPath.item == lastItem{
                page = page + 1
                getComment()
            }
        }
    }
    //keyboard
    @objc func dismissKeyBoard(){
        self.view.endEditing(true)
    }
    func getComment()  {
        let getCommentRequest = GetCommentRequest()
        getCommentRequest.isPagging = true
        getCommentRequest.page = "1"
        var url = ""
        if type == ReplyCommentViewController.TICKET {
            getCommentRequest.clientId = requestItem.clientId!
            getCommentRequest.id = requestItem.id
            url = Constant.getTicketCommentURL
        }else if type == ReplyCommentViewController.NOTIFICATION{
            getCommentRequest.clientId = notificationItem.clientId!
            getCommentRequest.id = notificationItem.id
            url = Constant.getNotificationCommentURL
        }else if type == ReplyCommentViewController.FEEEDBACK{
            getCommentRequest.clientId = feedbackItem.clientId!
            getCommentRequest.id = feedbackItem.id
            url = Constant.getFeedbackCommentURL
        }
        ServiceApi.shareInstance.postWebService(objc: GetCommentRespone.self, urlStr: url, headers: ServiceApi.shareInstance.getHeader(), completion: { (isSuccess, dataResponse) in
            if self.page == 1{
                self.commentList = []
            }
            if isSuccess{
                let result = dataResponse as! GetCommentRespone
                if result.resultCode == "200"{
                    if let list = result.commentList {
                        self.handleListResult(dataList: list)
                    }
                }else{
                    GlobalUtil.showToast(context: self, message: "Không thể lấy danh sách góp ý")
                }
            }else{
                GlobalUtil.showToast(context: self, message: "Không thể lấy danh sách góp ý")
            }
            self.tbReply.reloadData()
            if (self.refresher != nil && self.refresher.isRefreshing) {
                self.refresher.endRefreshing()
                self.refresher.isHidden = true
            }
            self.footerView.isHidden = true
        }, parameter: getCommentRequest.toDict())
    }
    func handleListResult(dataList:[CommentItem]) {
        if dataList.count < self.ITEM_LIMIT {
            self.tbReply.tableFooterView?.frame.size = CGSize(width: (self.tbReply.tableFooterView?.frame.width)!, height: 0)
            self.tbReply.tableFooterView?.isHidden = true
            self.isLoadMore = false
        } else if !self.isLoadMore {
            self.tbReply.tableFooterView?.frame.size = CGSize(width: (self.tbReply.tableFooterView?.frame.width)!, height: 48)
            self.tbReply.tableFooterView?.isHidden = false
            self.footerView.activityIndicatorView.startAnimating()
            self.isLoadMore = true
        }
        self.commentList.append(contentsOf: dataList)
        self.tbReply.reloadData()
    }
    func postComment() {
        let info = CommentItem()
        if type == ReplyCommentViewController.TICKET {
            info.postId = requestItem.id
        }else if type == ReplyCommentViewController.NOTIFICATION{
            info.postId = notificationItem.id
        }else if type == ReplyCommentViewController.FEEEDBACK{
            info.postId = feedbackItem.id
        }
        info.postType = "\(type)"
        info.content = tvContentSend.text
        info.ownerId = GlobalInfo.sharedInstance.userInfo?.id
        info.ownerFullname = GlobalInfo.sharedInstance.userInfo?.fullName
        info.postTitle = GlobalInfo.sharedInstance.userInfo?.fullName
        info.clientId = GlobalInfo.sharedInstance.userInfo?.clientId
        info.createdDatetime = GlobalUtil.getCurrentDate()
        info.updatedDatetime = GlobalUtil.getCurrentDate()
        let request = UpdateRequest()
        request.info = info.toDict()
        request.clientId = GlobalInfo.sharedInstance.userInfo?.clientId
        request.userId = GlobalInfo.sharedInstance.userInfo?.id
        ServiceApi.shareInstance.postWebService(objc: ReplyComentResponse.self, urlStr: Constant.postCommentURL, headers: ServiceApi.shareInstance.getHeader(), completion: { (isSuccess, dataResponse) in
            if isSuccess{
                let result = dataResponse as! ReplyComentResponse
                if result.resultCode == "200"{
                    if let data = result.info{
                        let dataList = [data]
                        self.handleListResult(dataList: dataList)
                        self.tvContentSend.text = ""
                    }
                }else{
                    GlobalUtil.showToast(context: self, message: "Không thể lấy gửi bình luận")
                }
            }else{
                GlobalUtil.showToast(context: self, message: "Không thể lấy gửi bình luận")
            }
        }, parameter: request.toDict())
    }
    @objc func refreshData() {
        page = 1
        getComment()
    }
}
