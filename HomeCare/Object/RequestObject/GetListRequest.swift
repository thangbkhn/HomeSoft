//
//  NotificationRequest.swift
//  HomeCare
//
//  Created by Nguyen Van Tho on 3/23/18.
//  Copyright © 2018 Viettel. All rights reserved.
//

import UIKit

class GetListRequest: BaseRequest {
    var clientId:String?
    var isPagging:Bool?
    var page:Int?
    var roomCode:String?
}
