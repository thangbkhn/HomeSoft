//
//  TicketViewController.swift
//  HomeCare
//
//  Created by Nguyen Van Tho on 3/22/18.
//  Copyright © 2018 Viettel. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class TicketViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, CallBack, UISearchResultsUpdating, UISearchBarDelegate {
    func result(isSuccess: Bool) {
        refreshData()
    }
    
    @IBOutlet var mainView: UIView!
    @IBOutlet var tbTicket: UITableView!
    @IBOutlet var txtSum: UILabel!
    
    var isLogin = false
    var isSearch = false
    let loginTag = 1
    let ITEM_LIMIT = 10
    var ticketList:[TicketItem] = []
    var filtedTicketList:[TicketItem] = []
    var refresher: UIRefreshControl!
    var isLoadMore = true
    let footerView = FooterView()
    var page = 1
    var searchController:UISearchController!
    var resultController = UITableViewController()
    
    let backImg = UIImage(named: "ic_back_64_white")
    let searchImg = UIImage(named: "ic_search_white_64-1")
    var frame:CGRect!
    let nib = UINib(nibName: "RequestCell", bundle: nil)
    let addNavigationButton:UIButton = {
        let addNavigationIcon = UIButton(type: .system)
        addNavigationIcon.setImage(UIImage(named: "ic_add_white_64-1"), for: .normal)
        addNavigationIcon.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        addNavigationIcon.tintColor = .white
        return addNavigationIcon
    }()
    
    let searchNavigationButton:UIButton = {
        let searchNavigationIcon = UIButton(type: .system)
        searchNavigationIcon.setImage(UIImage(named: "ic_search_white_64-1"), for: .normal)
        searchNavigationIcon.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        searchNavigationIcon.tintColor = .white
        return searchNavigationIcon
    }()
    
    let logo:UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "logo")
        imageView.image = image
        return imageView
    }()
    let titleView : UILabel = {
        let titleV = UILabel()
        titleV.text = "YÊU CẦU"
        titleV.textColor = .white
        titleV.textAlignment = NSTextAlignment.center
        return titleV
    }()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tbTicket {
            return ticketList.count
        }
        return filtedTicketList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedbackItem", for: indexPath) as! TicketTableViewCell
        let item = tableView == tbTicket ? ticketList[indexPath.row] : filtedTicketList[indexPath.row]
        cell.txtTitle.text = item.ticketTypeName != nil ? "Loại yêu cầu: \(item.ticketTypeName ?? "")":"Loại yêu cầu: "
        cell.txtDate.text = item.updatedDatetime != nil ? "Ngày yêu cầu: \(item.updatedDatetime?.substring(with: 0..<10) ?? "")" : "Ngày yêu cầu: "
        cell.txtContent.text = item.desc != nil ? "Mô tả: \(item.desc ?? "")" : "Mô tả: "
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsetsMake(40,40,40,40)
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = backgroundView
        cell.selectionStyle = .none
        cell.backgroundColor = .white
        cell.layer.borderColor = GlobalUtil.getSeperateColor().cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 3
        cell.clipsToBounds = true
        
        cell.rightButtons = [MGSwipeButton(title: "Sửa", icon: nil, backgroundColor: UIColor.gray, insets: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15), callback: { (edit) -> Bool in
            let storyBoard : UIStoryboard = UIStoryboard(name: "NewRequest", bundle:nil)
            let newRequestViewController = storyBoard.instantiateViewController(withIdentifier: "newRequest") as! NewRequestViewController
            newRequestViewController.ticket = item
            newRequestViewController.callBack = self
            self.navigationController?.pushViewController(newRequestViewController, animated: true)
            return true
        }), MGSwipeButton(title: " Xem", icon: nil, backgroundColor: UIColor.brown, insets: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15), callback: { (open) -> Bool in
            GlobalUtil.showInfoDialog(context: self, title:item.ticketTypeName ?? "Yêu cầu", message: item.desc ?? "Nội dung không tồn tại")
            return true
        })]
        cell.rightSwipeSettings.transition = .rotate3D
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TicketTableViewCell
        cell.showSwipe(.rightToLeft, animated: true)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isLoadMore{
            let lastItem = self.ticketList.count - 1
            if indexPath.item == lastItem{
                page = page + 1
                loadTicket()
            }
        }
    }
    @objc func addClicked() {
        if (GlobalUtil.getBoolPreference(key: GlobalUtil.isLogin)){
            let storyBoard : UIStoryboard = UIStoryboard(name: "NewRequest", bundle:nil)
            let newRequestViewController = storyBoard.instantiateViewController(withIdentifier: "newRequest") as! NewRequestViewController
            newRequestViewController.callBack = self
            self.navigationController?.pushViewController(newRequestViewController, animated: true)
        }else{
            GlobalUtil.showToast(context: self, message: "Bạn phải đăng nhập mới được gửi yêu cầu")
        }
        
    }
    @objc func searchClicked() {
        self.searchController.searchBar.isHidden = false
        self.searchController.searchBar.becomeFirstResponder()
    }
    
    func setNavigationBar() {
        
        addNavigationButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addClicked)))
        searchNavigationButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(searchClicked)))
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]

