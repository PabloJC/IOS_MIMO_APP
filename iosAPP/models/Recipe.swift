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
    
    static func createRecipe(recipe: Recipe) -> Recipe{
        var recipeTMI: Recipe?
        var measuresArray = [MeasureIngredients]()
        
        do{
            recipeTMI = recipe
            let tasks = try TaskDataHelper.findAllRecipe(recipe.recipeId)! as [Task]
            recipeTMI!.tasks = tasks
            let measures = try MeasureDataHelper.findAllRecipe(recipe.recipeId)! as [MeasureIngredients]
            for m in measures {
                var measure : MeasureIngredients
                measure = m
                measure.ingredient = try IngredientDataHelper.find(measure.ingredientId)!
                measuresArray.append(measure)
            }
            recipeTMI?.measures = measuresArray
        }catch _ {
            
        }
        return recipeTMI!
        
    }
    static func saveFavorite(recipe: Recipe) -> Bool {
        var correcto = true
        let recipeIns = recipe
        var measure : MeasureIngredients
        var RecipeId : Int64?
        recipeIns.favorite = FavoriteTypes.favorite
        do{
            
            let r = try RecipeDataHelper.findIdServer((recipeIns.recipeIdServer))
            if r == nil {
                RecipeId = try RecipeDataHelper.insert(recipe)
            }else {
                correcto = false
            }
            
            
        }catch _ {
            correcto = false
            print("error al crear receta favorita")
        }
        if correcto {
            var ingredient: Ingredient
            for m in (recipe.measures) {
                do {
                    
                    measure = m
                    measure.recipeId = RecipeId!
                    ingredient = measure.ingredient
                    let i = try IngredientDataHelper.findIdServer(ingredient.ingredientIdServer)
                    if i == nil {
                        let IngredientId = try IngredientDataHelper.insert(ingredient)
                        measure.ingredientId = IngredientId
                        
                    }else {
                        measure.ingredientId = (i?.ingredientId)!
                    }
                }catch _ {
                    correcto = false
                    print("error al crear ingrediente de receta")
                }
                if correcto {
                    do {
                        try MeasureDataHelper.insert(measure)
                    }catch _ {
                        correcto = false
                        print("error al crear medida de ingrediente")
                    }
                }
            }
        }
        if correcto {
            var _: Task
            for t in (recipe.tasks) {
                do{
                    t.recipeId = RecipeId!
                    try TaskDataHelper.insert(t)
                    
                } catch _ {
                    print("error al crear la tarea")
                }
            }
            print("receta agregada")
        }
        return correcto
    }
    
    
}