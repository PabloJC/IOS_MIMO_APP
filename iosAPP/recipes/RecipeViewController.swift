//
//  RecipeViewController.swift
//  iosAPP
//
//  Created by mikel balduciel diaz on 11/2/16.
//  Copyright © 2016 mikel balduciel diaz. All rights reserved.
//

import UIKit
import CoreData
class RecipeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var nombreReceta: UILabel!
    @IBOutlet weak var TextBox: UITextView!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    var missingIngredients = [Ingredient]()
    var storedIngredients = [Ingredient]()
    var sections = [[Ingredient]]()
    var idText = ""
    var nombreText = ""
    var recipe : Recipe?
    var ingredients = [Ingredient]()
    var ingredientsBDServerId = [Int64]()
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "ingredientCell")
        recibir()
        id.text = idText
        for iBD in self.ingredients {
            ingredientsBDServerId.append(iBD.ingredientIdServer)
        }
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func recibir(){
        let myapiClient = MyAPIClient()
        
        myapiClient.getrecipe(idText, recipe2: { (r) -> () in
            
            self.nombreReceta.text  = "\(r.name)"
            if r.photo != "" {
                let url = NSURL(string: r.photo)
                let data = NSData(contentsOfURL: url!)
                self.imageView.image = UIImage(data: data!)
            }
            
            var texto = ""
            self.recipe = r
            for i in r.measures{
                let i2 = i
                if self.ingredientsBDServerId.contains(i2.ingredient.ingredientIdServer) {
                    i2.ingredient.storageId = 1
                    self.storedIngredients.append(i2.ingredient)
                    //texto += "\(i2.ingredient.name)" + "\(i2.quantity)" + (i2.measure) + "\n"
                }else {
                    do {
                        var iBD = try IngredientDataHelper.findIdServer(i2.ingredient.ingredientIdServer)
                        if iBD == nil {
                            try IngredientDataHelper.insert(i2.ingredient)
                            iBD = try IngredientDataHelper.findIdServer(i2.ingredient.ingredientIdServer)
                        }
                        self.missingIngredients.append(iBD!)
                    }catch _ {
                        
                    }
                    
                    //texto += "Falta el ingrediente \(i2.ingredient.name) \n"
                }
            }
            self.sections.append(self.storedIngredients)
            self.sections.append(self.missingIngredients)
            self.tableView.reloadData()
            //self.TextBox.text = texto
            }, finished: { () -> () in

            }) { (error) -> () in
                print("\(error.debugDescription)")
        }
        
        
    }
    @IBAction func prepareRecipeAction(sender: AnyObject) {
        print (recipe?.tasks.count)
        if recipe?.tasks.count != 0 {
           self.performSegueWithIdentifier("step", sender: self)
        }else{
             self.performSegueWithIdentifier("finalRecipeSegue", sender: self)
        }
        
        
    }
    @IBAction func stepListAction(sender: AnyObject) {
        self.performSegueWithIdentifier("stepList", sender: self)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "step" {
            let stepDestination = segue.destinationViewController as! StepViewController
            stepDestination.recipe = recipe
        } 
        else if segue.identifier == "stepList" {
            let stepListDestination = segue.destinationViewController as! StepListViewController
            stepListDestination.recipe = recipe
        }else {
            let svc = segue.destinationViewController as! FinalStepViewController
            var ingredientsFinish = [Int64]()
            for m in (self.recipe?.measures)!{
                ingredientsFinish.append(m.ingredient.ingredientIdServer)
            }
            svc.ingredientsFinishIDS = ingredientsFinish
        }
    }
    
    //MARK - Table
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
         let cell = self.tableView.dequeueReusableCellWithIdentifier("ingredientCell", forIndexPath: indexPath) as! RecipeIngredientTableViewCell
        let section = sections[indexPath.section]
        
        cell.nameIngredientLabel!.text = section[indexPath.row].name
        if section[indexPath.row].cartId == 1 {
            cell.stateLabel.text = "Pendiente de compra"
        }else if section[indexPath.row].cartId == 0 && section[indexPath.row].storageId == 0{
            cell.stateLabel.text = "Sin unidades"
        }else {
            cell.stateLabel.text = "Producto en almacen"
        }
        return cell
    }
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // the cells you would like the actions to appear needs to be editable
        return indexPath.section == 1 ? true : false
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        /*if indexPath.section == 1{
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
            
        }*/
    }
    func buyIngredientStore(ingredient: Ingredient){
        do{
            var ingredientToModify = try IngredientDataHelper.findIdServer(ingredient.ingredientIdServer)
            if ingredientToModify == nil {
                try IngredientDataHelper.insert(ingredient)
                ingredientToModify = try IngredientDataHelper.findIdServer(ingredient.ingredientIdServer)
            }
            ingredientToModify?.cartId = 1
            try IngredientDataHelper.updateCart(ingredientToModify!)
            print("Ingrediente añadido al cart")
        }catch _{
            print("Error al añadir al cart")
        }
    }
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let buyAction = UITableViewRowAction(style: .Normal, title: "Comprar") { action, index in
            var section = self.sections[indexPath.section]
            let ingredient = section[indexPath.row]
            self.sections[indexPath.section].removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Top)
            self.buyIngredientStore(ingredient)
        }
        return [buyAction]
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0{
            return "En almacen"
        }else{
            return "Falta"
        }
    }

    
}