//        navigationItem.rightBarButtonItem =  UIBarButtonItem(customView: addNavigationButton)
//        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchNavigationButton)
        //navigationItem.rightBarButtonItem =  UIBarButtonItem(customView: searchNavigationButton)
        
        navigationController?.navigationBar.barTintColor = GlobalUtil.getMainColor()
        navigationController?.navigationBar.isTranslucent = false
        
        self.searchController = UISearchController(searchResultsController: self.resultController)
        self.searchController.searchResultsUpdater = self
        self.searchController.hidesNavigationBarDuringPresentation = false;
        self.searchController.searchBar.searchBarStyle = .prominent;
        self.searchController.searchBar.tintColor = .white
        self.searchController.searchBar.placeholder = "Tìm kiếm"
        self.searchController.searchBar.setValue("Huỷ", forKey: "_cancelButtonText")
        self.searchController.searchBar.delegate = self
        self.navigationController?.navigationBar.tintColor = .white
        // Include the search bar within the navigation bar.
        self.navigationItem.titleView = self.searchController.searchBar;
        //self.searchController.searchBar.isHidden = true
        self.definesPresentationContext = true;
        
        //self.titleView.frame = (self.navigationController?.view.frame)!
        //self.navigationItem.titleView = self.titleView
    }
    func updateSearchResults(for searchController: UISearchController) {
        self.filtedTicketList = self.ticketList.filter { (ticket:TicketItem) -> Bool in
            if (self.searchController.searchBar.text != nil && self.searchController.searchBar.text != ""){
                let searchText = ConverHelper.convertVietNam(text: self.searchController.searchBar.text!)
                if(ConverHelper.convertVietNam(text: ticket.ticketTypeName ?? "").containsIgnoringCase(find: searchText) || ConverHelper.convertVietNam(text: ticket.desc ?? "").containsIgnoringCase(find: searchText)){
                    return true
                }
                return false
            }
            return false
        }
        self.resultController.tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if frame == nil {
            frame = self.view.frame
        }
        tbTicket.register(nib, forCellReuseIdentifier: "FeedbackItem")
        let tap = UITapGestureRecognizer(target: self, action:#selector(dismissKeyBoard))
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
        setNavigationBar()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadForm), name: NotificationConstant.loginNotification, object: nil)
        isLogin = GlobalUtil.getBoolPreference(key: GlobalUtil.isLogin)
        if !isLogin {
            let loginStoryboard :UIStoryboard = UIStoryboard(name: "NotLoginScreen", bundle: nil)
            let loginView = loginStoryboard.instantiateViewController(withIdentifier: "loginView") as! NotLoginViewController
            self.addChildViewController(loginView)
            loginView.view.frame = self.frame
            let addView = loginView.view
            addView?.tag = loginTag
            self.view.addSubview(addView!)
            loginView.didMove(toParentViewController: self)
        }else{
            self.tbTicket.separatorStyle = .none
            setupResultController()
            if let viewWithTag = self.view.viewWithTag(loginTag){
                viewWithTag.removeFromSuperview()
            }
            refresher = UIRefreshControl()
            refresher.addTarget(self, action: #selector(refreshData), for: UIControlEvents.valueChanged)
            tbTicket.addSubview(refresher)
            tbTicket.tableFooterView?.isHidden = true
            if let window = UIApplication.shared.keyWindow {
                footerView.backgroundColor = UIColor.clear
                footerView.frame.size = CGSize(width: window.frame.width, height: 48)
                footerView.activityIndicatorView.startAnimating()
                tbTicket.tableFooterView = footerView
            }
            page = 1
            loadTicket()
        }
    }
    @objc func refreshData() {
        page = 1
        loadTicket()
    }

    @IBAction func btAddAction(_ sender: Any) {
        addClicked()
    }
    
    @objc func reloadForm() {
        self.viewDidLoad()
    }
    func loadTicket() {
        let ticketRequest = GetListRequest()
        ticketRequest.clientId = GlobalInfo.sharedInstance.userInfo?.clientId
        ticketRequest.isPagging = true
        ticketRequest.page = self.page
        ServiceApi.shareInstance.postWebService(objc: TicketResponse.self, urlStr: Constant.getAllTicketURL, headers: ServiceApi.shareInstance.getHeader(), completion: { (isSuccess, responseData) in
            if self.page == 1{
                self.ticketList = []
            }
            if isSuccess{
                let ticketResponse = responseData as! TicketResponse
                if ticketResponse.resultCode == "200"{
                    self.handleResult(dataList: ticketResponse.list!)
                }else{
                    GlobalUtil.showToast(context: self, message: "Không thể lấy danh sách thông báo")
                }
            }
            self.tbTicket.reloadData()
            if (self.refresher != nil && self.refresher.isRefreshing) {
                self.refresher.endRefreshing()
            }
        }, parameter: ticketRequest.toDict())
    }
    
    func handleResult(dataList:[TicketItem]) {
        if dataList.count < self.ITEM_LIMIT {
            self.tbTicket.tableFooterView?.frame.size = CGSize(width: (self.tbTicket.tableFooterView?.frame.width)!, height: 0)
            self.tbTicket.tableFooterView?.isHidden = true
            self.isLoadMore = false
        } else if !self.isLoadMore {
            self.tbTicket.tableFooterView?.frame.size = CGSize(width: (self.tbTicket.tableFooterView?.frame.width)!, height: 48)
            self.tbTicket.tableFooterView?.isHidden = false
            self.footerView.activityIndicatorView.startAnimating()
            self.isLoadMore = true
        }
        self.ticketList.append(contentsOf: dataList)
        self.txtSum.text = "Tổng số yêu cầu :\(self.ticketList.count)"
        self.tbTicket.reloadData()
    }
    
    //keyboard
    @objc func dismissKeyBoard(){
        self.view.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        navigationItem.rightBarButtonItems = nil
        navigationItem.leftBarButtonItem = nil
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        navigationItem.rightBarButtonItem =  UIBarButtonItem(customView: addNavigationButton)
//        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchNavigationButton)
        //navigationItem.rightBarButtonItem =  UIBarButtonItem(customView: searchNavigationButton)
        //self.searchController.searchBar.isHidden = true
    }
    func setupResultController() {
        self.resultController.tableView.delegate = self
        self.resultController.tableView.dataSource = self
        self.resultController.tableView.register(nib, forCellReuseIdentifier: "FeedbackItem")

//        resultController.tableView.register(TicketTableViewCell.self, forCellReuseIdentifier: "FeedbackItem")
//        resultController.tableView.register(UINib(nibName: <#T##String#>, bundle: <#T##Bundle?#>), forCellReuseIdentifier: <#T##String#>)
//        self.resultController.tableView.dataSource = self
//        self.resultController.tableView.delegate = self
    }
}
