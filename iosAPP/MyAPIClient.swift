

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
    func getRecipesIngredients(Ingredientes: String,
        recipes: ((String,Int) -> ())?,
        finished: (() -> ())?,
        failure:  (NSError -> ())?) {
            
            self.requestSerializer = AFJSONRequestSerializer()
            self.responseSerializer = AFJSONResponseSerializer()
            
            let url = "/recipesIngredients?ingredientes=\(Ingredientes)"
            self.GET(url,
                parameters: nil,
                progress: nil,
                success: { operation, responseObject in
                    
                    let result = responseObject! as! [[String:AnyObject]]
                    //print("\(result)")
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
                 //print("\(result)")
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
            
            
            let url = "/recipes/\(idRecipe)"
            self.GET(url,
                parameters: nil,
                progress: nil,
                success: { operation, responseObject in
                    let recipe = Recipe()
                    let result = responseObject! as! [String:AnyObject]
                   // print("\(result)")
                    let name = result["name"]
                    let id = result["id"]
                    let photo = result["photo"]
                    if !(photo  is NSNull) {
                        recipe.photo = (photo as? String)!
                      
                    }
                    let author = result["author"]
                    recipe.author = (author as? String)!
                    let score = result["score"]
                    recipe.score = Int64(score as! Int)
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
                    
                    let ingredients = result["measureIngredients"] as! [[String:AnyObject]]
                   
                    for i in ingredients {
                        
                        let ingredientsRecipe = MeasureIngredients()
                        
                        let ingredientsObject = Ingredient()
                        var ingre = i["ingredient"] as! [String:AnyObject]
                        ingredientsObject.baseType = ingre["baseType"] as! String
                        
                        ingredientsObject.category = ingre["category"] as! String
                        
                        ingredientsObject.ingredientIdServer = Int64(ingre["id"] as! Int)
                        
                        ingredientsObject.name = ingre["name"] as! String
                        
                        let frozen = ingre["frozen"] as! Bool
                        if frozen {
                            ingredientsObject.frozen = FrozenTypes.frozen
                        }
                        
                        ingredientsRecipe.measure = (i["measure"] as? String)!
                        ingredientsRecipe.quantity = Int64(i["quantity"] as! Int)
                        ingredientsRecipe.measureIdServer = Int64(ingre["id"] as! Int)
                        ingredientsRecipe.ingredient = ingredientsObject
                        recipe.measures.append(ingredientsRecipe)
                    }
                    let tasks = result["tasks"] as! [[String:AnyObject]]
                    for t in tasks {
                        let taskObject = Task()
                        taskObject.taskIdServer = Int64(t["id"] as! Int)
                        taskObject.name = (t["name"] as? String)!
                        taskObject.taskDescription = (t["description"] as? String)!
                        if t["seconds"] is NSNull {}
                        else{
                           taskObject.seconds = Int64(t["seconds"] as! Int)
                        }
                        recipe.tasks.append(taskObject)
                    }
                    recipe2!((recipe))
                    finished?()
                    
                },
                failure:  { operation, error in
                    failure?(error)
            })
    }
    
    func getCategory(category: String,
        ingredients: ((String,[Ingredient]) -> ())?,
        finished: (() -> ())?,
        failure:  (NSError -> ())?) {
            
            self.requestSerializer = AFJSONRequestSerializer()
            self.responseSerializer = AFJSONResponseSerializer()
                      
            var url = "/ingredients/category/\(category)"
            var ingredientsStore = [Ingredient]()

            do{
               ingredientsStore = try IngredientDataHelper.findAll()!
            }catch _{
                print("Error al leer el almacén")
            }
            var filters = [String]()
            for i in ingredientsStore{
                if i.ingredientIdServer != 0 && i.category == category{
                    filters.append(String(i.ingredientIdServer))
                }
            }
            
            if !filters.isEmpty{
                let filterString = filters.joinWithSeparator(",")
                url = url+"?ids="+filterString
            }
            
            print(url)

            self.GET(url,
                parameters: nil,
                progress: nil,
                success: { operation, responseObject in
                    
                    let result = responseObject! as! [[String:AnyObject]]
                    var dict = Dictionary<String,[Ingredient]>()
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
                        if dict[ingredientObject.baseType] != nil{
                            var array = dict[ingredientObject.baseType]! as [Ingredient]
                            array.append(ingredientObject)
                            dict[ingredientObject.baseType] = array
                        }else{
                             dict[ingredientObject.baseType] = [ingredientObject]
                        }
                    }
                    for clave in dict.keys {
                        ingredients!(clave,dict[clave]!)
                       
                    }
                    finished?()
                    
                },
                failure:  { operation, error in
                    failure?(error)
            })
    }
}