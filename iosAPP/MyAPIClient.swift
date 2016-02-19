

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
                 print("\(result)")
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
            
       // let util = Util.init()
           // let recipe = util.prepareObject("Recipe") as! Recipe
            
            
            
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
                    let recipe = Recipe()
                    let result = responseObject! as! [String:AnyObject]
                    print("\(result)")
                    let name = result["name"]
                    let id = result["id"]
                    let photo = result["photo"]
                    if !(photo  is NSNull) {
                        recipe.photo = (photo as? String)!
                      //recipe.setValue(photo, forKey: "photo")
                    }
                    let portions = result["portions"]
                    recipe.recipeIdServer = Int64(id as! Int)
                    recipe.name = (name as? String)!
                    if result["favorite"] != nil {
                        let fav = result ["favorite"] as! Bool
                        if fav {
                            recipe.favorite = FavoriteTypes.favorite
                        }
                    }
                    
                    recipe.portions = Int64(portions as! Int)
                   // recipe.setValue(id, forKey: "recipeID")
                    //recipe.setValue(name, forKey: "name")
                    //recipe.setValue(portions, forKey: "portions")
                    
                    let ingredients = result["measureIngredients"] as! [[String:AnyObject]]
                   // var array = [AnyObject]()
                    for i in ingredients {
                        //let ingredientsRecipe = util.prepareObject("IngredientTask") as! IngredientTask
                        let ingredientsRecipe = MeasureIngredients()
                        //let ingredientsObject = util.prepareObject("Ingredient") as! Ingredient
                        let ingredientsObject = Ingredient()
                        var ingre = i["ingredient"] as! [String:AnyObject]
                        ingredientsObject.baseType = ingre["baseType"] as! String
                        //ingredientsObject.setValue(ingre["baseType"], forKey: "BaseType")
                        ingredientsObject.category = ingre["category"] as! String
                        //ingredientsObject.setValue(ingre["category"], forKey: "category")
                        ingredientsObject.ingredientIdServer = Int64(ingre["id"] as! Int)
                        //ingredientsObject.setValue(ingre["id"], forKey: "ingredientID")
                        ingredientsObject.name = ingre["name"] as! String
                        //ingredientsObject.setValue(ingre["name"], forKey: "name")
                        let frozen = ingre["frozen"] as! Bool
                        if frozen {
                            ingredientsObject.frozen = FrozenTypes.frozen
                        }
                        //ingredientsObject.setValue(ingre["frozen"], forKey: "frozen")
                        ingredientsRecipe.measure = (i["measure"] as? String)!
                        //ingredientsRecipe.measure = i["measure"] as? String
                        ingredientsRecipe.quantity = Int64(i["quantity"] as! Int)
                        //ingredientsRecipe.quantity = i["quantity"] as? Int
                        ingredientsRecipe.measureIdServer = Int64(ingre["id"] as! Int)
                        //ingredientsRecipe.ingredientTaskID = i["id"] as? Int
                        ingredientsRecipe.ingredient = ingredientsObject
                        //ingredientsRecipe.ingredient = ingredientsObject
                       // array.append(ingredientsRecipe)
                        recipe.measures.append(ingredientsRecipe)
                    }
                    let tasks = result["tasks"] as! [[String:AnyObject]]
                   // var arrayTasks = [AnyObject]()
                    for t in tasks {
                       // let taskObject = util.prepareObject("Task") as! Task
                        let taskObject = Task()
                        taskObject.taskIdServer = Int64(t["id"] as! Int)
                        //taskObject.taskID = t["id"] as? Int
                        taskObject.name = (t["name"] as? String)!
                        //taskObject.name = t["name"] as? String
                        taskObject.taskDescription = (t["description"] as? String)!
                        //taskObject.taskDescription = t["description"] as? String
                        if t["seconds"] is NSNull {}
                        else{
                           taskObject.seconds = Int64(t["seconds"] as! Int)
                        }
                        
                        //taskObject.seconds = t["seconds"] as? Int
                        recipe.tasks.append(taskObject)
                       // arrayTasks.append(taskObject)
                    }

                    
                   // recipe.mutableSetValueForKey("ingredientsRecipe").addObjectsFromArray(array)
                    //recipe.mutableSetValueForKey("tasks").addObjectsFromArray(arrayTasks)
                    recipe2!((recipe))
                    finished?()
                    
                },
                failure:  { operation, error in
                    failure?(error)
            })
    }
    
    func getCategory(category: String,
        ingredients: ((Ingredient) -> ())?,
        finished: (() -> ())?,
        failure:  (NSError -> ())?) {
            
            self.requestSerializer = AFJSONRequestSerializer()
            self.responseSerializer = AFJSONResponseSerializer()
                      
            let url = "/ingredients/category/\(category)"
            
            //var ids = [Dictionary<String,Int64>]()
            
            /*if !filters!.isEmpty {
                for i in filters!{
                    let dict = ["id":i.ingredientIdServer]
                    ids.append(dict)
                }
            }*/

            self.GET(url,
                parameters: nil,
                progress: nil,
                success: { operation, responseObject in
                    
                    let result = responseObject! as! [[String:AnyObject]]
                    for ingredient in result {
                        let ingredientObject = Ingredient()
                        ingredientObject.baseType = ingredient["baseType"] as! String
                        ingredientObject.category = ingredient["category"] as! String
                        ingredientObject.ingredientIdServer = Int64(ingredient["id"] as! Int)
                        ingredientObject.name = ingredient["name"] as! String
                        let frozen = ingredient["frozen"] as! Int
                        if frozen == 0{
                            ingredientObject.frozen = FrozenTypes.noFrozen
                        }else{
                            ingredientObject.frozen = FrozenTypes.frozen
                        }
                        ingredients!(ingredientObject)
                    }  
                    finished?()
                    
                },
                failure:  { operation, error in
                    failure?(error)
            })
    }
}