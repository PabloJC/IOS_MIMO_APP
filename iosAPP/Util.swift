//
//  Util.swift
//  iosAPP
//
//  Created by mikel balduciel diaz on 15/2/16.
//  Copyright © 2016 mikel balduciel diaz. All rights reserved.
//

import Foundation
import AFNetworking
import CoreData
class Util{
    var appDelegate : AppDelegate
    var managedContext : NSManagedObjectContext
    init() {
        
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
         managedContext = appDelegate.managedObjectContext
    }
    func prepareObject(nameObject: String) -> NSManagedObject {
        
        //let entity =  NSEntityDescription.entityForName(nameObject,inManagedObjectContext:managedContext)
       let object = NSEntityDescription.insertNewObjectForEntityForName(nameObject, inManagedObjectContext: managedContext)
        //let recipe = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        return object
    }
    func saveContext(){
        if managedContext.hasChanges {
            do {
                try managedContext.save()
            }
            catch let error as NSError {
                print ("Error: \(error.localizedDescription)")
                abort()
            }
        }
    }
    

}