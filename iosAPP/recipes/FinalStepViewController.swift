//
//  FinalStepViewController.swift
//  iosAPP
//
//  Created by mikel balduciel diaz on 22/2/16.
//  Copyright © 2016 mikel balduciel diaz. All rights reserved.
//

import UIKit

class FinalStepViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    //ingredientes seleccionados para borrar del almacen
    var ingredientsErase = [Ingredient]()
    //ingredientes que estan dentro de la receta
    var ingredientsFinish = [Ingredient]()
    // ids de los ingredientes que estan en la receta
    var ingredientsFinishIDS = [Int64]()
    //ingredientes del almacen
    var ingredientsStorage = [Ingredient]()
    //ids de los ingredientes del almacen
    var ingredientsStorageIDS = [Int64]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Final de la receta"
        do{
            ingredientsStorage = try IngredientDataHelper.findIngredientsInStorage()!
            for i in ingredientsStorage {
                ingredientsStorageIDS.append(i.ingredientIdServer)
            }
        }
        catch _ {
            print ("error al buscar ingredientes del storage")
        }
        for i in ingredientsFinishIDS {
            if !ingredientsStorageIDS.contains(i){
                ingredientsFinishIDS.removeAtIndex(ingredientsFinishIDS.indexOf(i)!)
            }
        }
        
        for id in ingredientsFinishIDS{
            do {
                let ing = try IngredientDataHelper.findIdServer(id)
                ingredientsFinish.append(ing!)
            }
            catch _ {
                print ("no se ha encontrado el ingrediente")
            }
        }
       
        
        
        self.tableView.allowsMultipleSelection = true
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ingredientsFinish.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
       let cell = self.tableView.dequeueReusableCellWithIdentifier("ingredientTrash", forIndexPath: indexPath) as! SelectIngredientTableViewCell
        
        if ingredientsFinish.count > 0 {
            let ingredient = ingredientsFinish[indexPath.row]
            cell.nameIngredientLabel.text = ingredient.name
        }
        if cell.selected
        {
            cell.selected = false
            if cell.accessoryType == UITableViewCellAccessoryType.None
            {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                
            }
            else
            {
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
        }
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)

        if cell!.selected
        {
            cell!.selected = false
            if cell!.accessoryType == UITableViewCellAccessoryType.None
            {
                cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
                ingredientsErase.append(ingredientsFinish[indexPath.row])
            }
            else
            {
                cell!.accessoryType = UITableViewCellAccessoryType.None
                let index = ingredientsFinish.indexOf(ingredientsFinish[indexPath.row])
                ingredientsErase.removeAtIndex(index!)
            }
        }
    }
    @IBAction func eraseIngredients(sender: AnyObject) {
    
        do {
            for i in ingredientsErase{
                i.storageId = 0
                try IngredientDataHelper.updateStorage(i)
            }
        }
        catch  {
            print("error al borrar ingrediente")
        }
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }

    @IBAction func finishWithoutDelete(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    
}
