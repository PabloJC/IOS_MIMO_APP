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
        let background = CAGradientLayer().blueToWhite()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, atIndex: 0)
        tableView.layer.cornerRadius = 5
        cocinarBt.layer.cornerRadius = 5
        verPasosBt.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 5.0
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
        self.view.makeToastActivity(.Center)
        myapiClient.getrecipe(idText, recipe2: { (r) -> () in
            self.recipe = r
            }, finished: { () -> () in
                self.drawView()
                self.view.hideToastActivity()
            }) { (error) -> () in
                print("\(error.debugDescription)")
        }
    }

    func drawView(){
        if recipe != nil {
            self.nombreReceta.text  = "\(recipe!.name)"
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            if recipe!.photo != "" && appDelegate.isConected {
                let url = NSURL(string: recipe!.photo)
                self.imageView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "sinImagen"))
                /*if let data = NSData(contentsOfURL: url!) {
                     self.imageView.image = UIImage(data: data)
                }*/
            }else {
                self.imageView.image = UIImage(named: "sinImagen")
                
            }
            self.starsRating.rating = Double(recipe!.score)
            for i in recipe!.measures{
                print (i.quantity)
                var ingre: Ingredient!
                let i2 = i
                if self.ingredientsBDServerId.contains(i2.ingredient.ingredientIdServer) {
                    i2.ingredient.storageId = 1
                    ingre = i2.ingredient
                    ingre.measure = i2.measure
                    ingre.quantity = Double(i2.quantity)
                    self.storedIngredients.append(ingre)
                }else {
                    do {
                        var iBD = try IngredientDataHelper.findIdServer(i2.ingredient.ingredientIdServer)
                        if iBD == nil {
                            try IngredientDataHelper.insert(i2.ingredient)
                            iBD = try IngredientDataHelper.findIdServer(i2.ingredient.ingredientIdServer)
                        }
                        ingre = iBD
                        ingre.measure = i2.measure
                        ingre.quantity = Double(i2.quantity)
                        
                        self.missingIngredients.append(ingre)
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
        cell.measureLabel!.text = section[indexPath.row].measure
        cell.quantityLabel.text = "\(section[indexPath.row].quantity)"
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
        let correcto = Recipe.saveFavorite(recipe!)
        if correcto {
            view.makeToast(NSLocalizedString("FAVAGREGADO",comment:"Compra Realizada"), duration: 2.0, position: .Center)
            favoritebt.enabled = false
        }
    }
    
   
    
    
}
