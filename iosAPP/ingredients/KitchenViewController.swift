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
    

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var myKitchen: UITableView!
    @IBOutlet weak var addIngredient: UIButton!

    @IBOutlet weak var titleLabel: UILabel!
    var ingredients = [Ingredient]()
    var sections = [[Ingredient]]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
          setText()
        self.myKitchen.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Ingredient")
        let background = CAGradientLayer().blueToWhite()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, atIndex: 0)
    }
   func setText(){
        titleLabel.text = NSLocalizedString("TUSINGREDIENTES",comment:"Tus Ingredientes")
        addIngredient.setTitle(NSLocalizedString("AÑADIRINGREDIENTE",comment:"Añadir Ingrediente"), forState: .Normal)
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.addBorderBottom(size: 1, color: UIColor.blackColor())
        header.textLabel?.textAlignment = .Center
        
    }


    
    
    @IBAction func actionButton(sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if appDelegate.isConected {
            let instance = self.storyboard!.instantiateViewControllerWithIdentifier("categoryView") as? IngredientsViewController
            self.navigationController?.pushViewController(instance!, animated: true)
        }else{
            self.view.makeToast(NSLocalizedString("SINCONEXION",comment:"No tienes conexión"), duration: 2, position: .Top)
        }
    }


    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if titleLabel != nil {
        sections.removeAll()
        do{
            var ingredients1 = try IngredientDataHelper.findIngredientsInStorage()!
            var ingredients2 = try IngredientDataHelper.findIngredientsNotInStorage()!
            ingredients1.sortInPlace({ $0.name < $1.name })
            ingredients2.sortInPlace({ $0.name < $1.name })
            sections.append(ingredients1)
            sections.append(ingredients2)
            myKitchen.reloadData()
        }catch _{
            print("Error al recibir los ingredientes")
            }
        }


    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.myKitchen.dequeueReusableCellWithIdentifier("Ingredient")!
        
        let section = sections[indexPath.section]
        cell.addBorderBottom(size: 0.5, color: UIColor(red: 78, green: 159, blue: 255, alpha: 0))
        cell.backgroundColor = UIColor.whiteColor()
        cell.textLabel!.text = section[indexPath.row].name
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1{
            let ingredient = sections[1][indexPath.row]
            do{
                try Ingredient.updateIngredientStorage(ingredient)
                
                sections[indexPath.section].removeAtIndex(indexPath.row)
                myKitchen.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Top)
                
                sections[0].append(ingredient)
                sections[0].sortInPlace({ $0.name < $1.name })
                
                let index = sections[0].indexOf(ingredient)
                myKitchen.insertRowsAtIndexPaths([NSIndexPath(forRow: index!, inSection: 0)], withRowAnimation: .Automatic)

            }catch _{
                print("Error al insertar ingrediente en storage")
            }
            
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func deleteIngredientStore(ingredient: Ingredient){
        do{
            try Ingredient.deleteIngredientStorage(ingredient)
        }catch _{
            print("Error al eliminar del storage")
        }
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        var res = false
        if indexPath.section == 0{
            res = true
        }
        return res
    }
    
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete{
            var section = sections[indexPath.section]
            let ingredient = section[indexPath.row]
            sections[indexPath.section].removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Top)
            deleteIngredientStore(ingredient)
            sections[1].append(ingredient)
            sections[1].sortInPlace({ $0.name < $1.name })
            
            let index = sections[1].indexOf(ingredient)
            tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: index!, inSection: 1)], withRowAnimation: .Automatic)
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        if section == 0{
            return NSLocalizedString("ALMACEN",comment:"Almacén")
        }else{
            return NSLocalizedString("HISTORICO",comment:"Histórico")
        }
    }

}
