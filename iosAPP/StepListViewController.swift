//
//  StepListViewController.swift
//  iosAPP
//
//  Created by mikel balduciel diaz on 15/2/16.
//  Copyright © 2016 mikel balduciel diaz. All rights reserved.
//

import UIKit

class StepListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource  {
    var recipe : Recipe?
    @IBOutlet weak var tableView: UITableView!
    var tasks = [AnyObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\"Lista de tareas\""
        tasks = (recipe!.tasks?.allObjects)!
         self.tableView.reloadData()
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK : UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tasks.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        
        //let recipe = recipes[indexPath.row]
        if tasks.count > 0 {
            let taskrow = tasks[indexPath.row]
            let task = taskrow as? Task
            //cell!.textLabel!.text = recipe.valueForKey("name") as? String
            cell!.textLabel!.text = "Paso " + (task?.name)!
        }
        print (tasks.count)
        
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // let row = indexPath.row
        //let recipe = recetasString[row]
        //idseleccionado = (recipe["id"]! as? Int)!
        // let secondViewController = self.storyboard!.instantiateViewControllerWithIdentifier("recipe") as! RecipeViewController
        
        //self.navigationController!.pushViewController(secondViewController, animated: true)
        //self.performSegueWithIdentifier("recipe", sender: self)
        //print("\(recipe["id"]!)")
    }


}
