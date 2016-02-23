//
//  RecipeDataHelper.swift
//  iosAPP
//
//  Created by mikel balduciel diaz on 18/2/16.
//  Copyright © 2016 mikel balduciel diaz. All rights reserved.
//

import Foundation
import SQLite

class CartDataHelper: DataHelperProtocol {
    static let TABLE_NAME = "Carts"
    
    static let table = Table(TABLE_NAME)
    static let cartId = Expression<Int64>("cartId")
    
    
    typealias T = Cart
    
    static func createTable() throws {
        guard let DB = SQLiteDataStore.sharedInstance.DB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        do {
            let _ = try DB.run(table.create(temporary: false, ifNotExists: true) { t in
                t.column(cartId, primaryKey: true)
               
                })
        }catch _ {
            print("error create table")
        }
    }
    static func insert (item: T) throws -> Int64 {
        guard let DB = SQLiteDataStore.sharedInstance.DB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        let insert = table.insert()
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
        
        let query = table.filter(cartId == item.cartId)
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
        let query = table.filter(cartId == id)
        let items = try DB.prepare(query)
        for item in  items {
            let cart = Cart()
            
            cart.cartId = item[cartId]
            
            
            return cart
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
            let cart = Cart()
            
            cart.cartId = item[cartId]
            
            retArray.append(cart)
        }
        
        return retArray
        
    }
}
