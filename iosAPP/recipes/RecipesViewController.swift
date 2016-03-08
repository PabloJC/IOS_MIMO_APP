//
//  RecipesViewController.swift
//  iosAPP
//
//  Created by mikel balduciel diaz on 5/2/16.
//  Copyright © 2016 mikel balduciel diaz. All rights reserved.
//

import UIKit
import CoreData
class RecipesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITabBarDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UITextField!
    var recetasString = [Dictionary<String,AnyObject>]()
    var recetasStringAux = [Dictionary<String,AnyObject>]()
    var ingredients = [Ingredient]()
    var sincronized = true
    var ingredientesString = ""
    var tabItem0 : UITabBarItem!
    var tabItem1 : UITabBarItem!
    var tabItem2 : UITabBarItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
       
        setTextBt()
        
        loadIngredientsStorage()
        recibirTodas()
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        searchBar.resignFirstResponder()
        return true
    }
    
    
    func setTextBt(){
         title = NSLocalizedString("RECETAS",comment:"Recetas")
        self.searchBar.placeholder = NSLocalizedString("BUSQUEDA",comment:"Busqueda")
        let tabItems = self.tabBar.items! as [UITabBarItem]
        tabItem0 = tabItems[0] as UITabBarItem
       tabItem1 = tabItems[1] as UITabBarItem
        tabItem2 = tabItems[2] as UITabBarItem
        tabItem0.title = NSLocalizedString("TOTAL",comment:"Total")
        tabItem1.title = NSLocalizedString("FAVORITOS",comment:"Favoritos")
        tabItem2.title = NSLocalizedString("POSIBLES",comment:"Posibles")
        
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
            cell!.textLabel?.lineBreakMode = .ByWordWrapping
            cell!.textLabel?.font = UIFont.systemFontOfSize(15)
            cell!.textLabel?.numberOfLines = 2
            cell!.textLabel?.textAlignment = .Center
        }
        cell!.addBorderBottom(size: 0.5, color: UIColor(red: 78, green: 159, blue: 255, alpha: 0))
        cell!.backgroundColor = UIColor.whiteColor()
        
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
    func order(){
        self.recetasString.sortInPlace{
            (($0 )["name"] as? String) < (($1 )["name"] as? String)
        }
    }
    func recibir(){
        self.recetasString = []
        self.tableView.reloadData()
        let myapiClient = MyAPIClient()
        self.activityIndicator.startAnimating()
         self.view.makeToastActivity(.Center)
        myapiClient.getRecipesIngredients(ingredientesString, recipes: { (receta, id) -> () in
           
            var post=Dictionary<String,AnyObject>()
            post = ["id":id,"name":receta]
            
            self.recetasString.append(post)
            
            }, finished: { () -> () in
                
                self.view.hideToastActivity()
                self.recetasStringAux = self.recetasString
                if !self.recetasString.isEmpty {
                    self.order()
                    self.tableView.reloadData()
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidden = true
                }else {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidden = true
                    
                    print("sin recetas agregadas")
                }
               self.sincronized = true
                
            }) { (error) -> () in
                print("\(error.debugDescription)")
        }
    }
    func recibirTodas(){
        self.recetasString = []
        self.tableView.reloadData()
        let myapiClient = MyAPIClient()
        self.activityIndicator.startAnimating()
        self.view.makeToastActivity(.Center)
        myapiClient.getRecipes({ (receta,id) -> () in
            
            var post=Dictionary<String,AnyObject>()
            post = ["id":id,"name":receta]
            self.recetasString.append(post)
            }, finished: { () -> () in
                
                self.view.hideToastActivity()
                self.recetasStringAux = self.recetasString
                if !self.recetasString.isEmpty {
                    self.order()
                    self.sincronized = true
                    self.tableView.reloadData()
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidden = true
                }else {
                    print("sin recetas agregadas")
                }
                self.sincronized = true
                
            }) { (error) -> () in
                print("\(error.debugDescription)")
        }
        
    }
    
    func recibirFavoritos(){
        self.recetasString = []
        self.tableView.reloadData()
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
                self.order()
                self.sincronized = true
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidden = true
            }else {
                print("sin recetas agregadas")
            }
           self.sincronized = true
        }catch _ {
            print("error al recibir favoritos")
        }
        
    }
    
    @IBAction func searchAction2(sender: UITextField) {
        self.recetasString = self.recetasStringAux
        if !sender.text!.isEmpty {
            recetasString = self.recetasString.filter({ (recipe) -> Bool in
                recipe["name"]!.lowercaseString.rangeOfString(sender.text!.lowercaseString) != nil
                
            })
        }
        tableView.reloadData()
    }
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        view.hideToastActivity()
        switch item.tag{
        case 1:
            print ("Todas")
            if sincronized {
                sincronized = false
                
                recibirTodas()
                self.tableView.reloadData()
                
            }
            
            break
        case 2:
            print ("Favoritas")
            if sincronized {
                sincronized = false
               recibirFavoritos()
            }
            
            
            break
        default:
             print ("Posibles")
             if sincronized {
                sincronized = false
                
                recibir()
                self.tableView.reloadData()
             }
             
            break
        }
    }
    
    
}
