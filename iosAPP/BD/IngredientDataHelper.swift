//
//  IngredientDataHelper.swift
//  iosAPP
//
//  Created by mikel balduciel diaz on 17/2/16.
//  Copyright © 2016 mikel balduciel diaz. All rights reserved.
//

import Foundation
import SQLite

class IngredientDataHelper: DataHelperProtocol {
    static let TABLE_NAME = "Ingredients"
    
    static let table = Table(TABLE_NAME)
   // let storage = Table("users")
    static let ingredientId = Expression<Int64>("ingredientId")
    static let ingredientIdServer = Expression<Int64>("ingredientIdServer")
    static let name = Expression<String>("name")
    static let baseType = Expression<String>("baseType")
    static let category = Expression<String>("category")
    static let frozen = Expression<Int64>("frozen")
    static let storageId = Expression<Int64>("storageId")
    static let cartId = Expression<Int64>("cartId")
    typealias T = Ingredient
    
    static func createTable() throws {
        guard let DB = SQLiteDataStore.sharedInstance.DB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        do {
            let _ = try DB.run(table.create(temporary: false, ifNotExists: true) { t in
                t.column(ingredientId, primaryKey: true)
                t.column(ingredientIdServer)
                t.column(name, unique: true)
                t.column(baseType)
                t.column(category)
                t.column(frozen)
                t.column(storageId)
                t.column(cartId)
               
                })
        }catch _ {
            print("error create table")
        }
    }
    static func insert (item: T) throws -> Int64 {
        guard let DB = SQLiteDataStore.sharedInstance.DB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        let insert = table.insert(ingredientIdServer <- item.ingredientIdServer, name <- item.name, baseType <- item.baseType, category <- item.category, frozen <- item.frozen.rawValue, storageId <- item.storageId, cartId <- item.cartId)
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
        
            let query = table.filter(ingredientId == item.ingredientId)
            do {
                let tmp = try DB.run(query.delete())
                guard tmp == 1 else {
                    throw DataAccessError.Delete_Error
                }
            } catch _ {
                throw DataAccessError.Delete_Error
            }
    }
    
    static func updateStorage (item: T) throws -> Void {
        guard let DB = SQLiteDataStore.sharedInstance.DB else {
            throw DataAccessError.Datastore_Connection_Error
        }

        let query = table.filter(ingredientId == item.ingredientId)
        do {
            let tmp = try DB.run(query.update(storageId <- item.storageId))
            guard tmp == 1 else {
                throw DataAccessError.Delete_Error
            }
        } catch _ {
            throw DataAccessError.Delete_Error
        }
    }
    
    static func findIngredientsInStorage () throws -> [T]? {
        guard let DB = SQLiteDataStore.sharedInstance.DB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        
        let query = table.filter(storageId == 1)
        var retArray = [T]()
        let items = try DB.prepare(query)
        for item in items {
            let ingredient = Ingredient()
            ingredient.ingredientId = item[ingredientId]
            ingredient.ingredientIdServer = item[ingredientIdServer]
            ingredient.name = item[name]
            ingredient.baseType = item[baseType]
            ingredient.category = item[category]
            ingredient.frozen = FrozenTypes(rawValue: item[frozen])!
            ingredient.storageId = item[storageId]
            ingredient.cartId = item[cartId]
            retArray.append(ingredient)
        }
        return retArray
    }
    static func findIngredientsNotInStorage () throws -> [T]? {
        guard let DB = SQLiteDataStore.sharedInstance.DB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        
        let query = table.filter(storageId != 1)
        var retArray = [T]()
        let items = try DB.prepare(query)
        for item in items {
            let ingredient = Ingredient()
            ingredient.ingredientId = item[ingredientId]
            ingredient.ingredientIdServer = item[ingredientIdServer]
            ingredient.name = item[name]
            ingredient.baseType = item[baseType]
            ingredient.category = item[category]
            ingredient.frozen = FrozenTypes(rawValue: item[frozen])!
            ingredient.storageId = item[storageId]
            ingredient.cartId = item[cartId]
            retArray.append(ingredient)
        }
        return retArray
    }
    
    static func findIngredientsInCart () throws -> [T]? {
        guard let DB = SQLiteDataStore.sharedInstance.DB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        
        let query = table.filter(cartId != 1)
        var retArray = [T]()
        let items = try DB.prepare(query)
        for item in items {
            let ingredient = Ingredient()
            ingredient.ingredientId = item[ingredientId]
            ingredient.ingredientIdServer = item[ingredientIdServer]
            ingredient.name = item[name]
            ingredient.baseType = item[baseType]
            ingredient.category = item[category]
            ingredient.frozen = FrozenTypes(rawValue: item[frozen])!
            ingredient.storageId = item[storageId]
            ingredient.cartId = item[cartId]
            retArray.append(ingredient)
        }
        return retArray
    }

    static func find(id: Int64) throws -> T? {
        guard let DB = SQLiteDataStore.sharedInstance.DB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        let query = table.filter(ingredientId == id)
        let items = try DB.prepare(query)
        for item in  items {
            let ingredient = Ingredient()
            ingredient.ingredientId = item[ingredientId]
            ingredient.ingredientIdServer = item[ingredientIdServer]
            ingredient.name = item[name]
            ingredient.baseType = item[baseType]
            ingredient.category = item[category]
            ingredient.frozen = FrozenTypes(rawValue: item[frozen])!
            ingredient.storageId = item[storageId]
            ingredient.cartId = item[cartId]
            return ingredient
        }
        
        return nil
        
    }
    static func findIdServer(id: Int64) throws -> T? {
        guard let DB = SQLiteDataStore.sharedInstance.DB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        let query = table.filter(ingredientIdServer == id)
        let items = try DB.prepare(query)
        for item in  items {
            let ingredient = Ingredient()
            ingredient.ingredientId = item[ingredientId]
            ingredient.ingredientIdServer = item[ingredientIdServer]
            ingredient.name = item[name]
            ingredient.baseType = item[baseType]
            ingredient.category = item[category]
            ingredient.frozen = FrozenTypes(rawValue: item[frozen])!
            ingredient.storageId = item[storageId]
            ingredient.cartId = item[cartId]
            return ingredient
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
            let ingredient = Ingredient()
            ingredient.ingredientId = item[ingredientId]
            ingredient.ingredientIdServer = item[ingredientIdServer]
            ingredient.name = item[name]
            ingredient.baseType = item[baseType]
            ingredient.category = item[category]
            ingredient.frozen = FrozenTypes(rawValue: item[frozen])!
            ingredient.storageId = item[storageId]
            ingredient.cartId = item[cartId]
            retArray.append(ingredient)
        }
        
        return retArray
        
    }
}