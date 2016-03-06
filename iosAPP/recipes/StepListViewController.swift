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
            self.tableView.reloadData()
        }
      }
    

    //MARK : UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tasks.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as? TaskTableViewCell
        if tasks.count > 0 {
            let taskrow = tasks[indexPath.row]
            let task = taskrow as? Task
            cell!.nameTaskPortrait!.text = NSLocalizedString("PASO",comment:"Paso") + " " + (task?.name)!
            cell!.nameTaskLandscape!.text = NSLocalizedString("PASO",comment:"Paso") + " "  + (task?.name)! + "Landscape"
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            if task!.photo != "" && appDelegate.isConected {
                let url = NSURL(string: task!.photo)
                let data = NSData(contentsOfURL: url!)
                cell!.imageTask.image = UIImage(data: data!)
            }
        }
        
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
        } 
    }


}
