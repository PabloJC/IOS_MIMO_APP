//
//  RecipeDataHelper.swift
//  iosAPP
//
//  Created by mikel balduciel diaz on 17/2/16.
//  Copyright © 2016 mikel balduciel diaz. All rights reserved.
//

import Foundation
import SQLite

class NotificationsDataHelper: DataHelperProtocol {
    static let TABLE_NAME = "Notifications"
    
    static let table = Table(TABLE_NAME)
    static let recipeId = Expression<Int64>("recipeId")
    static let notificationId = Expression<Int64>("notificationId")
    static let taskId = Expression<Int64>("taskId")
    static let name = Expression<String>("name")
    static let datetime = Expression<NSDate>("datetime")
    
    typealias T = Notification
    
    static func createTable() throws {
        guard let DB = SQLiteDataStore.sharedInstance.DB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        do {
            let _ = try DB.run(table.create(temporary: false, ifNotExists: true) { t in
                t.column(notificationId, primaryKey: true)
                t.column(recipeId)
                t.column(name)
                t.column(taskId)
                t.column(datetime)
                
                })
        }catch _ {
            print("error create table")
        }
    }
    static func insert (item: T) throws -> Int64 {
        guard let DB = SQLiteDataStore.sharedInstance.DB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        let insert = table.insert(recipeId <- item.recipeId, name <- item.name, taskId <- item.taskId,datetime <- item.datetime)
        do {
            let rowId = try DB.run(insert)
            guard rowId > 0 else {
                throw DataAccessError.Insert_Error
            }
            return rowId
        }catch _ {
            throw DataAccessError.Insert_Error
        }
    }
    static func delete (item: T) throws -> Void {
        guard let DB = SQLiteDataStore.sharedInstance.DB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        
        let query = table.filter(notificationId  == item.notificationId)
        do {
            let tmp = try DB.run(query.delete())
            guard tmp == 1 else {
                throw DataAccessError.Delete_Error
            }
        } catch _ {
            throw DataAccessError.Delete_Error
        }
    }
    
    static func find(id: Int64) throws -> T? {
        guard let DB = SQLiteDataStore.sharedInstance.DB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        let query = table.filter(notificationId == id)
        let items = try DB.prepare(query)
        for item in  items {
            let notification = Notification()
            notification.notificationId = item[notificationId]
            notification.name = item[name]
            notification.taskId = item[taskId]
            notification.recipeId = item[recipeId]
            notification.datetime = item[datetime]
            return notification
        }
        
        return nil
        
    }

    
    
    static func findAll() throws -> [T]? {
        guard let DB = SQLiteDataStore.sharedInstance.DB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        var retArray = [T]()
        let items = try DB.prepare(table)
        for item in items {
            let notification = Notification()
            notification.notificationId = item[notificationId]
            notification.name = item[name]
            notification.taskId = item[taskId]
            notification.recipeId = item[recipeId]
            notification.datetime = item[datetime]

            retArray.append(notification)
        }
        
        return retArray
        
    }
   }