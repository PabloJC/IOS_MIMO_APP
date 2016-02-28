//
//  ViewController.swift
//  iosAPP
//
//  Created by mikel balduciel diaz on 31/1/16.
//  Copyright © 2016 mikel balduciel diaz. All rights reserved.
//

import UIKit
class ViewController: UIViewController, UITabBarDelegate {
    @IBOutlet weak var back: UIView!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var imageRecipe: UIImageView!
    @IBOutlet weak var labelRecipe: UILabel!

    var externalStoryboard: UIStoryboard!
    var post=Dictionary<String,AnyObject>()
    var ingredients = [Ingredient]()
    var ingredientesString = ""
    var recipeSegue :Recipe?
    override func viewDidLoad() {
        
        super.viewDidLoad()
        back.layer.cornerRadius = 5
        
        let dataStore = SQLiteDataStore.sharedInstance
        do{
            try dataStore.createTables()
            
            if try StorageDataHelper.find(1) == nil {
                
            let  S = Storage()
             let id = try  StorageDataHelper.insert(S)
                print ("storage creado \(id)" )
                
            }
            if try CartDataHelper.find(1) == nil {
                
                let  C = Cart()
                let id = try  CartDataHelper.insert(C)
                print ("cart creado \(id)" )
                
            }
            
        
        }catch _ {
            print ("error insert")
        }
        print ("Finish")
        
        do {
            ingredients = try IngredientDataHelper.findIngredientsInStorage()!
            if self.ingredients.count == 0{
                ingredientesString = "0"
            }
            for ing in ingredients {
                let io = ing
                let id = String(io.ingredientIdServer)
                ingredientesString  += id  + ",";
            }
            //print(ingredientesString)
        } catch _ {
            print ("error al coger los ingredientes del almacen")
        }
        recibirFavoritos()
        cargarView()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("backTapped:"))
        back.userInteractionEnabled = true
        back.addGestureRecognizer(tapGestureRecognizer)
        // Do any additional setup after loading the view, typically from a nib.
    }
    func cargarView(){
        
        print("imagen pulsada")
        do {
            if post["id"] != nil {
                let id = post["id"]
                let recipe = try RecipeDataHelper.findIdServer(Int64(id as! Int))
                if recipe != nil {
                    recipeSegue = createRecipe(recipe!)
                }
                if recipeSegue!.photo != "" && Reachability.isConnectedToNetwork() {
                    let url = NSURL(string: recipe!.photo)
                    let data = NSData(contentsOfURL: url!)
                    self.imageRecipe.image = UIImage(data: data!)
                }
                self.labelRecipe.text = recipeSegue?.name
            }
            
            
        }
        catch _ {
            print("fallo al recuperar la receta")
        }

    }
    func backTapped(img: AnyObject)
    {
            print("bd")
            externalStoryboard = UIStoryboard(name: "Recipe", bundle: nil)
            let secondViewController = externalStoryboard.instantiateViewControllerWithIdentifier("recipe") as! RecipeViewController
            secondViewController.recipe = recipeSegue
            secondViewController.ingredients = ingredients
            self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        switch item.tag{
        case 1:
            externalStoryboard = UIStoryboard(name: "ShoppingListSB", bundle: nil)
            let shoppingListInstance = externalStoryboard.instantiateViewControllerWithIdentifier("shoppingListID") as? ShoopingListViewController
            self.navigationController?.pushViewController(shoppingListInstance!, animated: true)
            break
        case 2:
            externalStoryboard = UIStoryboard(name: "Recipe", bundle: nil)
            let listRecipeInstance = externalStoryboard.instantiateViewControllerWithIdentifier("ListRecipes") as? RecipesViewController
            self.navigationController?.pushViewController(listRecipeInstance!, animated: true)

            break
        default:
            externalStoryboard = UIStoryboard(name: "IngredientsSB", bundle: nil)
            let ingredientListInstance = externalStoryboard.instantiateViewControllerWithIdentifier("KitchenViewID") as? KitchenViewController
            self.navigationController?.pushViewController(ingredientListInstance!, animated: true)

            break
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func recibirFavoritos(){
        
        var recipe : Recipe?
        do {
            let recipes = try RecipeDataHelper.findAllFavorites()! as [Recipe]
            if recipes.count != 0 {
                var idString = NSNumber(double: Double((recipes[0].recipeIdServer)))
                post = ["id":idString,"name":(recipes[0].name)]
            }
            
             
        }catch _ {
            print("error al recibir favoritos")
        }
        
    }
    func createRecipe(recipe: Recipe) -> Recipe{
        var recipeTMI: Recipe?
        var measuresArray = [MeasureIngredients]()
        
        do{
            recipeTMI = recipe
            let tasks = try TaskDataHelper.findAllRecipe(recipe.recipeIdServer)! as [Task]
            recipeTMI!.tasks = tasks
            let measures = try MeasureDataHelper.findAllRecipe(recipe.recipeIdServer)! as [MeasureIngredients]
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
 


}

