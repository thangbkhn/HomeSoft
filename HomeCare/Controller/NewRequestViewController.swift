//
//  NewRequestViewController.swift
//  HomeCare
//
//  Created by Nguyen Van Tho on 3/26/18.
//  Copyright © 2018 Viettel. All rights reserved.
//

import UIKit
import DatePickerDialog
import SkyFloatingLabelTextField
import ActionSheetPicker_3_0
import RAMAnimatedTabBarController

protocol CallBack {
    func result(isSuccess:Bool)
}
class NewRequestViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var txtContent: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet var txtType: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet var isLoading: UIActivityIndicatorView!
    
    let dateFormatStr = "dd/MM/yyyy"
    var callBack:CallBack?
    var ticketType : TicketType?
    var ticketTypeList:[TicketType] = []
    var ticketTypeListStr:[String] = []
    var searchController:UISearchController!
    var ticket:TicketItem?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.titleView = self.searchController.searchBar;
        self.searchController.searchBar.isHidden = true
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = .white
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard)))
        let backButton = UIBarButtonItem(title: "Thêm yêu cầu", style: UIBarButtonItemStyle.done, target: nil, action: nil)
        backButton.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: 20)], for: .normal)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        txtContent.delegate = self
        txtType.delegate = self
        txtContent.titleFont = txtContent.titleLabel.font.withSize(10)
        txtType.titleFont = txtContent.titleLabel.font.withSize(10)
        isLoading.isHidden = true
        getTicketType()
        if(ticket != nil){
            txtContent.text = ticket?.desc
            txtType.text = ticket?.ticketTypeName
        }
    }
    //keyboard
    @objc func dismissKeyBoard(){
        self.view.endEditing(true)
    }
    @IBAction func btCancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btSave(_ sender: Any) {
        
        self.isLoading.startAnimating()
        self.isLoading.isHidden = false
        if self.ticket != nil {
            
        }else{
            ticket = TicketItem()
            let userInfo = GlobalInfo.sharedInstance.getUserInfo()
            ticket?.createBy = userInfo.id
            ticket?.roomCode = userInfo.roomCode
            ticket?.ownerName = userInfo.fullName
            ticket?.ownerId = userInfo.id
            ticket?.clientId = userInfo.clientId
            ticket?.createdDatetime = GlobalUtil.getCurrentDate()
            ticket?.ticketTypeId = ticketType?.id
            ticket?.ticketTypeName = ticketType?.name
        }
        ticket?.desc = txtContent.text
        //Call WSV
        self.updateTicket(ticketItem: ticket!)
        
    }
    
    
    @IBAction func txtTypeSelect(_ sender: Any) {
        DispatchQueue.main.asyncAfter(deadline: .now()
            ) {
                let datePicker = ActionSheetStringPicker(title: "Chọn loại yêu cầu", rows: self.ticketTypeListStr, initialSelection: self.ticketTypeListStr.count
                    / 2, doneBlock: { (picker, value, index) in
                        if index != nil{
                            self.txtType.text = index! as? String
                            self.ticketType = self.ticketTypeList[value]
                            self.ticket?.ticketTypeId = self.ticketTypeList[value].id
                            self.ticket?.ticketTypeName = self.ticketTypeList[value].name
                            DispatchQueue.main.asyncAfter(deadline: .now()
                                + 0.4) {
                                    self.view.endEditing(true)
                            }
                        }
                        return
                }, cancel: nil, origin: (sender as AnyObject).superview!?.superview)
                datePicker?.show()
        }
        DispatchQueue.main.asyncAfter(deadline: .now()
            + 0.4) {
                self.view.endEditing(true)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyBoard()
        return true
    }
    func updateTicket(ticketItem:TicketItem) {
        let updateTicketRequest = UpdateRequest()
        updateTicketRequest.clientId = GlobalInfo.sharedInstance.getUserInfo().clientId
        updateTicketRequest.userId = GlobalInfo.sharedInstance.getUserInfo().id
        updateTicketRequest.info = ticketItem.toDict()
        ServiceApi.shareInstance.postWebService(objc: UpdateTicketResponse.self, urlStr: Constant.sharedInstance.modifyTicketURL(), headers: ServiceApi.shareInstance.getHeader(), completion: { (isSuccess, responseData) in
            if isSuccess {
                let result = responseData as! UpdateTicketResponse
                if result.resultCode == "200"{
                    self.callBack?.result(isSuccess: true)
                    self.navigationController?.popViewController(animated: true)
                }else{
                    GlobalUtil.showToast(context: self, message: "Cập nhật yêu cầu bị lỗi")
                }
                
            }else{
                GlobalUtil.showToast(context: self, message: "Không thể gửi yêu cầu")
            }
            self.isLoading.isHidden = true
            
        }, parameter: updateTicketRequest.toDict())
    }
    func getTicketType() {
        let getTicketTypeRequest = GetListRequest()
        getTicketTypeRequest.clientId = GlobalInfo.sharedInstance.getUserInfo().clientId
        ServiceApi.shareInstance.postWebService(objc: GetTicketTypeResponse.self, urlStr: Constant.sharedInstance.getTicketTypeURL(), headers: ServiceApi.shareInstance.getHeader(), completion: { (isSuccess, dataResponse) in
            if isSuccess{
                let result = dataResponse as! GetTicketTypeResponse
                if result.resultCode == "200"{
                    self.ticketTypeList = result.list!
                    for ticketType in self.ticketTypeList{
                        self.ticketTypeListStr.append(ticketType.name!)
                    }
                }else{
                    GlobalUtil.showToast(context: self, message: "Không thể lấy danh sách loại yêu cầu")
                }
            }
        }, parameter: getTicketTypeRequest.toDict())
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
