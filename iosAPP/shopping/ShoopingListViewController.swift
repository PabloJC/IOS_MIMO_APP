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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.registerClass(UITableViewCell.self, forCellReuseIdentifier: "shoppingCell")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        do{
            ingredients = try IngredientDataHelper.findIngredientsInCart()!
            ingredients.sortInPlace({ $0.name < $1.name })
            table.reloadData()
            print("\(ingredients.count)")
        }catch _{
            print("Error al recibir los ingredientes")
        }

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.table.dequeueReusableCellWithIdentifier("shoppingCell")!
        
        cell.textLabel!.text = ingredients[indexPath.row].name
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
