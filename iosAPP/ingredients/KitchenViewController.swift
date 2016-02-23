//
//  KitchenViewController.swift
//  iosAPP
//
//  Created by MIMO on 14/2/16.
//  Copyright © 2016 mikel balduciel diaz. All rights reserved.
//

import UIKit
import CoreData
class KitchenViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    

    @IBOutlet weak var myKitchen: UITableView!
    
    var ingredients = [Ingredient]()
    var ingredientId : Int64!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.myKitchen.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Ingredient")
    }
    
    @IBAction func storeIngredient(sender: UIButton) {
        let alert = UIAlertController(title: "Nuevo Ingrediente",
            message: "Añade un ingrediente",
            preferredStyle: .Alert)
        let saveAction = UIAlertAction(title: "Almacenar",
            style: .Default,
            handler: { (action:UIAlertAction) -> Void in
                print("Almacenar")
                
                let ingredient = Ingredient()
                ingredient.name = (alert.textFields!.first?.text!)!
                self.addIngredient(ingredient)
                self.assignIngredientStore(ingredient)
                
                
        })
        
        let cancelAction = UIAlertAction (title: "Cancelar",
            style: .Default,
            handler: { (action:UIAlertAction) -> Void in
                print("Cancelar")
        })
        
        alert.addTextFieldWithConfigurationHandler { (textField: UITextField) -> Void in
            
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)
        
    }

    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        do{
            ingredients = try IngredientDataHelper.findIngredientsInStorage()!
            myKitchen.reloadData()
            print("\(ingredients.count)")
        }catch _{
            print("Error al recibir los ingredientes")
        }

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ingredients.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.myKitchen.dequeueReusableCellWithIdentifier("Ingredient")!
        
       let ingredient = self.ingredients[indexPath.row] 
       cell.textLabel?.text =  ingredient.name
        
        return cell
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addIngredient(ingredient: Ingredient) {
        
        do{
            ingredientId =  try IngredientDataHelper.insert(ingredient)
            print(ingredientId)
            print(ingredient.ingredientIdServer)
        }catch _{
            print("Error al crear el ingrediente")
        }
    }
    
    func assignIngredientStore(ingredient: Ingredient){
        
        do{
            ingredient.ingredientId = ingredientId
            ingredient.storageId = 1
            try IngredientDataHelper.updateStorage(ingredient)
            self.ingredients.append(ingredient)
            self.myKitchen.reloadData()
            print("Ingrediente almacenado")
        }catch _{
            print("Error al almacenar")
        }
    }
    
    func deleteIngredientStore(ingredient: Ingredient){
        do{
            ingredient.storageId = 0
            try IngredientDataHelper.updateStorage(ingredient)
            print("Ingrediente eliminado del storage")
        }catch _{
            print("Error al eliminar del storage")
        }
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete{
            let ingredient = self.ingredients[indexPath.row]
            ingredients.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Top)
            deleteIngredientStore(ingredient)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
