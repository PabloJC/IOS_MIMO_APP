//
//  RecipeViewController.swift
//  iosAPP
//
//  Created by mikel balduciel diaz on 11/2/16.
//  Copyright © 2016 mikel balduciel diaz. All rights reserved.
//

import UIKit
import CoreData
class RecipeViewController: UIViewController{
    
    @IBOutlet weak var nombreReceta: UILabel!
    @IBOutlet weak var TextBox: UITextView!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var idText = ""
    var nombreText = ""
    var recipe : Recipe?
    var ingredients = [Ingredient]()
    var ingredientsBDServerId = [Int64]()
    override func viewDidLoad() {
        super.viewDidLoad()
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
            
            // print(r.ingredientsRecipe?.count)
            self.recipe = r
            for i in r.measures{
                let i2 = i
                if self.ingredientsBDServerId.contains(i2.ingredient.ingredientIdServer) {
                    texto += "\(i2.ingredient.name)" + "\(i2.quantity)" + (i2.measure) + "\n"
                }else {
                    texto += "Falta el ingrediente \(i2.ingredient.name) \n"
                }
            }
            self.TextBox.text = texto
            }, finished: { () -> () in
                //print("finalizado2")
            }) { (error) -> () in
                print("\(error.debugDescription)")
        }
        
        
    }
    @IBAction func prepareRecipeAction(sender: AnyObject) {
        self.performSegueWithIdentifier("step", sender: self)
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
        }
    }
    
}
