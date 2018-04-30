//
//  AppliancesTest.swift
//  HomeCare
//
//  Created by Thang BKHN on 4/29/18.
//  Copyright © 2018 Viettel. All rights reserved.
//

import UIKit

class AppliancesTest: BaseObject {
    var imgUrl:String?
    var name:String?
    init(_imgUrl:String, _name :String) {
        name = _name
        imgUrl = _imgUrl
    }
    required init() {
        fatalError("init() has not been implemented")
    }
}
