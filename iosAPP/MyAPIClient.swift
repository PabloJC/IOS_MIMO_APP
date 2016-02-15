

import Foundation
import AFNetworking
import CoreData
class MyAPIClient: AFHTTPSessionManager {
    
    
    init() {
		super.init(baseURL: NSURL(string: "http://otakucook.herokuapp.com/")!,
			sessionConfiguration: NSURLSessionConfiguration.defaultSessionConfiguration())
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init(coder: aDecoder)
    }
    
    func getRecipes(
        recipes: ((String,Int) -> ())?,
		finished: (() -> ())?,
		failure:  (NSError -> ())?) {
            
            self.requestSerializer = AFJSONRequestSerializer()
            self.responseSerializer = AFJSONResponseSerializer()

        let url = "/recipes"
        self.GET(url,
			parameters: nil,
			progress: nil,
			success: { operation, responseObject in
	            
    	            let result = responseObject! as! [[String:AnyObject]]
                for recipe in result {
                    let id = recipe["id"]!
                    let nombre = recipe["name"]!
                    recipes!(nombre as! String, id as! Int)
                }
                
	                finished?()
				
            },
			failure:  { operation, error in
				failure?(error)
			})
    }
    func getrecipe(idRecipe: String,
        recipe2:((Recipe) -> ())?,
        finished : (() -> ())?,
        failure: (NSError -> ())?) {
            self.requestSerializer = AFJSONRequestSerializer()
            self.responseSerializer = AFJSONResponseSerializer()
            
            let util = Util.init()
            let recipe = util.prepareObject("Recipe") as! Recipe
            let ingredientsRecipe = util.prepareObject("IngredientTask") as! IngredientTask
            let ingredientsObject = util.prepareObject("Ingredient") as! Ingredient
            
           /* let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
            
            let managedContext = appDelegate.managedObjectContext
            
            //2
            let entity =  NSEntityDescription.entityForName("Recipe",
                inManagedObjectContext:managedContext)
            
            let recipe = NSManagedObject(entity: entity!,
                insertIntoManagedObjectContext: managedContext) as! Recipe
            
            let entity2 =  NSEntityDescription.entityForName("IngredientTask",
                inManagedObjectContext:managedContext)
            
            let ingredientsRecipe = NSManagedObject(entity: entity2!,
                insertIntoManagedObjectContext: managedContext) as! IngredientTask
            
            let entity3 =  NSEntityDescription.entityForName("Ingredient",
                inManagedObjectContext:managedContext)
            
            let ingredientsObject = NSManagedObject(entity: entity3!,
                insertIntoManagedObjectContext: managedContext) as! Ingredient */
            
            //3
            
            let url = "/recipes/\(idRecipe)"
            self.GET(url,
                parameters: nil,
                progress: nil,
                success: { operation, responseObject in
                    
                    let result = responseObject! as! [String:AnyObject]
                    //print("\(result)")
                    let name = result["name"]
                    let id = result["id"]
                    let photo = result["foto"]
                    let portions = result["portions"]
                    recipe.setValue(id, forKey: "recipeID")
                    recipe.setValue(name, forKey: "name")
                    recipe.setValue(portions, forKey: "portions")
                    recipe.setValue(photo, forKey: "photo")
                    let ingredients = result["measureIngredients"] as! [[String:AnyObject]]
                    for i in ingredients {
                        var ingre = i["ingredient"] as! [String:AnyObject]
                        ingredientsObject.setValue(ingre["baseType"], forKey: "type")
                        ingredientsObject.setValue(ingre["category"], forKey: "category")
                        ingredientsObject.setValue(ingre["id"], forKey: "ingredientID")
                        ingredientsObject.setValue(ingre["name"], forKey: "baseName")
                        ingredientsRecipe.ingredient = ingredientsObject
                        
                        recipe.mutableSetValueForKey("ingredientsRecipe").addObject(ingredientsRecipe)
                        print(recipe.mutableSetValueForKey("ingredientsRecipe").count)
                    }
                    
                    recipe2!((recipe))
                    finished?()
                    
                },
                failure:  { operation, error in
                    failure?(error)
            })
    }
    func getCategory(
        ingredients: ((String,Int) -> ())?,
        finished: (() -> ())?,
        failure:  (NSError -> ())?) {
            
            self.requestSerializer = AFJSONRequestSerializer()
            self.responseSerializer = AFJSONResponseSerializer()
            
            let url = "/ingredients"
            self.GET(url,
                parameters: nil,
                progress: nil,
                success: { operation, responseObject in
                    
                    let result = responseObject! as! [[String:AnyObject]]
                    for ingredient in result {
                        let id = ingredient["id"]!
                        let nombre = ingredient["name"]!
                        ingredients!(nombre as! String, id as! Int)
                    }
                    
                    finished?()
                    
                },
                failure:  { operation, error in
                    failure?(error)
            })
    }
}