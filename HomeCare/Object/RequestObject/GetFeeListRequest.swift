//
//  GetFeeListRequest.swift
//  HomeCare
//
//  Created by Nguyen Van Tho on 4/2/18.
//  Copyright © 2018 Viettel. All rights reserved.
//

import UIKit

class GetFeeListRequest: BaseRequest {
    var clientId:String?
    var roomCode:String?
    var month:String?
    var year:String?
    var isPagging:Bool?
    var page:String?
}
