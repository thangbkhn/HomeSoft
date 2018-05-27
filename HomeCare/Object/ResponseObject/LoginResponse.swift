//
//  LoginResponse.swift
//  HomeCare
//
//  Created by Nguyen Van Tho on 3/21/18.
//  Copyright © 2018 Viettel. All rights reserved.
//

import UIKit

class LoginResponse: BaseObject {
    var errorMes: String?
    var resultCode: String?
    var status: String?
    var accountInfo:Account?
    var groupFCM:[FCMObject]?
    var token:String?
}
