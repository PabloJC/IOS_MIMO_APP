//
//  ListIngredientsViewController.swift
//  iosAPP
//
//  Created by mikel balduciel diaz on 31/1/16.
//  Copyright © 2016 mikel balduciel diaz. All rights reserved.
//

import UIKit

class ListIngredientsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
       
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
         table.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ListaIngredientes.ingredientes.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell: UITableViewCell
        
     
            let textCellIdentifier = "Ingredient"
            cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as UITableViewCell
             let custom = cell as! IngredientTableViewCell
            custom.label?.text = ListaIngredientes.ingredientes[row]
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        print(ListaIngredientes.ingredientes[row])
    }
    

}
