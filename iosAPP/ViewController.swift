//
//  ViewController.swift
//  iosAPP
//
//  Created by mikel balduciel diaz on 31/1/16.
//  Copyright © 2016 mikel balduciel diaz. All rights reserved.
//

import UIKit
class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let dataStore = SQLiteDataStore.sharedInstance
        do{
            try dataStore.createTables()
            
            if try StorageDataHelper.find(1) == nil {
                
            let  S = Storage()
             let id = try  StorageDataHelper.insert(S)
                print ("storage creado \(id)" )
                
            }
           
          /*  let  recipe = Recipe()
            recipe.name = "mikel"
            let recipeId = try RecipeDataHelper.insert(
               recipe
            )
            
            print(recipeId)
            let  M = MeasureIngredients()
            M.measure = "Unidades"
           
          let measureid = try MeasureDataHelper.insert(M)
           print (measureid)*/
           /* var ingredient = Ingredient()
            ingredient.name = "Tortilla de patatas"
            var ingredient2 = Ingredient()
            ingredient2.name = "Tortilla de patatas2"
            var ingredient3 = Ingredient()
            ingredient3.name = "Tortilla de patatas3"
            try IngredientDataHelper.insert(ingredient)
            var i3id = try IngredientDataHelper.insert(ingredient2)
            try IngredientDataHelper.insert(ingredient3)
            var ingredientes = [Ingredient]()
            ingredientes = try IngredientDataHelper.findAll()!
            print(ingredientes)
            var ingredient4 = Ingredient()
            ingredient4.ingredientId = i3id
            try IngredientDataHelper.delete(ingredient4)
            ingredientes = try IngredientDataHelper.findAll()!
            print(ingredientes)*/
        }catch _ {
            print ("error insert")
        }
        print ("Finish")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

