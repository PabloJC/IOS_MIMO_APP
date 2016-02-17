//
//  RecipeDataHelper.swift
//  iosAPP
//
//  Created by mikel balduciel diaz on 17/2/16.
//  Copyright © 2016 mikel balduciel diaz. All rights reserved.
//

import Foundation
import SQLite

class RecipeDataHelper: DataHelperProtocol {
    static let TABLE_NAME = "Recipes"
    
    static let table = Table(TABLE_NAME)
    static let recipeId = Expression<Int64>("recipeId")
    static let recipeIdServer = Expression<Int64>("recipeIdServer")
    static let name = Expression<String>("name")
    static let portions = Expression<Int64>("portions")
    static let favorite = Expression<Int64>("favorite")
    static let author = Expression<String>("author")
    static let score = Expression<Int64>("score")
    static let photo = Expression<String>("photo")
    
    typealias T = Recipe
    
    static func createTable() throws {
        guard let DB = SQLiteDataStore.sharedInstance.DB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        do {
            let _ = try DB.run(table.create(temporary: false, ifNotExists: true) { t in
                t.column(recipeId, primaryKey: true)
                t.column(recipeIdServer)
                t.column(name)
                t.column(portions)
                t.column(favorite)
                t.column(author)
                t.column(score)
                t.column(photo)
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
            let insert = table.insert(recipeIdServer <- item.recipeIdServer, name <- item.name, portions <- item.portions, favorite <- item.favorite!.rawValue, author <- item.author, score <- item.score, photo <- item.photo)
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
}