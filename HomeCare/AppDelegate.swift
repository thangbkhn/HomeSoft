//
//  AppDelegate.swift
//  SaleOne
//
//  Created by Diendh1_laptop_01 on 12/14/17.
//  Copyright © 2017 Diendh1_laptop_01. All rights reserved.
//https://www.youtube.com/watch?v=JCd_7LuFdvw

import UIKit
import Firebase
import FirebaseMessaging
import FirebaseInstanceID
import UserNotifications
import IQKeyboardManagerSwift
//import SQLite

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        // [START set_messaging_delegate]
        Messaging.messaging().delegate = self
        // [END set_messaging_delegate]
        
        // [START register_for_notifications]
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(
                options: authOptions,
                completionHandler: {(success, error)in
                    if error == nil{
                        print("Success Authoziration")
                        center.delegate = self
                    }
            })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        // [END register_for_notifications]
//        let center = UNUserNotificationCenter.current()
//        center.requestAuthorization(options: [.alert, .badge,.sound]) { (success, error) in
//            if error == nil{
//                print("Success Authoziration")
//                center.delegate = self
//            }
//        }
//        
//        application.registerForRemoteNotifications()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshToken(notification:)), name: NSNotification.Name.InstanceIDTokenRefresh, object: nil)
        
        //Keyboard
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Didot", size: 13)!],for: .normal)
        IQKeyboardManager.shared.enable = true
        
        let attrs = [
            NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 19)
        ]
        
        UINavigationBar.appearance().titleTextAttributes = attrs
        
        return true
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        Messaging.messaging().shouldEstablishDirectChannel = false
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        FBHandler()
    }
    @objc func refreshToken(notification:NSNotification) {
        let refreshToken = InstanceID.instanceID().token()!
        print("****\(refreshToken)****")
        Messaging.messaging().subscribe(toTopic: "alert")
        FBHandler()
    }
    func FBHandler() {
        Messaging.messaging().shouldEstablishDirectChannel = true
    }
    
    func addNotificationWithTrigger(trigger: UNNotificationTrigger, item:NotificationItem) {
        let content = UNMutableNotificationContent()
        content.title = "HomeCare"
        content.body = "Thông báo từ hệ thống HomeCare"
        content.sound = UNNotificationSound.init(named: "music.aiff")
        content.badge = NSNumber(integerLiteral: UIApplication.shared.applicationIconBadgeNumber + 1)
        content.categoryIdentifier = "iOSSwift"
        let request = UNNotificationRequest.init(identifier: "FiveSecond", content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            print(error?.localizedDescription ?? "OK")
        }

    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print(userInfo)
        //        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 1, repeats: false)
        //        addNotificationWithTrigger(trigger: trigger)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        //print(userInfo)
        let notificationItem = NotificationItem()
        completionHandler(UIBackgroundFetchResult.newData)
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 1, repeats: false)
        addNotificationWithTrigger(trigger: trigger,item: notificationItem)
    }
    // [END receive_message]
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    override init() {
        //UIFont.overrideInitialize()
    }
}
extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
    }
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        let notificationItem = NotificationItem()
        //completionHandler(UIBackgroundFetchResult.newData)
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 1, repeats: false)
        addNotificationWithTrigger(trigger: trigger,item: notificationItem)
    }
    // [END ios_10_data_message]
}

extension AppDelegate:UNUserNotificationCenterDelegate
{
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
}


struct AppFontName {
    static let regular = "Thonburi"
    static let bold = "Thonburi"
    static let italic = "Thonburi"
}

extension UIFontDescriptor.AttributeName {
    static let nsctFontUIUsage = UIFontDescriptor.AttributeName(rawValue: "NSCTFontUIUsageAttribute")
}

extension UIFont {
    
    @objc class func mySystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.regular, size: size)!
    }
    
    @objc class func myBoldSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.bold, size: size)!
    }
    
    @objc class func myItalicSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.italic, size: size)!
    }
    
    @objc convenience init(myCoder aDecoder: NSCoder) {
        guard
            let fontDescriptor = aDecoder.decodeObject(forKey: "UIFontDescriptor") as? UIFontDescriptor,
            let fontAttribute = fontDescriptor.fontAttributes[.nsctFontUIUsage] as? String else {
                self.init(myCoder: aDecoder)
                return
        }
        var fontName = ""
        switch fontAttribute {
        case "CTFontRegularUsage":
            fontName = AppFontName.regular
        case "CTFontEmphasizedUsage", "CTFontBoldUsage":
            fontName = AppFontName.bold
        case "CTFontObliqueUsage":
            fontName = AppFontName.italic
        default:
            fontName = AppFontName.regular
        }
        self.init(name: fontName, size: fontDescriptor.pointSize)!
    }
    
    class func overrideInitialize() {
        guard self == UIFont.self else { return }
        
        if let systemFontMethod = class_getClassMethod(self, #selector(systemFont(ofSize:))),
            let mySystemFontMethod = class_getClassMethod(self, #selector(mySystemFont(ofSize:))) {
            method_exchangeImplementations(systemFontMethod, mySystemFontMethod)
        }
        
        if let boldSystemFontMethod = class_getClassMethod(self, #selector(boldSystemFont(ofSize:))),
            let myBoldSystemFontMethod = class_getClassMethod(self, #selector(myBoldSystemFont(ofSize:))) {
            method_exchangeImplementations(boldSystemFontMethod, myBoldSystemFontMethod)
        }
        
        if let italicSystemFontMethod = class_getClassMethod(self, #selector(italicSystemFont(ofSize:))),
            let myItalicSystemFontMethod = class_getClassMethod(self, #selector(myItalicSystemFont(ofSize:))) {
            method_exchangeImplementations(italicSystemFontMethod, myItalicSystemFontMethod)
        }
        
        if let initCoderMethod = class_getInstanceMethod(self, #selector(UIFontDescriptor.init(coder:))), // Trick to get over the lack of UIFont.init(coder:))
            let myInitCoderMethod = class_getInstanceMethod(self, #selector(UIFont.init(myCoder:))) {
            method_exchangeImplementations(initCoderMethod, myInitCoderMethod)
        }
    }
}
