//
//  RecipesViewController.swift
//  iosAPP
//
//  Created by mikel balduciel diaz on 5/2/16.
//  Copyright © 2016 mikel balduciel diaz. All rights reserved.
//

import UIKit
import CoreData
class RecipesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var recetasString = [Dictionary<String,AnyObject>]()
    var recetasStringAux = [Dictionary<String,AnyObject>]()
    var ingredients = [Ingredient]()
    var sincronized = false
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\"Recetas\""
        if !sincronized {
            recibir()
        }
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        
        tableView.reloadData()
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
        if (segue.identifier == "recipe") {
            let svc = segue.destinationViewController as! RecipeViewController
            let row = tableView.indexPathForSelectedRow?.row
            let recipe = recetasString[row!]
            svc.idText = "\(recipe["id"]!)"
            svc.ingredients = ingredients
            // print("dentro")
            
        }
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
        var ingredientesString = ""
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
    
    
}
