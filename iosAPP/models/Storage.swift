//
//  Storage.swift
//  iosAPP
//
//  Created by mikel balduciel diaz on 18/2/16.
//  Copyright © 2016 mikel balduciel diaz. All rights reserved.
//

import Foundation

class Storage : NSObject {
    var storageId = Int64()
    var ingredientes = [Ingredient]()
    
    static func initStorage() {
        do {
            if try StorageDataHelper.find(1) == nil {
                let  S = Storage()
                try  StorageDataHelper.insert(S)
            }
        } catch _ {
            
        }
    }
}