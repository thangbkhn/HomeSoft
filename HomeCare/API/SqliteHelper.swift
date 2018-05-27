//
//  SqliteHelper.swift
//  SaleOne
//
//  Created by Nguyen Van Thang on 1/3/18.
//  Copyright © 2018 Diendh1_laptop_01. All rights reserved.
//

import UIKit
import SQLite

class SqliteHelper: NSObject {

    static let DESC = 0
    static let ASC = 1
    override init() {
        super.init()
        getPath()
        print("Path database : \(dataPath)")
        do{
            let file = FileManager.default
            if (!file.fileExists(atPath: dataPath as String)) {
                db = try Connection(dataPath as String)
                //Start: Tao bang
                createTable(tableName: Constant.NotificationTable, columns: NotificationItem().propertyNames())
                //End:Tao bang
            }else{
                db = try Connection(dataPath as String)
            }
            
        }catch let error{
            print(error)
        }
    }
    static let shareInstance = SqliteHelper()
    var dataPath = NSString()
    var db:Connection? = nil
    func getPath() {
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir = NSString(string: dirPath[0])
        dataPath = docsDir.appendingPathComponent(Constant.databaseFileName) as NSString
    }
    func createTable(tableName:String, columns:[String]) {
        do {
            let table = Table(tableName)
            let createTable = table.create{t in for columnName in columns{
                    t.column(Expression<String?>(columnName))
                }}
            try db?.run(createTable)
        }catch let error{
            print(error)
        }
    }
    func createTableWithId(tableName:String,columns:[String]) {
        do {
            let table = Table(tableName)
            let createTable = table.create{t in for var i in 0..<columns.count {
                if columns[i] == "idItem" {
                    t.column(Expression<Int64>(columns[i]), primaryKey: true)
                }else{
                    t.column(Expression<String?>(columns[i]))
                }
                }}
            try db?.run(createTable)
        }catch let error{
            print(error)
        }
    }
    func deleteAllDataInTable(tableName:String) {
        let table = Table(tableName)
        do{
            try db?.run(table.delete())
        }catch let error{
            print(error)
        }
    }
    func insertOrUpdateItem<T:BaseObject>(table:Table, item: NSObject, keyId:String, classtype:inout T) -> Bool {
        do{
            let data = item as! BaseObject
            let value = data.value(forKeyPath: keyId) as! String
            let oldItem = table.filter(Expression<String?>(keyId) == value)
            let count = try db?.scalar(oldItem.count)
            var dataInsert :[Setter] = []
            for column in T().propertyNames(){
                dataInsert.append(Expression<String?>(column) <- data.value(forKeyPath: column) as? String)
            }
            if count! > 0{
                try db?.run(oldItem.update(dataInsert))
            }else{
                try db?.run(table.insert(dataInsert))
            }
            return true
        }catch let error{
            print(error)
            return false
        }
    }
    func insertOrUpdateItemDB<T:NSObject>(tableName:String, item: NSObject, keyId:String, classtype:inout T) -> Bool {
        do{
            let table = Table(tableName)
            let data = item
            let value = data.value(forKeyPath: keyId) as! String
            let oldItem = table.filter(Expression<String?>(keyId) == value)
            let count = try db?.scalar(oldItem.count)
            var dataInsert :[Setter] = []
            for column in T().propertyNames(){
                dataInsert.append(Expression<String?>(column) <- data.value(forKeyPath: column) as? String)
            }
            if count! > 0{
                try db?.run(oldItem.update(dataInsert))
            }else{
                try db?.run(table.insert(dataInsert))
            }
            return true
        }catch let error{
            print(error)
            return false
        }
    }
    func insertOrUpdateItem<T:BaseObject>(tableName:String, item: NSObject, keyId:String, classtype:inout T) -> Bool {
        do{
            let table = Table(tableName)
            let data = item as! BaseObject
            let value = data.value(forKeyPath: keyId) as! String
            let oldItem = table.filter(Expression<String?>(keyId) == value)
            let count = try db?.scalar(oldItem.count)
            var dataInsert :[Setter] = []
            for column in T().propertyNames(){
                dataInsert.append(Expression<String?>(column) <- data.value(forKeyPath: column) as? String)
            }
            if count! > 0{
                try db?.run(oldItem.update(dataInsert))
            }else{
                try db?.run(table.insert(dataInsert))
            }
            return true
        }catch let error{
            print(error)
            return false
        }
    }
    func insertOrUpdateList<T:BaseObject>(tableName:String, dataList: [NSObject], keyId:String, classtype:inout T) {
        for data in dataList{
            let table = Table(tableName)
            _ = insertOrUpdateItem(table: table, item: data, keyId: keyId, classtype: &classtype)
        }
    }
    
