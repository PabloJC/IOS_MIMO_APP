//
//  IngredientsCartViewController.swift
//  iosAPP
//
//  Created by mikel balduciel diaz on 24/2/16.
//  Copyright © 2016 mikel balduciel diaz. All rights reserved.
//

import UIKit

class IngredientsCartViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var searchTv: UITextField!
    
    var category = ""
    var ingredients = [Ingredient]()
    var ingredientsSection = Dictionary<String,[Ingredient]>()
    var ingredientsSection2 = Dictionary<String,[Ingredient]>()
    
    var ingredients2 = [Ingredient]()
    
    @IBAction func search(sender: UITextField) {
        ingredientsSection = ingredientsSection2
        if !sender.text!.isEmpty {
            
            for i in ingredientsSection.keys{
                let ingredients = ingredientsSection[i]
                ingredientsSection[i] =  ingredients!.filter({ (ingredient) -> Bool in
                    ingredient.name.lowercaseString.rangeOfString(sender.text!.lowercaseString) != nil
                })
                if(ingredientsSection[i]?.count == 0){
                    ingredientsSection.removeValueForKey(i)
                }
            }
            
        }
        table.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        recibir()
        setText()
        searchTv.delegate = self
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        searchTv.resignFirstResponder()
        return true
    }
    func setText(){
        self.searchTv.placeholder = NSLocalizedString("BUSCARINGREDIENTE",comment:"Buscar Ingrediente")
    }
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textAlignment = .Center
    }
    
    func recibir(){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
         self.view.makeToastActivity(.Center)
        if appDelegate.isConected {
            let myapiClient = MyAPIClient()
            myapiClient.getCategory(category, ingredients: { (baseType,ingredients) -> () in
                self.ingredientsSection[baseType] = ingredients
                },finished: { () -> () in
                    self.ingredientsSection2 = self.ingredientsSection
                    self.table.reloadData()
                    self.view.hideToastActivity()
                }) { (error) -> () in
                    print("\(error.debugDescription)")
            }
        }else{
            print("No hay conexión")
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
        let cell = self.table.dequeueReusableCellWithIdentifier("ingredientCell", forIndexPath: indexPath) as! IngredientCartTableViewCell
        
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
            try Ingredient.addIngredientCart(ingredient)
            let arraySection = ingredientsSection[key]
            ingredientsSection[key]?.removeAtIndex((arraySection?.indexOf(ingredient))!)
            
            if ingredientsSection[key]!.count == 0{
                self.navigationController?.popViewControllerAnimated(true)
            }
        }catch _{
            print("Error al crear el ingrediente")
        }
    }

}
