//
//  IngredientListViewController.swift
//  iosAPP
//
//  Created by MIMO on 18/2/16.
//  Copyright © 2016 mikel balduciel diaz. All rights reserved.
//

import UIKit

class IngredientListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var table: UITableView!
    
    
    var category = ""
    var ingredients = [Ingredient]()
    
    var ingredients2 = [Ingredient]()
    
    @IBAction func search(sender: UITextField) {
        ingredients = ingredients2
        if !sender.text!.isEmpty {
            ingredients = ingredients.filter { (ingredient) -> Bool in
            ingredient.name.lowercaseString.rangeOfString(sender.text!.lowercaseString) != nil
            }
        }
        table.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        recibir()
        
        // Do any additional setup after loading the view.
    }
    
    func recibir(){
        let myapiClient = MyAPIClient()
        myapiClient.getCategory(category, ingredients: { (ingredient) -> () in
            self.ingredients.append(ingredient)
            }, finished: { () -> () in
                self.ingredients2 = self.ingredients
                self.table.reloadData()
            }) { (error) -> () in
                print("\(error.debugDescription)")
        }
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.table.dequeueReusableCellWithIdentifier("ingredientCell", forIndexPath: indexPath) as! IngredientTableViewCell
        
        cell.textLabel!.text = ingredients[indexPath.row].name
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let newIngredient = ingredients[indexPath.row]
        addIngredient(newIngredient)
        table.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    func addIngredient(ingredient: Ingredient) {
        
        do{
            ingredient.storageId = 1
            print(ingredient.storageId)
            let ingredientId =  try IngredientDataHelper.insert(ingredient)
            ingredients.removeAtIndex(ingredients.indexOf(ingredient)!)
            print(ingredientId)
            print(ingredient.ingredientIdServer)
        }catch _{
            print("Error al crear el ingrediente")
        }
    }

}
