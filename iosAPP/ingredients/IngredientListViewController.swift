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
    var ingredientsSection = Dictionary<String,[Ingredient]>()
    var ingredientsSection2 = Dictionary<String,[Ingredient]>()
    
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
        myapiClient.getCategory(category, ingredients: { (baseType,ingredients) -> () in
            self.ingredientsSection[baseType] = ingredients
            },finished: { () -> () in
                self.ingredientsSection2 = self.ingredientsSection
                self.table.reloadData()
            }) { (error) -> () in
                print("\(error.debugDescription)")
        }
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return ingredientsSection.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let key = Array(ingredientsSection.keys)[section]
        return key
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = Array(ingredientsSection.keys)[section]
        return (ingredientsSection[key]?.count)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.table.dequeueReusableCellWithIdentifier("ingredientCell", forIndexPath: indexPath) as! IngredientTableViewCell
        
        let key = Array(ingredientsSection.keys)[indexPath.section]
        
        cell.textLabel!.text = ingredientsSection[key]![indexPath.row].name
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let key = Array(ingredientsSection.keys)[indexPath.section]
        let newIngredient = ingredientsSection[key]![indexPath.row]
        addIngredient(key,ingredient: newIngredient)
        table.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    func addIngredient(key: String,ingredient: Ingredient) {
        
        do{
            ingredient.storageId = 1
            print(ingredient.storageId)
            let ingredientId =  try IngredientDataHelper.insert(ingredient)
            let arraySection = ingredientsSection[key]
            ingredientsSection[key]?.removeAtIndex((arraySection?.indexOf(ingredient))!)
            
            if ingredientsSection[key]!.count == 0{
                self.navigationController?.popViewControllerAnimated(true)
            }
            
            print(ingredientId)
            print(ingredient.ingredientIdServer)
        }catch _{
            print("Error al crear el ingrediente")
        }
    }
    

}
