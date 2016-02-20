//
//  Recipe.swift
//  iosAPP
//
//  Created by mikel balduciel diaz on 17/2/16.
//  Copyright © 2016 mikel balduciel diaz. All rights reserved.
//

import Foundation

enum FavoriteTypes: Int64{
    case favorite = 1
    case noFavorite = 0
}

class Recipe : NSObject {
    var recipeId = Int64()
    var recipeIdServer = Int64()
    var name = String()
    var portions = Int64()
    var favorite : FavoriteTypes? = FavoriteTypes.noFavorite
    var author = String()
    var score = Int64()
    var photo = String()
    var measures = [MeasureIngredients]()
    var tasks = [Task]()
}