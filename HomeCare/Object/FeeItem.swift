//
//  FeeItem.swift
//  HomeCare
//
//  Created by Nguyen Van Tho on 4/2/18.
//  Copyright © 2018 Viettel. All rights reserved.
//

import UIKit

class FeeItem: BaseObject {
    var roomCode :  String?
    var roomName :  String?
    var buildingCode :  String?
    var buildingName :  String?
    var numberElectric :  String?
    var paymentElectric :  Double = 0.0
    var lastNumberElectric :  String?
    var numberWater :  String?
    var lastNumberWater :  String?
    var paymentWater :  Double = 0.0
    var paymentParking :  Double = 0.0
    var paymentService :  Double = 0.0
    var paymentOther :  Double = 0.0
    var desc :  String?
    var oldDebt :  String?
    var total :  Double = 0.0
    var month :  Int = 1
    var year :  String?
    var status :  String?
    var sentStatus :  String?
    var clientId :  String?
    var id :  String?
    var active :  String?
    var createdDatetime :  String?
    var createBy :  String?
    var updatedBy :  String?
    var updatedDatetime :  String?
}
