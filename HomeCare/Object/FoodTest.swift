//
//  FoodTest.swift
//  HomeCare
//
//  Created by Thang BKHN on 4/28/18.
//  Copyright © 2018 Viettel. All rights reserved.
//

import UIKit

class FoodTest: BaseObject {
    var name:String?
    var url:String?
    var imageUrl:String?
    init(_name:String, _url :String, img:String) {
        name = _name
        url = _url
        imageUrl = img
    }
    required init() {
        fatalError("init() has not been implemented")
    }
}
