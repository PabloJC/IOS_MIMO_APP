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
    var sections = [[Ingredient]]()
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

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        sections.removeAll()
        do{
            var ingredients1 = try IngredientDataHelper.findIngredientsInStorage()!
            var ingredients2 = try IngredientDataHelper.findIngredientsNotInStorage()!
            ingredients1.sortInPlace({ $0.name < $1.name })
            ingredients2.sortInPlace({ $0.name < $1.name })
            sections.append(ingredients1)
            sections.append(ingredients2)
            myKitchen.reloadData()
            print("\(ingredients.count)")
        }catch _{
            print("Error al recibir los ingredientes")
        }


    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.myKitchen.dequeueReusableCellWithIdentifier("Ingredient")!
        
        let section = sections[indexPath.section]
        
        cell.textLabel!.text = section[indexPath.row].name
        
        return cell
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addIngredient(ingredient: Ingredient) {
        
        do{
            ingredient.storageId = 1
            ingredientId =  try IngredientDataHelper.insert(ingredient)
            
            
            sections[0].append(ingredient)
            sections[0].sortInPlace({ $0.name < $1.name })
            
            let index = sections[0].indexOf(ingredient)
            myKitchen.insertRowsAtIndexPaths([NSIndexPath(forRow: index!, inSection: 0)], withRowAnimation: .Automatic)

            print(ingredientId)
            print(ingredient.ingredientIdServer)
        }catch _{
            print("Error al crear el ingrediente")
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
        if indexPath.section == 0{
            return true
        }else{
            return false
        }
    }
    
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete{
            var section = sections[indexPath.section]
            let ingredient = section[indexPath.row]
            sections[indexPath.section].removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Top)
            deleteIngredientStore(ingredient)
            
            print(ingredient.name)
            sections[1].append(ingredient)
            sections[1].sortInPlace({ $0.name < $1.name })
            
            let index = sections[1].indexOf(ingredient)
            print(ingredient.name)
            tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: index!, inSection: 1)], withRowAnimation: .Automatic)
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        if section == 0{
            return "Almacén"
        }else{
            return "Histórico"
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
