//
//  Cart.swift
//  iosAPP
//
//  Created by mikel balduciel diaz on 18/2/16.
//  Copyright © 2016 mikel balduciel diaz. All rights reserved.
//

import Foundation

class Cart : NSObject {
    var cartId = Int64()
    var ingredientes = [Ingredient]()
    static func initCart() {
        do {
            if try CartDataHelper.find(1) == nil {
                let  C = Cart()
                try  CartDataHelper.insert(C)
                
            }
        } catch _ {
            
        }
    }
}