//
//  MeasureIngredients.swift
//  iosAPP
//
//  Created by mikel balduciel diaz on 17/2/16.
//  Copyright © 2016 mikel balduciel diaz. All rights reserved.
//

import Foundation

class MeasureIngredients : NSObject{
    var measureId = Int64()
     var measureIdServer = Int64()
    var measure = String()
    var recipeId = Int64()
    var ingredientId = Int64()
    var quantity = Int64()
    var ingredient = Ingredient()
}