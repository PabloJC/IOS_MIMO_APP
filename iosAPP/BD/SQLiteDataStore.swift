//
//  SQLiteDataStore.swift
//  iosAPP
//
//  Created by mikel balduciel diaz on 17/2/16.
//  Copyright © 2016 mikel balduciel diaz. All rights reserved.
//

import Foundation
import SQLite

enum DataAccessError: ErrorType {
    case Datastore_Connection_Error
    case Insert_Error
    case Delete_Error
    case Search_Error
    case Nil_In_Data
}

class SQLiteDataStore {
    static let sharedInstance = SQLiteDataStore()
    let DB: Connection?
    private init() {
        var path = "OtakuCookBD.sqlite"
        if let dirs: [NSString] =
            NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as [NSString] {
                let dir = dirs[0]
                path = dir.stringByAppendingPathComponent("OtakuCookBD.sqlite")
                print(path)
        }
        do {
            DB = try Connection(path)
        } catch _ {
            DB = nil
        }
    }
    func createTables() throws{
        do {
            try RecipeDataHelper.createTable()
            try IngredientDataHelper.createTable()
            try MeasureDataHelper.createTable()
            try TaskDataHelper.createTable()
            try StorageDataHelper.createTable()
            try CartDataHelper.createTable()
            try NotificationsDataHelper.createTable()
            
        }catch{
            throw DataAccessError.Datastore_Connection_Error
        }
    }
    
}