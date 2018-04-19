//
//  SavedAccount.swift
//  HomeCare
//
//  Created by Nguyen Van Tho on 3/23/18.
//  Copyright © 2018 Viettel. All rights reserved.
//

import UIKit

class SavedAccount: NSObject, NSCoding {
    var fullName:String?
    var birdthDay:String?
    var mobile:String?
    var email:String?
    var identityNo:String?
    var gender:String?
    var roomId:String?
    var roomCode:String?
    var ownerId :String?
    var roomName:String?
    var buildingId:String?
    var buildingCode:String?
    var buildingName:String?
    var imageUrl:String?
    var isOwner:String?
    var clientId:String?
    var id:String?
    var active:String?
    var createdDatetime:String?
    var createBy:String?
    var updatedBy:String?
    var updatedDatetime:String?
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(fullName, forKey: "fullName")
        aCoder.encode(birdthDay, forKey: "birdthDay")
        aCoder.encode(mobile, forKey: "mobile")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(identityNo, forKey: "identityNo")
        aCoder.encode(gender, forKey: "gender")
        aCoder.encode(roomId, forKey: "roomId")
        aCoder.encode(roomCode, forKey: "roomCode")
        aCoder.encode(ownerId, forKey: "ownerId")
        aCoder.encode(roomName, forKey: "roomName")
        aCoder.encode(buildingId, forKey: "buildingId")
        aCoder.encode(buildingCode, forKey: "buildingCode")
        aCoder.encode(buildingName, forKey: "buildingName")
        aCoder.encode(imageUrl, forKey: "imageUrl")
        aCoder.encode(isOwner, forKey: "isOwner")
        aCoder.encode(clientId, forKey: "clientId")
        aCoder.encode(id, forKey: "id")
        aCoder.encode(active, forKey: "active")
        aCoder.encode(createdDatetime, forKey: "createdDatetime")
        aCoder.encode(createBy, forKey: "createBy")
        aCoder.encode(updatedBy, forKey: "updatedBy")
        aCoder.encode(updatedDatetime, forKey: "updatedDatetime")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let fullName = aDecoder.decodeObject(forKey: "fullName") as? String
        let birdthDay = aDecoder.decodeObject(forKey: "birdthDay") as? String
        let mobile = aDecoder.decodeObject(forKey: "mobile") as? String
        let email = aDecoder.decodeObject(forKey: "email") as? String
        let identityNo = aDecoder.decodeObject(forKey: "identityNo") as? String
        let gender = aDecoder.decodeObject(forKey: "gender") as? String
        let roomId = aDecoder.decodeObject(forKey: "roomId") as? String
        let roomCode = aDecoder.decodeObject(forKey: "roomCode") as? String
        let ownerId = aDecoder.decodeObject(forKey: "ownerId") as? String
        let roomName = aDecoder.decodeObject(forKey: "roomName") as? String
        let buildingId = aDecoder.decodeObject(forKey: "buildingId") as? String
        let buildingCode = aDecoder.decodeObject(forKey: "buildingCode") as? String
        let buildingName = aDecoder.decodeObject(forKey: "buildingName") as? String
        let imageUrl = aDecoder.decodeObject(forKey: "imageUrl") as? String
        let isOwner = aDecoder.decodeObject(forKey: "isOwner") as? String
        let clientId = aDecoder.decodeObject(forKey: "clientId") as? String
        let id = aDecoder.decodeObject(forKey: "id") as? String
        let active = aDecoder.decodeObject(forKey: "active") as? String
        let createdDatetime = aDecoder.decodeObject(forKey: "createdDatetime") as? String
        let createBy = aDecoder.decodeObject(forKey: "createBy") as? String
        let updatedBy = aDecoder.decodeObject(forKey: "updatedBy") as? String
        let updatedDatetime = aDecoder.decodeObject(forKey: "updatedDatetime") as? String
        
        self.init(fullName: fullName, birdthDay: birdthDay, mobile: mobile, email: email, identityNo: identityNo, gender: gender, roomId: roomId, roomCode: roomCode,ownerId:ownerId, roomName: roomName, buildingId: buildingId, buildingCode: buildingCode, buildingName: buildingName, imageUrl: imageUrl, isOwner: isOwner, clientId: clientId, id: id, active: active, createdDatetime: createdDatetime, createBy: createBy, updatedBy: updatedBy, updatedDatetime: updatedDatetime)
    }
    
    init(account : Account){
        self.fullName = account.fullName
        self.birdthDay = account.birdthDay
        self.mobile = account.mobile
        self.email = account.email
        self.identityNo = account.identityNo
        self.gender = account.gender
        self.roomId = account.roomId
        self.roomCode = account.roomCode
        self.ownerId = account.ownerId
        self.roomName = account.roomName
        self.buildingId = account.buildingId
        self.buildingCode = account.buildingCode
        self.buildingName = account.buildingName
        self.imageUrl = account.imageUrl
        self.isOwner = account.isOwner
        self.clientId = account.clientId
        self.id = account.id
        self.active = account.active
        self.createdDatetime = account.createdDatetime
        self.createBy = account.createBy
        self.updatedBy = account.updatedBy
        self.updatedDatetime = account.updatedDatetime
    }

    init(fullName:String?,birdthDay:String?,mobile:String? ,email:String? ,identityNo:String? ,gender:String? ,roomId:String? ,roomCode:String?, ownerId:String?  ,roomName:String?,buildingId:String? ,buildingCode:String?,buildingName:String?,imageUrl:String?,isOwner:String?,clientId:String?,id:String?,active:String?,createdDatetime:String?,createBy:String?,updatedBy:String?,updatedDatetime:String?){
        self.fullName = fullName
        self.birdthDay = birdthDay
        self.mobile = mobile
        self.email = email
        self.identityNo = identityNo
        self.gender = gender
        self.roomId = roomId
        self.roomCode = roomCode
        self.ownerId = ownerId
        self.roomName = roomName
        self.buildingId = buildingId
        self.buildingCode = buildingCode
        self.buildingName = buildingName
        self.imageUrl = imageUrl
        self.isOwner = isOwner
        self.clientId = clientId
        self.id = id
        self.active = active
        self.createdDatetime = createdDatetime
        self.createBy = createBy
        self.updatedBy = updatedBy
        self.updatedDatetime = updatedDatetime
    }
    
}
