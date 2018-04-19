//
//  JSONAble.swift
//  SaleOne
//
//  Created by Nguyen Van Tho on 12/27/17.
//  Copyright © 2017 Diendh1_laptop_01. All rights reserved.
//

protocol JSONAble {}

extension JSONAble {
    func toDict() -> [String:Any] {
        var dict = [String:Any]()
        let otherSelf = Mirror(reflecting: self)
        for child in otherSelf.children {
            if let key = child.label {
                dict[key] = child.value
            }
        }
        return dict
    }
}
