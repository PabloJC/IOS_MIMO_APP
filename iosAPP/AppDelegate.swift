//
//  AppDelegate.swift
//  iosAPP
//
//  Created by mikel balduciel diaz on 31/1/16.
//  Copyright © 2016 mikel balduciel diaz. All rights reserved.
//

import UIKit
import CoreData
import AFNetworking

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var isConected = true


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let notificationSettings = UIUserNotificationSettings(forTypes: [UIUserNotificationType.Alert, UIUserNotificationType.Badge], categories: nil)
        
        application.registerUserNotificationSettings(notificationSettings)
        application.applicationIconBadgeNumber = 0
        return true
    }
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        application.applicationIconBadgeNumber = 0
        application.cancelAllLocalNotifications()
        self.window?.rootViewController?.view.makeToast(notification.alertBody, duration: 6.0, position: .Center, title: nil, image: UIImage(named: "favoritos.png"), style: nil, completion: nil)
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        AFNetworkReachabilityManager.sharedManager().setReachabilityStatusChangeBlock {
            if($0 == .Unknown || $0 == .NotReachable){
                self.window?.rootViewController?.view.makeToast("No tienes conexión", duration: 2, position: .Top)
                self.isConected = false
            }
            if($0 == .ReachableViaWWAN || $0 == .ReachableViaWiFi){
                self.isConected = true
            }

        
        }
        AFNetworkReachabilityManager.sharedManager().startMonitoring()
    }
    


}

