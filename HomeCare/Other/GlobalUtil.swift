//
//  GlobalUtil.swift
//  HomeCare
//
//  Created by Nguyen Van Tho on 3/19/18.
//  Copyright © 2018 Viettel. All rights reserved.
//

import UIKit
import SystemConfiguration
class GlobalUtil: NSObject {
    static var isLogin = "isLoginKey"
    static var userKey = "userName"
    static var userInfor = "userInfo"
    static var tokenFCM = "tokenFCM"
    static var groupFCM = "groupFCM"
    static let keyLanguage = "keyLanguage"
    static let hostURL = "hostURL"
    static func getMainColor() -> UIColor{
        //return UIColor.rbg(red: 67, green: 142, blue: 185)
        //return UIColor.rbg(red: 102, green: 117, blue: 133)
        return UIColor.rbg(red: 0, green: 102, blue: 178)
    }
    static func getSeperateColor() -> UIColor{
        return UIColor.rbg(red: 235, green: 235, blue: 241)
    }
    static func getNotPayednColor() -> UIColor{
        return UIColor.rbg(red: 255, green: 162, blue: 0)
    }
    
    static func getPayedColor() -> UIColor{
        return UIColor.rbg(red: 126, green: 176, blue: 26)
    }
    
    static func getGrayColor() -> UIColor{
        return UIColor.rbg(red: 92, green: 94, blue: 102)
    }
    static func showToast(context:UIViewController, message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: 0 + 10, y: context.view.frame.size.height-100, width: context.view.frame.width - 20 , height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        context.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    static func formatMoney(value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: Locale.current.identifier)
        let result = formatter.string(from: value as NSNumber)!
        return result
    }
    static func getBoolPreference(key:String) ->Bool{
        var value = false
        let preference = UserDefaults.standard
        if preference.object(forKey: key) != nil{
            value = preference.bool(forKey: key)
        }
        return value
        //
    }
    
    static func setPreference(value:Any, key:String){
        let preference = UserDefaults.standard
        preference.set(value, forKey: key)
        preference.synchronize()
    }
    
    static func getStringPreference(key:String) ->String{
        var value = ""
        let preference = UserDefaults.standard
        if preference.object(forKey: key) != nil{
            value = preference.string(forKey: key)!
        }
        return value
    }
    static func getListString(key:String) -> [String]{
        var value : [String] = []
        let preference = UserDefaults.standard
        if preference.object(forKey: key) != nil{
            value = preference.array(forKey: key) as! [String]
        }
        return value
    }
    static func saveObject(object:NSObject){
        let userDefaults = UserDefaults.standard
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: object)
        userDefaults.set(encodedData, forKey: GlobalUtil.userInfor)
        userDefaults.synchronize()
        NotificationCenter.default.post(name: NotificationConstant.loginNotification, object: nil)
    }
    static func getYearList()->[String]{
        var result:[String] = []
        let date = Date()
        let calendar = Calendar.current
        let component = calendar.dateComponents([.year], from: date)
        let currentYear = component.year
        for i in currentYear! - 10  ... currentYear! + 10{
            result.append("\(i)")
        }
        return result
    }
    static func getCurrentDate() -> String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
    static func startAnimate(sender:UIButton,action:@escaping ()->()){
        sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        UIView.animate(withDuration: 0.7,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIViewAnimationOptions.allowUserInteraction,
                       animations: {
                        sender.transform = CGAffineTransform.identity
        },
                       completion: { Void in(action())  }
        )
    }
    
    static func showInfoDialog(context:UIViewController,title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Đóng", style: .default, handler: nil))
        context.present(alert,animated: true)
    }
    static func getUIImageFromUrl(url:String) ->UIImage!{
        let url = URL(string: url)
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        if(data == nil){
            return nil
        }
        let result =  UIImage(data: data!)
        if result != nil{
            return result!
        }
        return nil
    }
    static func getCurrentFolder()->URL{
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    static func downLoadFile(fileName:String, url:String)  -> Bool{
        let fileURL = GlobalUtil.getCurrentFolder().appendingPathComponent("\(fileName)")
        let url = URL(string: url)
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        if(data == nil){
            return false
        }
        let result =  UIImage(data: data!)
        if result == nil{
            return false
        }
        do{
            if let pngImageData = UIImagePNGRepresentation(result!) {
                try pngImageData.write(to: fileURL, options: .atomic)
            }
        }catch {
            return false
        }
        return true
    }
    static func getImage(fileName:String)->UIImage{
        let documentsURL = GlobalUtil.getCurrentFolder()
        let filePath = documentsURL.appendingPathComponent("\(fileName)").path
        if FileManager.default.fileExists(atPath: filePath) {
            return UIImage(contentsOfFile: filePath)!
        }
        return UIImage(named: "imgAvatar")!
    }
    static func getAvatarImg()->UIImage!{
        let filePath = GlobalUtil.getCurrentFolder().appendingPathComponent("\(Constant.avatarPath)").path
        if FileManager.default.fileExists(atPath: filePath) {
            return GlobalUtil.getImage(fileName: Constant.avatarPath)
        }else{
            if GlobalUtil.downLoadFile(fileName: Constant.avatarPath, url: GlobalInfo.sharedInstance.getUserInfo().imageUrl!.replacingOccurrences(of: "~", with: Constant.sharedInstance.downFileUrl)){
                return GlobalUtil.getImage(fileName: Constant.avatarPath)
            }else{
                return UIImage(named: "imgAvatar")
            }
        }
    }
    static func deleteFile(fileName:String){
        let fileManager = FileManager.default
        let filePath = GlobalUtil.getCurrentFolder().appendingPathComponent("\(fileName)").path
        if fileManager.fileExists(atPath: filePath) {
            do{
               try fileManager.removeItem(atPath: filePath)
            }catch let error as NSError{
                print(error)
            }
        }
    }
    static public func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        if flags.isEmpty {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
}
extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    var isEmail:Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}
extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
//    func dropShadow(offsetX: CGFloat, offsetY: CGFloat, color: UIColor, opacity: Float, radius: CGFloat, scale: Bool = true) {
//        layer.masksToBounds = false
//        layer.shadowOffset = CGSize(width: offsetX, height: offsetY)
//        layer.shadowColor = color.cgColor
//        layer.shadowOpacity = opacity
//        layer.shadowRadius = radius
//        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
//        layer.shouldRasterize = true
//        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
//    }
}
extension UITabBar {
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 55 // adjust your size here
        return sizeThatFits
    }
}
extension UIImageView {
    func changeImageColor( color:UIColor) -> UIImage
    {
        image = image!.withRenderingMode(.alwaysTemplate)
        tintColor = color
        return image!
    }
}
extension String {
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}
