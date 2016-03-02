//
//  ShoopingListViewController.swift
//  iosAPP
//
//  Created by mikel balduciel diaz on 31/1/16.
//  Copyright © 2016 mikel balduciel diaz. All rights reserved.
//

import UIKit

class ShoopingListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var table: UITableView!
    
    var ingredients = [Ingredient]()
    var sections = [[Ingredient]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.registerClass(UITableViewCell.self, forCellReuseIdentifier: "shoppingCell")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        sections.removeAll()
        do{
            ingredients = try IngredientDataHelper.findIngredientsInCart()!
            var ingredients2 = try IngredientDataHelper.findIngredientsNotInStorageCart()!
            ingredients.sortInPlace({ $0.name < $1.name })
            ingredients2.sortInPlace({ $0.name < $1.name })
            sections.append(ingredients)
            sections.append(ingredients2)
            table.reloadData()
            print("\(ingredients.count)")
        }catch _{
            print("Error al recibir los ingredientes")
        }
        
    }
    
    @IBAction func actionButton(sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if appDelegate.isConected {
            let instance = self.storyboard!.instantiateViewControllerWithIdentifier("categoryShopping") as? CategoriesViewController
            self.navigationController?.pushViewController(instance!, animated: true)
        }else{
            self.view.makeToast("No tienes conexión", duration: 2, position: .Top)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.table.dequeueReusableCellWithIdentifier("shoppingCell")!
        /*if ingredients.count > 0 {
        cell.textLabel!.text = ingredients[indexPath.row].name
        }*/
        let section = sections[indexPath.section]
        
        cell.textLabel!.text = section[indexPath.row].name
        return cell
    }
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // the cells you would like the actions to appear needs to be editable
        return indexPath.section == 0 ? true : false
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1{
            let ingredient = sections[1][indexPath.row]
            do{
                ingredient.cartId = 1
                try IngredientDataHelper.updateCart(ingredient)
                
                sections[indexPath.section].removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Top)
                
                sections[0].append(ingredient)
                sections[0].sortInPlace({ $0.name < $1.name })
                
                let index = sections[0].indexOf(ingredient)
                tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: index!, inSection: 0)], withRowAnimation: .Automatic)
                
            }catch _{
                print("Error al insertar ingrediente en storage")
            }
            
        }
    }
    func deleteIngredientStore(ingredient: Ingredient){
        do{
            ingredient.cartId = 0
            try IngredientDataHelper.updateCart(ingredient)
            print("Ingrediente eliminado del cart")
        }catch _{
            print("Error al eliminar del cart")
        }
    }
    func buyIngredientStore(ingredient: Ingredient){
        do{
            ingredient.cartId = 0
            ingredient.storageId = 1
            try IngredientDataHelper.updateCart(ingredient)
            try IngredientDataHelper.updateStorage(ingredient)
            print("Ingrediente comprado del cart")
        }catch _{
            print("Error al comprar del cart")
        }
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        /*if editingStyle == .Delete{
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
        if editingStyle == .Insert {
            var section = sections[indexPath.section]
            let ingredient = section[indexPath.row]
            sections[indexPath.section].removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Top)
            buyIngredientStore(ingredient)
        }*/

    }
   
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
       /* var buyAction  = UITableViewRowAction(style: .Normal, title: "Comprar") { (action, indexPath) -> Void in
            var section = self.sections[indexPath.section]
            let ingredient = section[indexPath.row]
            let activityViewController = UIActivityViewController(activityItems: [ingredient], applicationActivities: nil)
            self.presentViewController(activityViewController,animated: true, completion : nil)
            
        }*/
        let buyAction = UITableViewRowAction(style: .Normal, title: "Comprar") { action, index in
            var section = self.sections[indexPath.section]
            let ingredient = section[indexPath.row]
            self.sections[indexPath.section].removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Top)
            self.buyIngredientStore(ingredient)
        }
        buyAction.backgroundColor = UIColor.blueColor()
        
        let deleteAction = UITableViewRowAction(style: .Normal, title: "Borrar") { action, index in
            var section = self.sections[indexPath.section]
            let ingredient = section[indexPath.row]
            self.sections[indexPath.section].removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Top)
            self.deleteIngredientStore(ingredient)
            
            print(ingredient.name)
            self.sections[1].append(ingredient)
            self.sections[1].sortInPlace({ $0.name < $1.name })
            
            let index = self.sections[1].indexOf(ingredient)
            print(ingredient.name)
            tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: index!, inSection: 1)], withRowAnimation: .Automatic)
            
        }
        deleteAction.backgroundColor = UIColor.redColor()
        return [buyAction,deleteAction]
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0{
            return "Compra"
        }else{
            return "Histórico"
        }
    }
    
    
    
}
