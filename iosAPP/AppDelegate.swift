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
        //application.applicationIconBadgeNumber =
        
       // UIApplication.sharedApplication().applicationIconBadgeNumber = application.applicationIconBadgeNumber - 1
        
        
        let id = notification.userInfo!["uid"]
        let noti = Notification()
        noti.notificationId = Int64(id! as! Int)
        do{
           try NotificationsDataHelper.delete(noti)
            print("id de la notificacion borrada " + "\(id)!")
        } catch _ {
            print ("error al borrar notificacion")
        }
        do{
            let notificaciones = try NotificationsDataHelper.findAll()
            application.applicationIconBadgeNumber =  (notificaciones?.count)!
        }catch _ {
            print("error al mostrar notificaciones")
        }
        
        //application.cancelAllLocalNotifications()
        self.window?.rootViewController?.view.makeToast(notification.alertBody, duration: 4.0, position: .Center, title: nil, image: UIImage(named: "favoritos.png"), style: nil, completion: nil)
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

