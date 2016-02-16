//
//  IngredientsTableViewController.swift
//  iosAPP
//
//  Created by MIMO on 14/2/16.
//  Copyright © 2016 mikel balduciel diaz. All rights reserved.
//

import UIKit
import CoreData
class IngredientsTableViewController: UITableViewController {
    
    var category = ""
    var ingredients = [Ingredient]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        recibir()
    }
    
    func recibir(){
        self.ingredients = []
        let myapiClient = MyAPIClient()
        myapiClient.getCategory({ (ingredient) -> () in
            self.ingredients.append(ingredient)
            }, finished: { () -> () in
                self.tableView.reloadData()
            }) { (error) -> () in
                 print("\(error.debugDescription)")
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ingredients.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ingredientCell", forIndexPath: indexPath) as! IngredientTableViewCell
    
        cell.textLabel!.text = ingredients[indexPath.row].name
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let newIngredient = ingredients[indexPath.row]
        addIngredient(newIngredient)
        assignIngredientStore(newIngredient)
    }
    
    func addIngredient(ingredient: Ingredient) {
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext

        do {
            try managedContext.save()
            ingredients.append(ingredient)
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func assignIngredientStore(ingredient: Ingredient){
        let util = Util.init()
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Store")
        let fetchRequest2 = NSFetchRequest(entityName: "Recipe")
        

        //Type = 0 -> Almacen
        let predicate = NSPredicate(format: "type == 0")
        
        fetchRequest.predicate = predicate
        
        var store: Store?
        
        do {
            let fetchResults = try managedContext.executeFetchRequest(fetchRequest)
            if(fetchResults.count == 1){
                store = fetchResults[0] as? Store
                print("Contiene")
                
            }else{
                store = util.prepareObject("Store") as? Store
                store?.type = "0"
                print("No contiene")
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        
        do {
            let fetchResults2 = try managedContext.executeFetchRequest(fetchRequest2)
            let recipe = fetchResults2[0] as? Recipe
            print(recipe?.name)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        
        
        
        
        
        
        
        store?.mutableSetValueForKey("ingredientsStore").addObject(ingredient)
        print(store?.ingredientsStore?.count)
        /*if((store!.ingredientsStore?.containsObject(ingredient)) != nil){
            print("Lo contiene")
        }else{
            print("No lo contiene")
        }*/
        
      
        
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
