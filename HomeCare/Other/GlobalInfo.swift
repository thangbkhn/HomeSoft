//
//  GlobalInfo.swift
//  HomeCare
//
//  Created by Nguyen Van Tho on 3/23/18.
//  Copyright © 2018 Viettel. All rights reserved.
//

import UIKit

class GlobalInfo: NSObject {
    override init() {
        super.init()
        let userDefaults = UserDefaults.standard
        if userDefaults.object(forKey: GlobalUtil.userInfor) != nil{
            let decoded  = userDefaults.object(forKey: GlobalUtil.userInfor) as! Data
            userInfo = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? SavedAccount
        }
        groupFCM = GlobalUtil.getListString(key: GlobalUtil.groupFCM)
    }
    static let sharedInstance = GlobalInfo()
    var userInfo : SavedAccount?
    var groupFCM:[String]?
    func setUser(_userInfo:SavedAccount){
        self.userInfo = _userInfo
    }
    func getUserInfo() -> SavedAccount {
        return self.userInfo!
    }
    func setGroupFCM(_groupFCM:[String]) {
        self.groupFCM = _groupFCM
    }
    func getGroupFCM() -> [String] {
        return self.groupFCM!
    }
}
