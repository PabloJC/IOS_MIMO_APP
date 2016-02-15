

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
            
            let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
            
            let managedContext = appDelegate.managedObjectContext
            
            //2
            let entity =  NSEntityDescription.entityForName("Recipe",
                inManagedObjectContext:managedContext)
            
            let recipe = NSManagedObject(entity: entity!,
                insertIntoManagedObjectContext: managedContext)
            //3
            
            let url = "/recipes/\(idRecipe)"
            self.GET(url,
                parameters: nil,
                progress: nil,
                success: { operation, responseObject in
                    
                    let result = responseObject! as! [String:AnyObject]
                    print("\(result)")
                    let name = result["name"]
                    let id = result["id"]
                    let portions = result["portions"]
                    recipe.setValue(id, forKey: "recipeID")
                    recipe.setValue(name, forKey: "name")
                    recipe.setValue(portions, forKey: "portions")
                    recipe2!((recipe as? Recipe)!)
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