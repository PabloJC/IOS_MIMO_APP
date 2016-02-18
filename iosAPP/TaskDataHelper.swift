//
//  RecipeDataHelper.swift
//  iosAPP
//
//  Created by mikel balduciel diaz on 18/2/16.
//  Copyright © 2016 mikel balduciel diaz. All rights reserved.
//

import Foundation
import SQLite

class TaskDataHelper: DataHelperProtocol {
    static let TABLE_NAME = "Tasks"
    
    static let table = Table(TABLE_NAME)
    static let taskId = Expression<Int64>("taskId")
    static let taskIdServer = Expression<Int64>("taskIdServer")
    static let name = Expression<String>("name")
    static let photo = Expression<String>("photo")
    static let seconds = Expression<Int64>("seconds")
    static let recipeId = Expression<Int64>("recipeId")
    static let taskDescription = Expression<String>("taskDescription")
    
    
    typealias T = Task
    
    static func createTable() throws {
        guard let DB = SQLiteDataStore.sharedInstance.DB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        do {
            let _ = try DB.run(table.create(temporary: false, ifNotExists: true) { t in
                t.column(taskId, primaryKey: true)
                t.column(taskIdServer)
                t.column(name)
                t.column(photo)
                t.column(seconds)
                t.column(recipeId)
                t.column(taskDescription)
                print("tabla task creada")
                })
        }catch _ {
            print("error create table")
        }
    }
    static func insert (item: T) throws -> Int64 {
        guard let DB = SQLiteDataStore.sharedInstance.DB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        let insert = table.insert(taskIdServer <- item.taskIdServer, name <- item.name, photo <- item.photo, seconds <- item.seconds, recipeId <- item.recipeId, taskDescription <- item.taskDescription)
        print (insert)
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
        
        let query = table.filter(taskId == item.taskId)
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
        let query = table.filter(taskId == id)
        let items = try DB.prepare(query)
        for item in  items {
            let task = Task()
            
            task.taskId = item[taskId]
            task.taskIdServer = item[taskIdServer]
            task.name = item[name]
            task.photo = item[photo]
            task.seconds = item[seconds]
            task.recipeId = item[recipeId]
            task.taskDescription = item[taskDescription]
          
            return task
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
            let task = Task()
            
            task.taskId = item[taskId]
            task.taskIdServer = item[taskIdServer]
            task.name = item[name]
            task.photo = item[photo]
            task.seconds = item[seconds]
            task.recipeId = item[recipeId]
            task.taskDescription = item[taskDescription]
            
            retArray.append(task)
        }
        
        return retArray
        
    }
}
