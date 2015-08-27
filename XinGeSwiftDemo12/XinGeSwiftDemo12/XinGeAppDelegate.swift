//
//  XinGeAppDelegate.swift
//  XinGeSwiftDemo12
//
//  Created by 张青明 on 15/8/27.
//  Copyright (c) 2015年 极客栈. All rights reserved.
//

import UIKit


let IPHONE_8:Int32 = 80000


/// ACCESS ID
let kXinGeAppId: UInt32 = 填写ACCESS ID,例如:1234567890

/// ACCESS KEY
let kXinGeAppKey:String! = 填写ACCESS KEY,例如:"AB345F7H89012"

class XinGeAppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    func registerPushForIOS8()
    {
        //Types
        var types = UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound
        
        //Actions
        var acceptAction = UIMutableUserNotificationAction()
        
        acceptAction.identifier = "ACCEPT_IDENTIFIER"
        acceptAction.title      = "Accept"
        
        acceptAction.activationMode = UIUserNotificationActivationMode.Foreground
        
        acceptAction.destructive = false
        acceptAction.authenticationRequired = false
        
        
        //Categories
        var inviteCategory = UIMutableUserNotificationCategory()
        inviteCategory.identifier = "INVITE_CATEGORY";
        
        inviteCategory.setActions([acceptAction], forContext: UIUserNotificationActionContext.Default)
        inviteCategory.setActions([acceptAction], forContext: UIUserNotificationActionContext.Minimal)
        
        var categories = NSSet(objects: inviteCategory)
        
        var mySettings:UIUserNotificationSettings = UIUserNotificationSettings(forTypes: types, categories: categories as Set<NSObject>)
        
        UIApplication.sharedApplication().registerUserNotificationSettings(mySettings)
        
    }
    
    func registerPush()
    {
        UIApplication.sharedApplication().registerForRemoteNotificationTypes(UIRemoteNotificationType.Alert|UIRemoteNotificationType.Badge|UIRemoteNotificationType.Sound)
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // 注册
        XGPush.startApp(kXinGeAppId, appKey: kXinGeAppKey)
        
        XGPush.initForReregister { () -> Void in
            //如果变成需要注册状态
            if !XGPush.isUnRegisterStatus()
            {
                
                if __IPHONE_OS_VERSION_MAX_ALLOWED >= IPHONE_8
                {
                    
                    if (UIDevice.currentDevice().systemVersion.compare("8", options:.NumericSearch) != NSComparisonResult.OrderedAscending)
                    {
                        self.registerPushForIOS8()
                    }
                    else
                    {
                        self.registerPush()
                    }
                    
                }
                else
                {
                    //iOS8之前注册push方法
                    //注册Push服务，注册后才能收到推送
                    self.registerPush()
                }
                
                
            }
        }
        
//        XGPush.clearLocalNotifications()
        
        
        XGPush.handleLaunching(launchOptions, successCallback: { () -> Void in
            print("[XGPush]handleLaunching's successBlock\n\n")
            }) { () -> Void in
                print("[XGPush]handleLaunching's errorBlock\n\n")
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        return true
    }
    
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        XGPush.localNotificationAtFrontEnd(notification, userInfoKey: "clockID", userInfoValue: "myid")
        
        XGPush.delLocalNotification(notification)
    }
    
    
    @availability(iOS, introduced=8.0)
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        UIApplication.sharedApplication().registerForRemoteNotifications()
    }
    @availability(iOS, introduced=8.0)
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        
        if let ident = identifier
        {
            if ident == "ACCEPT_IDENTIFIER"
            {
                print("ACCEPT_IDENTIFIER is clicked\n\n")
            }
        }
        
        completionHandler()
    }
    
    
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        //注册设备
        //        XGSetting.getInstance().Channel = ""//= "appstore"
        //        XGSetting.getInstance().GameServer = "家万户"
        
        var deviceTokenStr = XGPush.registerDevice(deviceToken, successCallback: { () -> Void in
            print("[XGPush]register successBlock\n\n")
            }) { () -> Void in
                print("[XGPush]register errorBlock\n\n")
        }
        
        print("deviceTokenStr:\(deviceTokenStr)\n\n")
    }
    
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("didFailToRegisterForRemoteNotifications error:\(error.localizedDescription)\n\n")
    }
    
    // iOS 3 以上
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
//        UIAlertView(title: "3-", message: "didReceive", delegate: self, cancelButtonTitle: "OK").show()
        var apsDictionary = userInfo["aps"] as? NSDictionary
        if let apsDict = apsDictionary
        {
            var alertView = UIAlertView(title: "您有新的消息", message: apsDict["alert"] as? String, delegate: self, cancelButtonTitle: "确定")
            alertView.show()
        }
        
        // 清空通知栏通知
        XGPush.clearLocalNotifications()
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        
        XGPush.handleReceiveNotification(userInfo)
    }
    
    // iOS 7 以上
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void)
    {
//        UIAlertView(title: "7-", message: "didReceive", delegate: self, cancelButtonTitle: "OK").show()
        var apsDictionary = userInfo["aps"] as? NSDictionary
        if let apsDict = apsDictionary
        {
            var alertView = UIAlertView(title: "您有新的消息", message: apsDict["alert"] as? String, delegate: self, cancelButtonTitle: "确定")
            alertView.show()
        }
        // 清空通知栏通知
        XGPush.clearLocalNotifications()
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        
        XGPush.handleReceiveNotification(userInfo)
    }
    
    
    
}