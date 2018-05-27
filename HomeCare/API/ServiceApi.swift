//
//  ServiceApi.swift
//  Template
//
//  Created by Nguyen Van Tho on 3/14/18.
//  Copyright © 2018 Viettel. All rights reserved.
//

import UIKit
import Alamofire
class ServiceApi: NSObject {
    override init() {
        super.init()
    }
    static let shareInstance = ServiceApi()
    let baseUrl = "http://pccc.safeone.vn/mobile-service"
    var token: String?
    
    func printError(error: NSError) {
        print("\n\n===========Error===========")
        print("Error Code: \(error._code)")
        print("Error Messsage: \(error.localizedDescription)")
        //        if let data = response.data, let str = String(data: data, encoding: String.Encoding.utf8){
        //            print("Server Error: " + str)
        //        }
        debugPrint(error as Any)
        print("===========================\n\n")
    }
    
    func getHeader() -> HTTPHeaders {
        let header:HTTPHeaders = ["Content-Type":"application/json","Accept-Charset":"UTF-8","Authorization":token ?? ""]
        return header
    }
    
    func getListWebService<T:BaseObject>(objc:T.Type,urlStr:String, headers:HTTPHeaders, completion:@escaping (Bool,[BaseObject]?)->()){
        Alamofire.request(urlStr, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseArray { (responseData:DataResponse<[T]>) in
            if let statusCode = responseData.response?.statusCode{
                let dataList = responseData.result.value
                switch(statusCode){
                case 200:
                    completion(true,dataList)
                    break
                default:
                    completion(false,nil)
                    break
                }
            }else{
                completion(false,nil)
            }
        }
    }
    func postWebService<T:BaseObject>(objc:T.Type,urlStr:String, headers:HTTPHeaders, completion:@escaping (Bool,BaseObject?)->(), parameter:[String:Any]) {
        
        Alamofire.request(urlStr, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: headers).responseObject { (responseData:DataResponse<T>) in
            if let statusCode = responseData.response?.statusCode{
                let data = responseData.result.value!
                switch(statusCode){
                case 200:
                    completion(true, data)
                    break
                default:
                    completion(false,nil)
                    break
                }
            }else{
                completion(false,nil)
                
            }
        }
    }
    func setToken(_token:String)  {
        token = "bearer \(_token)"
    }
}

