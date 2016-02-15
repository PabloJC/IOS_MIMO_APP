//
//  IngredientsTableViewController.swift
//  iosAPP
//
//  Created by MIMO on 14/2/16.
//  Copyright © 2016 mikel balduciel diaz. All rights reserved.
//

import UIKit

class IngredientsTableViewController: UITableViewController {
    
    var category = ""
    var ingredients = [Dictionary<String,AnyObject>]()

    override func viewDidLoad() {
        super.viewDidLoad()
        print(category)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func recibir(){
        self.ingredients = []
        let myapiClient = MyAPIClient()
        myapiClient.getCategory({ (<#String#>, <#Int#>) -> () in
            <#code#>
            }, finished: { () -> () in
                <#code#>
            }) { (<#NSError#>) -> () in
                <#code#>
        }
        
        
        ({ (receta,id) -> () in
            var post=Dictionary<String,AnyObject>()
            post = ["id":id,"name":receta]
            
            self.recetasString.append(post)
            
            }, finished: { () -> () in
                if !self.recetasString.isEmpty {
                    self.sincronized = true
                    self.tableView.reloadData()
                    print("finalizado \(self.recetasString.count)")
                }else {
                    print("sin recetas agregadas")
                }
                
            }) { (error) -> () in
                print("\(error.debugDescription)")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    func recibir(){
        self.recetasString = []
        let myapiClient = MyAPIClient()
        myapiClient.getRecipes({ (receta,id) -> () in
            var post=Dictionary<String,AnyObject>()
            post = ["id":id,"name":receta]
            
            self.recetasString.append(post)
            
            }, finished: { () -> () in
                if !self.recetasString.isEmpty {
                    self.sincronized = true
                    self.tableView.reloadData()
                    print("finalizado \(self.recetasString.count)")
                }else {
                    print("sin recetas agregadas")
                }
                
            }) { (error) -> () in
                print("\(error.debugDescription)")
        }
        
    }


    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
