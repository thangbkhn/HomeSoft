//
//  Constant.swift
//  HomeCare
//
//  Created by Nguyen Van Tho on 3/23/18.
//  Copyright © 2018 Viettel. All rights reserved.
//

import UIKit

class Constant: NSObject {
    
    override init() {
        super.init()
    }
    static let sharedInstance = Constant()
    
    static var dateFormatStr = "yyyy-MM-dd"
    var baseUrl = "http://103.63.109.42:8086"
    
    func getBaserUrl() ->String{
        baseUrl = GlobalUtil.getStringPreference(key: GlobalUtil.hostURL)
        return baseUrl != "" ? baseUrl:"http://103.63.109.42:8086"
    }
    func setBaseUrl(url:String) {
        GlobalUtil.setPreference(value: url, key: GlobalUtil.hostURL)
        self.baseUrl = url
    }
    func getLoginURL() ->String{
        return baseUrl + "/api/Account/Auth"
    }
    func getAllNotificationURL() -> String {
        return baseUrl + "/api/Notification/GetAll"
    }
    func getAllTicketURL() -> String {
        return baseUrl + "/api/Ticket/GetAll"
    }
    
    func modifyTicketURL() ->String {
        return baseUrl + "/api/Ticket/Action/"
    }
    
    func getTicketTypeURL() -> String {
        return baseUrl + "/api/tickettype/getall"
    }
    
    func changePasswordURL() -> String {
        return baseUrl + "/api/account/changepassword"
    }
    
    func getResidentListURL() -> String {
        return baseUrl + "/api/Resident/GetMember/"
    }
    
    func updateResidentURL() -> String {
        return baseUrl + "/api/Resident/Action/"
    }
    func getFeeListURL() -> String {
        return baseUrl + "/api/Fee/GetByRoomId"
    }
    func getNotificationCommentURL() -> String {
        return baseUrl + "/api/Notification/GetComment/"
    }
    func getTicketCommentURL() -> String {
        return baseUrl + "/api/Ticket/GetComment/"
    }
    func postCommentURL() -> String {
        return baseUrl + "/api/Comment/Action/"
    }
    func getFeedbackListUrl() -> String {
        return baseUrl + "/api/Feedback/GetAll"
    }
    func getFeedbackCommentURL() -> String {
        return baseUrl + "/api/Feedback/GetComment/"
    }
    func addFeedback() -> String {
        return baseUrl + "/api/Feedback/Action/"
    }

    static let motobikeId = "5af0626c15414b0d64251706"
    static let carId = "5af0626c15414b0d64251707"
    static let furnitureId = "5af0626c15414b0d64251708"
    static let water_eleciId = "5af0626c15414b0d64251709"
}
