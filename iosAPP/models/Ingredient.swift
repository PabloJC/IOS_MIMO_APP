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
    
    static func addIngredientStorage(ingredient: Ingredient) throws -> Void{
        ingredient.storageId = 1
        try IngredientDataHelper.insert(ingredient)
    }
    
    static func updateIngredientStorage(ingredient: Ingredient) throws -> Void{
        ingredient.storageId = 1
        try IngredientDataHelper.updateStorage(ingredient)
    }
    
    static func deleteIngredientStorage(ingredient: Ingredient) throws -> Void{
        ingredient.storageId = 0
        try IngredientDataHelper.updateStorage(ingredient)
    }
    
    static func addIngredientCart(ingredient: Ingredient) throws -> Void{
        ingredient.cartId = 1
        try IngredientDataHelper.insert(ingredient)
    }
    
    static func updateIngredientCart(ingredient: Ingredient) throws -> Void{
        ingredient.cartId = 1
        try IngredientDataHelper.updateCart(ingredient)
    }
    
    static func deleteIngredientCart(ingredient: Ingredient) throws -> Void{
        ingredient.cartId = 0
        try IngredientDataHelper.updateCart(ingredient)
    }
}
