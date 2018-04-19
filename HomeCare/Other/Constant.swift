//
//  Constant.swift
//  HomeCare
//
//  Created by Nguyen Van Tho on 3/23/18.
//  Copyright © 2018 Viettel. All rights reserved.
//

import UIKit

class Constant: NSObject {
    static let dateFormatStr = "yyyy-MM-dd"
    static let baseUrl = "http://103.63.109.42:8086"
    static let getAllNotificationURL = baseUrl + "/api/Notification/GetAll"
    static let getAllTicketURL = baseUrl + "/api/Ticket/GetAll"
    static let modifyTicket = baseUrl + "/api/Ticket/Action/"
    static let getTicketTypeURL = baseUrl + "/api/tickettype/getall"
    static let changePasswordURL = baseUrl + "/api/account/changepassword"
    static let getResidentList = baseUrl + "/api/Resident/GetMember/"
    static let updateResidentURL = baseUrl + "/api/Resident/Action/"
    static let getFeeListURL = baseUrl + "/api/Fee/GetByRoomId"
}