    func getDataList<T:BaseObject>(tableName:String, keyIdList:[String], keyValueList:[String], classtype:inout T , orderColumn:[String], orderType:[Int]) -> [T] {
        var result:[T] = []
        do{
            var table = Table(tableName)
            for i in 0..<keyIdList.count{
                
                table = table.filter(Expression<String?>(keyIdList[i]) == keyValueList[i])
            }
            for i in 0 ..< orderType.count{
                let column = Expression<String?>(orderColumn[i])
                if orderType[i] == SqliteHelper.ASC{
                    table = table.order(column.asc)
                }else if orderType[i] == SqliteHelper.DESC{
                    table = table.order(column.desc)
                }
            }
            for row in (try db?.prepare(table))!{
                result.append(convertRowToObjec(row: row, classtype: &classtype))
            }
        }catch let error{
            print(error)
        }
        return result
    }
    
    func getDataList<T:BaseObject>(tableName:String, keyIdList:[String], keyValueList:[String], classtype:inout T) -> [T] {
        var result:[T] = []
        do{
            var table = Table(tableName)
            for i in 0..<keyIdList.count{
                table = table.filter(Expression<String?>(keyIdList[i]) == keyValueList[i])
            }
            for row in (try db?.prepare(table))!{
                result.append(convertRowToObjec(row: row, classtype: &classtype))
            }
        }catch let error{
            print(error)
        }
        return result
    }
    
    func getCountRow(tableName:String,keyIdList:[String], keyValueList:[String]) -> Int {
        do{
            var table = Table(tableName)
            for i in 0..<keyIdList.count{
                table = table.filter(Expression<String?>(keyIdList[i]) == keyValueList[i])
            }
            return (try db?.scalar(table.count))!
        }catch let error{
            print(error)
            return 0
        }
    }
    func convertRowToObjec<T:BaseObject>(row:Row, classtype:inout T) -> T {
        let item = T()
        for column in item.propertyNames(){
            if(column == "idItem"){
                let data = row[Expression<Int64?>(column)]
                item.setValue(data, forKey: column)
            }else{
                let data = row[Expression<String?>(column)]
                item.setValue(data, forKey: column)
            }
        }
        return item
    }
    func deleteItem(tableName:String, keyID:String, keyValue:String) -> Bool {
        do{
            let table = Table(tableName)
            if keyID == ""{
                try db?.run(table.delete())
            }else{
                let item = table.filter(Expression<String?>(keyID) == keyValue)
                try db?.run(item.delete())
            }
            return true
        }catch let error{
            print(error)
            return false
        }
    }
    func insertItemDBIndex<T:BaseObject>(tableName:String, data: BaseObject, keyId:String, classtype:inout T, excludeProperty:[String]) -> Bool {
        do{
            let table = Table(tableName)
            let value = data.value(forKeyPath: keyId) as? String
            var dataInsert :[Setter] = []
            for column in T().propertyNames(){
                if(!excludeProperty.contains(column)){
                    dataInsert.append(Expression<String?>(column) <- data.value(forKeyPath: column) as? String)
                }
            }
            if (value != nil && value != ""){
                let oldItem = table.filter(Expression<String?>(keyId) == value)
                let count = try db?.scalar(oldItem.count)
                
                if count! > 0{
                    try db?.run(oldItem.update(dataInsert))
                }else{
                    try db?.run(table.insert(dataInsert))
                }
            }
            else{
                try db?.run(table.insert(dataInsert))
            }
            return true
        }catch let error{
            print(error)
            return false
        }
    }
    
    func databaseIsExist() -> Bool {
        getPath()
        let file = FileManager.default
        if (file.fileExists(atPath: dataPath as String)) {
            return true
        }else{
            return false
        }
    }
    
    func isTableExists(tableName: String) -> Bool{
        do {
           let table = try self.db!.scalar(
                "SELECT EXISTS (SELECT * FROM sqlite_master WHERE type = 'table' AND name = ?)",
                tableName
                ) as! Int64 > 0
            return table
        }catch {
            print(error)
        }
        return false
    }
}
extension NSObject : PropertyNames{
    
}
