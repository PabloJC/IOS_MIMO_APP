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
                
                do{
                    try IngredientDataHelper.insert(ingredient)
                    print("Ingrediente Agregado")
                    print(ingredient.ingredientIdServer)
                }catch _{
                    print("Error al crear el ingrediente")
                }
                
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
