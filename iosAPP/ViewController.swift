//
//  ViewController.swift
//  iosAPP
//
//  Created by mikel balduciel diaz on 31/1/16.
//  Copyright © 2016 mikel balduciel diaz. All rights reserved.
//

import UIKit
class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let dataStore = SQLiteDataStore.sharedInstance
        do{
            try dataStore.createTables()
            
            if try StorageDataHelper.find(1) == nil {
                
            let  S = Storage()
             let id = try  StorageDataHelper.insert(S)
                print ("storage creado \(id)" )
                
            }
            if try CartDataHelper.find(1) == nil {
                
                let  C = Cart()
                let id = try  CartDataHelper.insert(C)
                print ("cart creado \(id)" )
                
            }
            
        
        }catch _ {
            print ("error insert")
        }
        print ("Finish")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 


}

