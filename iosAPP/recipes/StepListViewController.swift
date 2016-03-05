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
        title = NSLocalizedString("LISTATAREAS",comment:"Lista de tareas")
        if recipe?.tasks.count > 0 {
            tasks = recipe!.tasks.sort({ (task, task2) -> Bool in
                let t = task as Task
                let t2 = task2 as Task
                return t.name < t2.name
            })

            //tasks = (recipe!.tasks?.sortedArrayUsingDescriptors([NSSortDescriptor(key: "name", ascending: true)]))!
            self.tableView.reloadData()
        }
        
        
        //tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")

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
        
        //let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as? TaskTableViewCell
        //let recipe = recipes[indexPath.row]
        if tasks.count > 0 {
            let taskrow = tasks[indexPath.row]
            let task = taskrow as? Task
            //cell!.textLabel!.text = recipe.valueForKey("name") as? String
            cell!.nameTaskPortrait!.text = NSLocalizedString("PASO",comment:"Paso") + " " + (task?.name)!
            cell!.nameTaskLandscape!.text = NSLocalizedString("PASO",comment:"Paso") + " "  + (task?.name)! + "Landscape"
            if task!.photo != "" && Reachability.isConnectedToNetwork() {
                let url = NSURL(string: task!.photo)
                let data = NSData(contentsOfURL: url!)
                cell!.imageTask.image = UIImage(data: data!)
            }
        }
       // print (tasks.count)
        
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        self.performSegueWithIdentifier("stepDescription", sender: self)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stepDescription") {
            let svc = segue.destinationViewController as! SingleStepViewController
            let taskrow = tasks[(tableView.indexPathForSelectedRow?.row)!]
            let task = taskrow as? Task
            svc.task = task
            // print("dentro")
            
        } 
    }


}
