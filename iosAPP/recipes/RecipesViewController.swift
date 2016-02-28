//
//  RecipesViewController.swift
//  iosAPP
//
//  Created by mikel balduciel diaz on 5/2/16.
//  Copyright © 2016 mikel balduciel diaz. All rights reserved.
//

import UIKit
import CoreData
class RecipesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITabBarDelegate {
    
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var recetasString = [Dictionary<String,AnyObject>]()
    var recetasStringAux = [Dictionary<String,AnyObject>]()
    var ingredients = [Ingredient]()
    var sincronized = false
    var ingredientesString = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\"Recetas\""
        
        
        loadIngredientsStorage()
        recibirFavoritos()
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        
        tableView.reloadData()
    }
    func loadIngredientsStorage(){
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
    }
    
    //MARK : UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return recetasString.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")

        if recetasString.count > 0 {
            let recipe = recetasString[indexPath.row]
            cell!.textLabel!.text = recipe["name"] as? String
        }
        
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("recipe", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let recipeSegue: Recipe?
        if (segue.identifier == "recipe") {
            let svc = segue.destinationViewController as! RecipeViewController
            let row = tableView.indexPathForSelectedRow?.row
            let recipeRow = recetasString[row!]
            do {
                let id = recipeRow["id"]
               let recipe = try RecipeDataHelper.findIdServer(Int64(id as! Int))
                if recipe != nil {
                    print("bd")
                  recipeSegue = createRecipe(recipe!)
                    svc.recipe = recipeSegue
                     svc.ingredients = ingredients
                }else {
                    print("server")
                    svc.idText = "\(recipeRow["id"]!)"
                    svc.ingredients = ingredients
                }
            }catch _ {
                print ("error al buscar la receta")
            }
        }
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
    
    
    @IBAction func saveRecipeAction(sender: AnyObject) {
        
        /* let alert = UIAlertController(title: "New Recipe",
        message: "Add a new recipe",
        preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save",
        style: .Default,
        handler: { (action:UIAlertAction) -> Void in
        
        let textField = alert.textFields!.first
        self.save(textField!.text!)
        self.tableView.reloadData()
        
        })
        
        let cancelAction = UIAlertAction (title: "Cancel",
        style: .Default,
        handler: { (action:UIAlertAction) -> Void in
        })
        
        alert.addTextFieldWithConfigurationHandler { (textField: UITextField) -> Void in
        
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)*/
        
    }
    
    func recibir(){
        self.recetasString = []
        let myapiClient = MyAPIClient()
        self.activityIndicator.startAnimating()
        
        myapiClient.getRecipesIngredients(ingredientesString, recipes: { (receta, id) -> () in
            var post=Dictionary<String,AnyObject>()
            post = ["id":id,"name":receta]
            
            self.recetasString.append(post)
            
            }, finished: { () -> () in
                self.recetasStringAux = self.recetasString
                if !self.recetasString.isEmpty {
                    self.sincronized = true
                    self.tableView.reloadData()
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidden = true
                }else {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidden = true
                    
                    print("sin recetas agregadas")
                }
            }) { (error) -> () in
                print("\(error.debugDescription)")
        }
    }
    func recibirTodas(){
        self.recetasString = []
        let myapiClient = MyAPIClient()
        self.activityIndicator.startAnimating()
        myapiClient.getRecipes({ (receta,id) -> () in
            var post=Dictionary<String,AnyObject>()
            post = ["id":id,"name":receta]
            self.recetasString.append(post)
            }, finished: { () -> () in
                self.recetasStringAux = self.recetasString
                if !self.recetasString.isEmpty {
                    self.sincronized = true
                    self.tableView.reloadData()
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidden = true
                }else {
                    print("sin recetas agregadas")
                }
                
            }) { (error) -> () in
                print("\(error.debugDescription)")
        }
        
    }
    
    func recibirFavoritos(){
        self.recetasString = []
        self.activityIndicator.startAnimating()
        var recipe : Recipe?
        do {
            let recipes = try RecipeDataHelper.findAllFavorites()! as [Recipe]
            for r in recipes {
                recipe = r
                var post=Dictionary<String,AnyObject>()
                let idString = NSNumber(double: Double((recipe?.recipeIdServer)!))
                post = ["id":idString,"name":(recipe?.name)!]
                self.recetasString.append(post)
            }
            self.recetasStringAux = self.recetasString
            if !self.recetasString.isEmpty {
                self.sincronized = true
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidden = true
            }else {
                print("sin recetas agregadas")
            }
            
        }catch _ {
            print("error al recibir favoritos")
        }
        
    }
    @IBOutlet weak var searchBar: UITextField!
    @IBAction func searchAction2(sender: UITextField) {
        self.recetasString = self.recetasStringAux
        if !sender.text!.isEmpty {
            recetasString = self.recetasString.filter({ (recipe) -> Bool in
                recipe["name"]!.lowercaseString.rangeOfString(sender.text!.lowercaseString) != nil
                
            })
        }
        tableView.reloadData()
    }
    @IBAction func recetasDisponiblesAction(sender: UIButton) {
        
        recibir()
        self.tableView.reloadData()
    }
    @IBAction func todasLasRecetasAction(sender: UIButton) {
        recibirTodas()
        self.tableView.reloadData()
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        switch item.tag{
        case 1:
            print ("Todas")
            recibirTodas()
            self.tableView.reloadData()
            break
        case 2:
            print ("Favoritas")
            recibirFavoritos()
            
            break
        default:
             print ("Posibles")
             recibir()
             self.tableView.reloadData()
            break
        }
    }
    
    
}
