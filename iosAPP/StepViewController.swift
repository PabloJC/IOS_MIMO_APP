//
//  StepViewController.swift
//  iosAPP
//
//  Created by mikel balduciel diaz on 15/2/16.
//  Copyright © 2016 mikel balduciel diaz. All rights reserved.
//

import UIKit

class StepViewController: UIViewController {
    var recipe : Recipe?
    var tasks = [AnyObject]()
    var currentTaskPos = 0
    override func viewDidLoad() {
        super.viewDidLoad()
       if recipe?.tasks.count > 0 {
            tasks = recipe!.tasks.sort({ (task, task2) -> Bool in
                let t = task as Task
                let t2 = task2 as Task
                return t.name < t2.name
            })
           // tasks = (recipe!.tasks.sortedArrayUsingDescriptors([NSSortDescriptor(key: "name", ascending: true)]))!
            let t = tasks[currentTaskPos] as? Task
            self.taskName.text = "Paso " + (t?.name)!
            self.descriptionLabel.text = t?.taskDescription
       }else {
        self.nextBT.setTitle("Finalizar", forState: .Normal)
        }
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBAction func nextAction(sender: AnyObject) {
        print ( "current: \(currentTaskPos) tamaño: \(tasks.count)" )
        if currentTaskPos < tasks.count-1{
            if currentTaskPos == tasks.count-2 {
                let bt = sender as! UIButton
                bt.setTitle("Finalizar", forState: .Normal)
                print("boton cambiado a finalizar")
            }
            if currentTaskPos >= 0 {
                self.PreviousBT.enabled = true
            }
            currentTaskPos++
            let t = tasks[currentTaskPos] as? Task
            self.taskName.text = "Paso " + (t?.name)!
            self.descriptionLabel.text = t?.taskDescription
            
        }
        else {
            
            self.performSegueWithIdentifier("endRecipe", sender: self)
            print("restar ingredientes")
            //realizar la comprobacion de ingredientes restantes
        }
    }
    @IBOutlet weak var PreviousBT: UIButton!
    @IBAction func previousAction(sender: AnyObject) {
        print ( "current: \(currentTaskPos) tamaño: \(tasks.count)" )
        if currentTaskPos > 0 {
            
            if currentTaskPos < tasks.count {
                self.nextBT.setTitle("Siguiente", forState: .Normal)
            }
            
            currentTaskPos--
            let t = tasks[currentTaskPos] as? Task
            self.taskName.text = "Paso " + (t?.name)!
            self.descriptionLabel.text = t?.taskDescription
            if currentTaskPos == 0 {
                print("boton desabilitado")
                let bt = sender as! UIButton
                bt.enabled = false
            }

        }
    }
    @IBOutlet weak var nextBT: UIButton!

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
