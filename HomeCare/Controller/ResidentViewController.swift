//
//  ResidentViewController.swift
//  HomeCare
//
//  Created by Nguyen Van Tho on 3/28/18.
//  Copyright © 2018 Viettel. All rights reserved.
//

import UIKit
import RAMAnimatedTabBarController

class ResidentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UpdateSuccess {

    @IBOutlet var tbResident: UITableView!
    var isLogin = false
    var frame:CGRect!
    var residentList:[Account] = []
    var isSearch = false
    let loginTag = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tbResident.separatorStyle = .none
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard)))
        let tap = UITapGestureRecognizer(target: self, action:#selector(dismissKeyBoard))
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
        if frame == nil {
            frame = self.view.frame
        }
        navigationController?.navigationBar.tintColor = GlobalUtil.getGrayColor()
        let backButton = UIBarButtonItem(title: "Thành viên gia đình", style: UIBarButtonItemStyle.done, target: nil, action: nil)
        backButton.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: 20)], for: .normal)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
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
            loadResident()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return residentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "residentCell", for: indexPath) as! ResidentTableViewCell
        let item = residentList[indexPath.row]
        cell.txtFullName.text = item.fullName != nil ? "Họ tên: \(item.fullName ?? "")" : "Họ tên: "
        if item.birdthDay != nil{
            cell.txtDateOfBirth.text = "Ngày sinh:\(item.birdthDay?.substring(with: 0..<10) ?? "")"
        }else{
            cell.txtDateOfBirth.text = "Ngày sinh:"
        }
        cell.txtGender.text = item.gender != nil ? "Giới tính: \(item.gender ?? "")" : "Giới tính: "
        if(!(item.isOwner == "1" || item.isOwner == "true")){
            cell.imgOwner.isHidden = true
        }else{
            cell.imgOwner.isHidden = false
        }
        cell.onClick = {
            self.callnewResiden(indexPath: indexPath)
        }
        cell.imgProfile.cornerRadius = cell.imgProfile.frame.width / 2
        cell.imgProfile.clipsToBounds = true
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = backgroundView
        cell.selectionStyle = .none
        cell.backgroundColor = .white
        cell.layer.borderColor = GlobalUtil.getSeperateColor().cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 3
        cell.clipsToBounds = true
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.callnewResiden(indexPath: indexPath)
    }
    func callnewResiden(indexPath:IndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "NewResident", bundle:nil)
        let newResidentViewController = storyBoard.instantiateViewController(withIdentifier: "newResident") as! NewResidentViewController
        newResidentViewController.delegate = self
        newResidentViewController.accout = self.residentList[indexPath.row]
        newResidentViewController.isEdit = true
        self.navigationController?.pushViewController(newResidentViewController, animated: true)
    }
    @IBAction func btNewMember(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "NewResident", bundle:nil)
        let newResidentViewController = storyBoard.instantiateViewController(withIdentifier: "newResident") as! NewResidentViewController
        newResidentViewController.delegate = self
        newResidentViewController.isEdit = false
        self.navigationController?.pushViewController(newResidentViewController, animated: true)
    }
    
    func loadResident() {
        self.residentList = []
        let request = ResidentListRequest()
        request.clientId = GlobalInfo.sharedInstance.getUserInfo().clientId
        request.roomId = GlobalInfo.sharedInstance.getUserInfo().roomId
        ServiceApi.shareInstance.postWebService(objc: ResidentListResponse.self, urlStr: Constant.sharedInstance.getResidentListURL(), headers: ServiceApi.shareInstance.getHeader(), completion: { (isSuccess, dataResponse) in
            if isSuccess{
                let result = dataResponse as! ResidentListResponse
                if result.resultCode == "200"{
                    self.residentList = result.list!
                }else{
                    GlobalUtil.showToast(context: self, message: "Không thể lấy danh sách thành viên gia đình")
                }
            }
            self.tbResident.reloadData()
        }, parameter: request.toDict())
    }
    //keyboard
    @objc func dismissKeyBoard(){
        self.view.endEditing(true)
    }
    func result(isSuccess: Bool) {
        if isSuccess{
            loadResident()
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
