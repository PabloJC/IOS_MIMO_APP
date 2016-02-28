//
//  AppDelegate.swift
//  iosAPP
//
//  Created by mikel balduciel diaz on 31/1/16.
//  Copyright © 2016 mikel balduciel diaz. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


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
    


}

