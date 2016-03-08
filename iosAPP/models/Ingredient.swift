//
//  Ingredient.swift
//  iosAPP
//
//  Created by mikel balduciel diaz on 17/2/16.
//  Copyright © 2016 mikel balduciel diaz. All rights reserved.
//

import Foundation

enum FrozenTypes: Int64{
    case frozen = 1
    case noFrozen = 0
}

class Ingredient : NSObject {
   var ingredientId = Int64()
    var ingredientIdServer =  Int64()
    var name = String ()
   var baseType = String()
   var category = String()
    var frozen = FrozenTypes.noFrozen
   var storageId = Int64()
    var cartId = Int64()
    var measure = String()
    var quantity = Double()
}
