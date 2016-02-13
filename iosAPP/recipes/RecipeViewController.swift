//
//  RecipeViewController.swift
//  iosAPP
//
//  Created by mikel balduciel diaz on 11/2/16.
//  Copyright © 2016 mikel balduciel diaz. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController {

    @IBOutlet weak var nombreReceta: UILabel!
    @IBOutlet weak var id: UILabel!
    var idText = ""
    var nombreText = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        id.text = idText
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        recibir()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func recibir(){
        let myapiClient = MyAPIClient()
       
        myapiClient.getrecipe(idText, recipe2: { (r) -> () in
            self.nombreReceta.text  = "\(r.name!)"
            
            
            }, finished: { () -> () in
                print("finalizado2")
            }) { (error) -> () in
                print("\(error.debugDescription)")
        }
        
        
    }
    
}
