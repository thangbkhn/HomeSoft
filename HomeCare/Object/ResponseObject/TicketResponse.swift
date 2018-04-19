//
//  TicketResponse.swift
//  HomeCare
//
//  Created by Nguyen Van Tho on 3/23/18.
//  Copyright © 2018 Viettel. All rights reserved.
//

import UIKit

class TicketResponse: BaseObject {
    var errorMes:String?
    var resultCode:String?
    var status:String?
    var list:[TicketItem]?
}
