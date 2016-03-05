//
//  RecipeViewController.swift
//  iosAPP
//
//  Created by mikel balduciel diaz on 11/2/16.
//  Copyright © 2016 mikel balduciel diaz. All rights reserved.
//

import UIKit
import CoreData
import Cosmos

class RecipeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var favoritebt: UIButton!
    @IBOutlet weak var cocinarBt: UIButton!
    @IBOutlet weak var verPasosBt: UIButton!
    @IBOutlet weak var nombreReceta: UILabel!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var starsRating: CosmosView!
    
    
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
        self.starsRating.settings.updateOnTouch = false
        setTextBt()
        for iBD in self.ingredients {
            ingredientsBDServerId.append(iBD.ingredientIdServer)
        }
        if recipe == nil {
            recibir()
        }else {
            if recipe?.favorite == FavoriteTypes.favorite {
                favoritebt.enabled = false
            }
            drawView()

        }
    }
    func setTextBt(){
        self.cocinarBt.setTitle(NSLocalizedString("COCINAR",comment:"Cocinar"), forState: .Normal)
        self.verPasosBt.setTitle(NSLocalizedString("VERPASOS",comment:"Ver Pasos"), forState: .Normal)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func recibir(){
        let myapiClient = MyAPIClient()
        myapiClient.getrecipe(idText, recipe2: { (r) -> () in
            self.recipe = r
            }, finished: { () -> () in
                self.drawView()
            }) { (error) -> () in
                print("\(error.debugDescription)")
        }
    }

    func drawView(){
        if recipe != nil {
            self.nombreReceta.text  = "\(recipe!.name)"
            if recipe!.photo != "" && Reachability.isConnectedToNetwork() {
                let url = NSURL(string: recipe!.photo)
                let data = NSData(contentsOfURL: url!)
                self.imageView.image = UIImage(data: data!)
            }
            self.starsRating.rating = Double(recipe!.score)
            for i in recipe!.measures{
                let i2 = i
                if self.ingredientsBDServerId.contains(i2.ingredient.ingredientIdServer) {
                    i2.ingredient.storageId = 1
                    self.storedIngredients.append(i2.ingredient)
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
                }
            }
            self.sections.append(self.storedIngredients)
            self.sections.append(self.missingIngredients)
            self.tableView.reloadData()
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
            cell.stateLabel.text = NSLocalizedString("PENDIENTECOMPRA",comment:"Pendiente de compra")
        }else if section[indexPath.row].cartId == 0 && section[indexPath.row].storageId == 0{
            cell.stateLabel.text = NSLocalizedString("SINUNIDADES",comment:"Sin unidades")
        }else {
            cell.stateLabel.text = NSLocalizedString("PRODUCTOENALMACEN",comment:"Producto en almacen")
        }
        return cell
    }
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // the cells you would like the actions to appear needs to be editable
        return indexPath.section == 1 ? true : false
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
            view.makeToast(NSLocalizedString("INGREDIENTECOMPRADO",comment:"Se ha agregado un ingrediente al carrito de la compra"), duration: 2.0, position: .Center)
            print("Ingrediente añadido al cart")
        }catch _{
            print("Error al añadir al cart")
        }
    }
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let buyAction = UITableViewRowAction(style: .Normal, title: NSLocalizedString("COMPRAR",comment:"Comprar")) { action, index in
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
            return NSLocalizedString("ENALMACEN",comment:"En almacén")
        }else{
            return NSLocalizedString("FALTA",comment:"Falta")
        }
    }
    @IBAction func saveFavorites(sender: AnyObject) {
        print("Action salvar")
        var correcto = true
        let recipeIns = recipe
        var measure : MeasureIngredients
        var RecipeId : Int64?
        recipeIns?.favorite = FavoriteTypes.favorite
        do{
            
            let r = try RecipeDataHelper.findIdServer((recipeIns?.recipeIdServer)!)
            if r == nil {
                RecipeId = try RecipeDataHelper.insert(recipe!)
            }else {
                correcto = false
            }
           
            
        }catch _ {
            correcto = false
            print("error al crear receta favorita")
        }
        if correcto {
            var ingredient: Ingredient
            for m in (self.recipe?.measures)! {
                do {
                    
                    measure = m
                    measure.recipeId = RecipeId!
                    ingredient = measure.ingredient
                    let i = try IngredientDataHelper.findIdServer(ingredient.ingredientIdServer)
                    if i == nil {
                         let IngredientId = try IngredientDataHelper.insert(ingredient)
                        measure.ingredientId = IngredientId
                        
                    }else {
                        measure.ingredientId = (i?.ingredientId)!
                    }
                }catch _ {
                    correcto = false
                    print("error al crear ingrediente de receta")
                }
                if correcto {
                    do {
                        try MeasureDataHelper.insert(measure)
                    }catch _ {
                        correcto = false
                        print("error al crear medida de ingrediente")
                    }
                }
            }
        }
        if correcto {
            var _: Task
            for t in (self.recipe?.tasks)! {
                do{
                    t.recipeId = RecipeId!
                   try TaskDataHelper.insert(t)
                    
                } catch _ {
                    print("error al crear la tarea")
                }
            }
             view.makeToast(NSLocalizedString("FAVAGREGADO",comment:"Compra Realizada"), duration: 2.0, position: .Center)
            favoritebt.enabled = false
            print("receta agregada")
        }
    }
    
   
    
    
}
