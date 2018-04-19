//
//  BaseObject.swift
//  SaleOne
//
//  Created by Diendh1_laptop_01 on 12/20/17.
//  Copyright © 2017 Diendh1_laptop_01. All rights reserved.
//

import UIKit
import AlamofireJsonToObjects

protocol PropertyNames {
    func propertyNames() -> [String]
}
class BaseObject: EVNetworkingObject,JSONAble {
}
extension PropertyNames{
    func propertyNames() -> [String] {
        return Mirror(reflecting: self).children.flatMap{$0.label}
    }
}
