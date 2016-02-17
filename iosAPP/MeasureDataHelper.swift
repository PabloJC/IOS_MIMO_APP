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
      static let measure = Expression<String>("measure")
   
    typealias T = MeasureIngredients
    
    static func createTable() throws {
        guard let DB = SQLiteDataStore.sharedInstance.DB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        do {
            let _ = try DB.run(table.create(temporary: false, ifNotExists: true) { t in
                t.column(measureId, primaryKey: true)
                t.column(measure)
               
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
        
            let insert = table.insert(measure <- item.measure)
            print (insert)
            do {
                let rowId = try DB.run(insert)
                guard rowId > 0 else {
                    throw DataAccessError.Insert_Error
                }
                return rowId
            }
        
    
    }
}