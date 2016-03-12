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
    
    @IBOutlet weak var randomBt: UIButton!
    
    var externalStoryboard: UIStoryboard!
    var post=Dictionary<String,AnyObject>()
    var ingredients = [Ingredient]()
    var ingredientesString = ""
    var recipeSegue :Recipe?
    var recipes :[Recipe]?
    var random = 0
    override func viewDidLoad() {
        
        super.viewDidLoad()
        back.layer.cornerRadius = 5
        setTextBt()
        initDB()
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("backTapped:"))
        back.userInteractionEnabled = true
        back.addGestureRecognizer(tapGestureRecognizer)
        
        let background = CAGradientLayer().blueToWhite()
        background.frame = self.view.bounds
        
        self.view.layer.insertSublayer(background, atIndex: 0)
        imageRecipe.layer.masksToBounds = true
        imageRecipe.layer.cornerRadius = 5.0
    }
    override func viewWillAppear(animated: Bool) {
        ingredientsStorage()
        recibirFavoritos()
        cargarView()
    }
    func setTextBt(){
        randomBt.setTitle(NSLocalizedString("RANDOM",comment:"Aleatorio"), forState: .Normal)
    }
    func initDB(){
        let dataStore = SQLiteDataStore.sharedInstance
        do{
            try dataStore.createTables()
            Storage.initStorage()
            Cart.initCart()
        }catch _ {
            print ("error insert")
        }
        print ("Finish")
    }
    func ingredientsStorage(){
        do {
            ingredients = try IngredientDataHelper.findIngredientsInStorage()!
        } catch _ {
            print ("error al coger los ingredientes del almacen")
        }
    }
    func cargarView(){
        do {
            if post["id"] != nil {
                let id = post["id"]
                let recipe = try RecipeDataHelper.findIdServer(Int64(id as! Int))
                if recipe != nil {
                    recipeSegue = createRecipe(recipe!)
                }
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                if recipeSegue!.photo != "" && appDelegate.isConected {
                    let url = NSURL(string: recipe!.photo)
                     self.imageRecipe.sd_setImageWithURL(url, placeholderImage: UIImage(named: "sinImagen"))
                    /*if let data = NSData(contentsOfURL: url!) {
                        self.imageRecipe.image = UIImage(data: data)
                    }*/
                }else {
                    self.imageRecipe.image = UIImage(named: "sinImagen")
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
        if recipeSegue != nil {
            externalStoryboard = UIStoryboard(name: "Recipe", bundle: nil)
            let secondViewController = externalStoryboard.instantiateViewControllerWithIdentifier("recipe") as! RecipeViewController
            secondViewController.recipe = recipeSegue
            secondViewController.ingredients = ingredients
            self.navigationController?.pushViewController(secondViewController, animated: true)
        }
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
    func recibirFavoritos(){
        
        do {
            recipes = try RecipeDataHelper.findAllFavorites()! as [Recipe]
            if recipes!.count != 0 {
                
                var randomAux = Int(arc4random_uniform(UInt32(recipes!.count)))
                while random == randomAux && recipes?.count > 1{
                    randomAux = Int(arc4random_uniform(UInt32(recipes!.count)))
                }
                random = randomAux
                let idString = NSNumber(double: Double((recipes![random].recipeIdServer)))
                post = ["id":idString,"name":(recipes![random].name)]
            }
            
             
        }catch _ {
            print("error al recibir favoritos")
        }
        
    }
    @IBAction func randomAction(sender: AnyObject) {
        
        recibirFavoritos()
        cargarView()

    }
    func createRecipe(recipe: Recipe) -> Recipe{
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
 


}

