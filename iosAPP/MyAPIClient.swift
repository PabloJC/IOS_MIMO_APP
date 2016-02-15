

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
                    let photo = result["photo"]
                    let portions = result["portions"]
                    recipe.setValue(id, forKey: "recipeID")
                    recipe.setValue(name, forKey: "name")
                    recipe.setValue(portions, forKey: "portions")
                    recipe.setValue(photo, forKey: "photo")
                    let ingredients = result["measureIngredients"] as! [[String:AnyObject]]
                    var array = [AnyObject]()
                    for i in ingredients {
                        let ingredientsRecipe = util.prepareObject("IngredientTask") as! IngredientTask
                        let ingredientsObject = util.prepareObject("Ingredient") as! Ingredient
                        var ingre = i["ingredient"] as! [String:AnyObject]
                        ingredientsObject.setValue(ingre["baseType"], forKey: "BaseType")
                        ingredientsObject.setValue(ingre["category"], forKey: "category")
                        ingredientsObject.setValue(ingre["id"], forKey: "ingredientID")
                        ingredientsObject.setValue(ingre["name"], forKey: "name")
                        ingredientsObject.setValue(ingre["frozen"], forKey: "frozen")
                        ingredientsRecipe.measure = i["measure"] as? String
                        ingredientsRecipe.quantity = i["quantity"] as? Int
                        ingredientsRecipe.ingredientTaskID = i["id"] as? Int
                        ingredientsRecipe.ingredient = ingredientsObject
                        array.append(ingredientsRecipe)
                    }
                    let tasks = result["tasks"] as! [[String:AnyObject]]
                    var arrayTasks = [AnyObject]()
                    for t in tasks {
                        let taskObject = util.prepareObject("Task") as! Task
                        taskObject.taskID = t["id"] as? Int
                        taskObject.name = t["name"] as? String
                        taskObject.taskDescription = t["description"] as? String
                        taskObject.seconds = t["seconds"] as? Int
                        arrayTasks.append(taskObject)
                    }

                    
                    recipe.mutableSetValueForKey("ingredientsRecipe").addObjectsFromArray(array)
                    recipe.mutableSetValueForKey("tasks").addObjectsFromArray(arrayTasks)
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