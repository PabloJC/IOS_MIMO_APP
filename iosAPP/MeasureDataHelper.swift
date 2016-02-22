//
//  RecipeDataHelper.swift
//  iosAPP
//
//  Created by mikel balduciel diaz on 17/2/16.
//  Copyright © 2016 mikel balduciel diaz. All rights reserved.
//

import Foundation
import SQLite

class MeasureDataHelper: DataHelperProtocol {
    static let TABLE_NAME = "Measures"
    
    static let table = Table(TABLE_NAME)
    static let measureId = Expression<Int64>("measureId")
    static let measureIdServer = Expression<Int64>("measureIdServer")
    static let measure = Expression<String>("measure")
    static let quantity = Expression<Int64>("quantity")
    static let recipeId = Expression<Int64>("recipeId")
    static let ingredientId = Expression<Int64>("ingredientId")
    
    
   
    typealias T = MeasureIngredients
    
    static func createTable() throws {
        guard let DB = SQLiteDataStore.sharedInstance.DB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        do {
            let _ = try DB.run(table.create(temporary: false, ifNotExists: true) { t in
                t.column(measureId, primaryKey: true)
                t.column(measureIdServer)
                t.column(measure)
                t.column(quantity)
                t.column(recipeId)
                t.column(ingredientId)
               
                print("tabla recipe creada")
                })
        }catch _ {
            print("error create table")
        }
    }
    static func insert (item: T) throws -> Int64 {
        guard let DB = SQLiteDataStore.sharedInstance.DB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        
            let insert = table.insert(measureIdServer <- item.measureIdServer,measure <- item.measure,quantity <- item.quantity,recipeId <- item.recipeId,ingredientId <- item.ingredientId)
            print (insert)
            do {
                let rowId = try DB.run(insert)
                guard rowId > 0 else {
                    throw DataAccessError.Insert_Error
                }
                return rowId
            }
    }
    static func delete (item: T) throws -> Void {
        guard let DB = SQLiteDataStore.sharedInstance.DB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        
        let query = table.filter(measureId == item.measureId)
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
        let query = table.filter(measureId == id)
        let items = try DB.prepare(query)
        for item in  items {
            let measureObj = MeasureIngredients()
            
            measureObj.measureId = item[measureId]
            measureObj.measureIdServer = item[measureIdServer]
            measureObj.measure = item[measure]
            measureObj.quantity = item[quantity]
            measureObj.recipeId = item[recipeId]
            measureObj.ingredientId = item[ingredientId]
            return measureObj
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
            let measureObj = MeasureIngredients()
            
            measureObj.measureId = item[measureId]
            measureObj.measureIdServer = item[measureIdServer]
            measureObj.measure = item[measure]
            measureObj.quantity = item[quantity]
            measureObj.recipeId = item[recipeId]
            measureObj.ingredientId = item[ingredientId]
            retArray.append(measureObj)
        }
        
        return retArray
        
    }
}