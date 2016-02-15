//
//  RecipeViewController.swift
//  iosAPP
//
//  Created by mikel balduciel diaz on 11/2/16.
//  Copyright © 2016 mikel balduciel diaz. All rights reserved.
//

import UIKit
import CoreData
class RecipeViewController: UIViewController {

    @IBOutlet weak var nombreReceta: UILabel!
    @IBOutlet weak var TextBox: UITextView!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var idText = ""
    var nombreText = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        recibir()
        id.text = idText
        
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
            self.nombreReceta.text  = "\(r.name!)"
            let url = NSURL(string: r.photo!)
            let data = NSData(contentsOfURL: url!)
            var texto = ""
            self.imageView.image = UIImage(data: data!)
           // print(r.ingredientsRecipe?.count)
            for i in r.ingredientsRecipe!{
                let i2 = i as! IngredientTask
              
                 texto += (i2.ingredient?.baseName!)! + "\(i2.quantity!)" + (i2.measure)! + "\n"
            }
            self.TextBox.text = texto
            }, finished: { () -> () in
                //print("finalizado2")
            }) { (error) -> () in
                print("\(error.debugDescription)")
        }
        
        
    }
    
}
