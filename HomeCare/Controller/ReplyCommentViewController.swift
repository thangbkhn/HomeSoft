//
//  ReplyCommentViewController.swift
//  HomeCare
//
//  Created by Thang BKHN on 5/1/18.
//  Copyright © 2018 Viettel. All rights reserved.
//

import UIKit
import RAMAnimatedTabBarController
import Kingfisher

class ReplyCommentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tvUSer: UILabel!
    @IBOutlet weak var tvContent: UILabel!
    @IBOutlet weak var tvDate: UILabel!
    @IBOutlet weak var tvContentSend: UITextField!
    @IBOutlet weak var tbReply: UITableView!
    @IBOutlet weak var layoutContent: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var imgOwner: UIImageView!
    
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
    //var searchController:UISearchController!
    var tbHeightOri:CGFloat = 0.0 ;
    override func viewDidLoad() {
        super.viewDidLoad()
        tbHeightOri = tbReply.frame.size.height
        imageAvatar.image = GlobalUtil.getAvatarImg()
        imgOwner.image = GlobalUtil.getAvatarImg()
//        self.searchController = UISearchController(searchResultsController: nil)
//        self.navigationItem.titleView = self.searchController.searchBar;
//        self.searchController.searchBar.isHidden = true
        //self.navigationController?.navigationBar.tintColor = .white
//        navigationController?.navigationBar.tintColor = .white
        let backButton = UIBarButtonItem(title: "   Bình luận", style: UIBarButtonItemStyle.done, target: nil, action: nil)
        backButton.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: 20)], for: .normal)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard)))
        tbReply.register(nib, forCellReuseIdentifier: "commmentCell")
        tvContent.lineBreakMode = NSLineBreakMode.byWordWrapping
        layoutContent.preservesSuperviewLayoutMargins = false
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
//        if(item.ownerImg != nil){
//            cell.imgOwner.kf.setImage(with: URL(string:(item.ownerImg?.replacingOccurrences(of: "~", with: Constant.sharedInstance.downFileUrl))!))
//        }
        let url = "~/Content/images/user.png".replacingOccurrences(of: "~", with: Constant.sharedInstance.downFileUrl)
        cell.imgOwner.kf.setImage(with: URL(string:url	))
        cell.selectionStyle = .none
        cell.alpha = 0
        UIView.animate(withDuration: 1.5, animations: { cell.alpha = 1 })
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
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        for cell in tbReply.visibleCells as [UITableViewCell] {
//            let point = tbReply.convert(cell.center, to: tbReply.superview)
//            cell.alpha = ((point.y * 100) / tbReply.bounds.maxY) / 100
//        }
//    }
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
            url = Constant.sharedInstance.getTicketCommentURL()
        }else if type == ReplyCommentViewController.NOTIFICATION{
            getCommentRequest.clientId = notificationItem.clientId!
            getCommentRequest.id = notificationItem.id
            url = Constant.sharedInstance.getNotificationCommentURL()
        }else if type == ReplyCommentViewController.FEEEDBACK{
            getCommentRequest.clientId = feedbackItem.clientId!
            getCommentRequest.id = feedbackItem.id
            url = Constant.sharedInstance.getFeedbackCommentURL()
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
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//            self.reloadForm()
//        }
        
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
        info.ownerId = GlobalInfo.sharedInstance.getUserInfo().id
        info.ownerFullname = GlobalInfo.sharedInstance.getUserInfo().fullName
        info.postTitle = GlobalInfo.sharedInstance.getUserInfo().fullName
        info.clientId = GlobalInfo.sharedInstance.getUserInfo().clientId
        info.createdDatetime = GlobalUtil.getCurrentDate()
        info.updatedDatetime = GlobalUtil.getCurrentDate()
        info.ownerImg = GlobalInfo.sharedInstance.getUserInfo().imageUrl
        let request = UpdateRequest()
        request.info = info.toDict()
        request.clientId = GlobalInfo.sharedInstance.getUserInfo().clientId
        request.userId = GlobalInfo.sharedInstance.getUserInfo().id
        ServiceApi.shareInstance.postWebService(objc: ReplyComentResponse.self, urlStr: Constant.sharedInstance.postCommentURL(), headers: ServiceApi.shareInstance.getHeader(), completion: { (isSuccess, dataResponse) in
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
    func reloadForm(){
        
        self.tbReply.layoutIfNeeded()
        let changeHeigh = tbReply.contentSize.height - tbHeightOri
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.mainView.setNeedsLayout()
            self.mainView.layoutIfNeeded()
            let layoutfrm = self.mainView.frame
            self.mainView.frame.size.height = layoutfrm.height + changeHeigh
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.tbReply.setNeedsLayout()
            self.tbReply.layoutIfNeeded()
            let frm = self.tbReply.frame
            self.tbReply.frame.size.height = frm.height + changeHeigh
            //self.tbReply.contentSize = CGSize(width: frm.width, height: frm.height + changeHeigh)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6){
            self.scrollView.layoutIfNeeded()
            self.scrollView.isScrollEnabled = true
            let layoutfrm = self.scrollView.frame
            self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: layoutfrm.height + changeHeigh)
        }
    }
}
