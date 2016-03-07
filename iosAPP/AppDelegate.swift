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
        
        let notificationSettings = UIUserNotificationSettings(forTypes: [UIUserNotificationType.Alert, UIUserNotificationType.Badge,.Sound], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
        return true
    }
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        let id = notification.userInfo!["uid"]
        let noti = Notification()
        noti.notificationId = Int64(id! as! Int)
        do{
           let notificationSearch = try NotificationsDataHelper.find(noti.notificationId)
            if notificationSearch != nil {
                try NotificationsDataHelper.delete(noti)
            }
        } catch _ {
            print ("error al borrar notificacion")
        }
        self.window?.rootViewController?.view.makeToast(notification.alertBody, duration: 4.0, position: .Center, title: nil, image: UIImage(named: "AlarmaActivada"), style: nil, completion: nil)
    }
    func applicationWillEnterForeground(application: UIApplication) {
        do {
            let notifications = try NotificationsDataHelper.findAll()! as [Notification]
            for noti in notifications {
                let noti2 = noti as Notification
                let now = NSDate()
                if now.compare(noti.firedate) == NSComparisonResult.OrderedDescending || now.compare(noti.firedate) == NSComparisonResult.OrderedSame {
                    do{
                        try NotificationsDataHelper.delete(noti2)
                    } catch _ {
                        print ("error al borrar notificacion")
                    }
                }
            }
        }catch _ {
            
        }
    
    }
    func applicationWillResignActive(application: UIApplication) {
        do{
            let notificaciones = try NotificationsDataHelper.findAll()
            application.applicationIconBadgeNumber =  (notificaciones?.count)!
        }catch _ {
            print("error al mostrar notificaciones")
        }
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        AFNetworkReachabilityManager.sharedManager().setReachabilityStatusChangeBlock {
            if($0 == .Unknown || $0 == .NotReachable){
                self.window?.rootViewController?.view.makeToast(NSLocalizedString("SINCONEXION",comment:"No tienes conexion"), duration: 2, position: .Top)
                self.isConected = false
            }
            if($0 == .ReachableViaWWAN || $0 == .ReachableViaWiFi){
                self.isConected = true
            }

        
        }
        AFNetworkReachabilityManager.sharedManager().startMonitoring()
    }
    


}

