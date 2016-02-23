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
    var timer = NSTimer();
    var startDate:NSDate?;
    var t : Task?
    override func viewDidLoad() {
        super.viewDidLoad()
       if recipe?.tasks.count > 0 {
            tasks = recipe!.tasks.sort({ (task, task2) -> Bool in
                let t = task as Task
                let t2 = task2 as Task
                return t.name < t2.name
            })
            t = tasks[currentTaskPos] as? Task
            self.taskName.text = "Paso " + (t?.name)!
            self.descriptionLabel.text = t?.taskDescription
           self.time.text = tiempo(Double((t?.seconds)!))
        
       }else {
        self.nextBT.setTitle("Finalizar", forState: .Normal)
        
        }
        
        
        // Do any additional setup after loading the view.
    }

    @IBAction func countDownAction(sender: UIButton) {
        sender.selected = !sender.selected;
        //if selected fire timer, otherwise stop
        if (sender.selected) {
            self.timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("updateTimer"), userInfo: nil, repeats: true);
            self.startDate = NSDate();
        } else {
            self.stopTimer();
        }
    }
    func stopTimer() {
        self.timer.invalidate();
    }
    
    func updateTimer() {
        // Create date from the elapsed time
        let currentDate:NSDate = NSDate();
        let timeInterval:NSTimeInterval = currentDate.timeIntervalSinceDate(self.startDate!);
        
        //300 seconds count down
        let intseconds = Double((t?.seconds)!)
       
        let timeIntervalCountDown = intseconds - timeInterval
        let timerDate:NSDate = NSDate(timeIntervalSince1970: timeIntervalCountDown);
        
        // Create a date formatter
        let dateFormatter = NSDateFormatter();
        dateFormatter.dateFormat = "mm:ss";
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0);
        
        // Format the elapsed time and set it to the label
        let timeString = dateFormatter.stringFromDate(timerDate);
        if timeIntervalCountDown <= 0 {
            stopTimer()
        }else{
           self.time?.text = timeString;
        }
    }
    func tiempo (seconds: Double) -> String{
         self.startDate = NSDate();
        let currentDate:NSDate = NSDate();
        let timeInterval:NSTimeInterval = currentDate.timeIntervalSinceDate(self.startDate!);
        
        
        let timeIntervalCountDown = seconds - timeInterval
        let timerDate:NSDate = NSDate(timeIntervalSince1970: timeIntervalCountDown);
        
        // Create a date formatter
        let dateFormatter = NSDateFormatter();
        dateFormatter.dateFormat = "mm:ss";
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0);
        
        // Format the elapsed time and set it to the label
        let timeString = dateFormatter.stringFromDate(timerDate);
        return timeString
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
     @IBOutlet weak var time: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBAction func nextAction(sender: AnyObject) {
        stopTimer()
        
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
            t = tasks[currentTaskPos] as? Task
              self.time.text = tiempo(Double((t?.seconds)!))
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
        stopTimer()
        
        print ( "current: \(currentTaskPos) tamaño: \(tasks.count)" )
        if currentTaskPos > 0 {
            
            if currentTaskPos < tasks.count {
                self.nextBT.setTitle("Siguiente", forState: .Normal)
            }
            
            currentTaskPos--
            t = tasks[currentTaskPos] as? Task
             self.time.text = tiempo(Double((t?.seconds)!))
            self.taskName.text = "Paso " + (t?.name)!
            self.descriptionLabel.text = t?.taskDescription
            if currentTaskPos == 0 {
                print("boton disable")
                let bt = sender as! UIButton
                bt.enabled = false
            }

        }
    }
    @IBAction func alert(sender: UIBarButtonItem) {
       /* let picker : UIDatePicker = UIDatePicker()
        picker.datePickerMode = UIDatePickerMode.CountDownTimer
        picker.addTarget(self, action: "dueDateChanged:", forControlEvents: UIControlEvents.ValueChanged)
        let pickerSize : CGSize = picker.sizeThatFits(CGSizeZero)
        picker.frame = CGRectMake(0.0, 250, pickerSize.width, 460)
        //you probably don't want to set background color as black
       // picker.backgroundColor = UIColor.blackColor()
        self.view.addSubview(picker)*/
    }
    /*func dueDateChanged(sender:UIDatePicker){
       
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "mm:ss";
         print ( dateFormatter.stringFromDate(sender.date))
        self.time.text = dateFormatter.stringFromDate(sender.date)
        
        sender.hidden = true
    }*/
    @IBOutlet weak var nextBT: UIButton!

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "endRecipe") {
            let svc = segue.destinationViewController as! FinalStepViewController
            var ingredientsFinish = [Int64]()
            for m in (self.recipe?.measures)!{
                ingredientsFinish.append(m.ingredient.ingredientIdServer)
            }
            
            svc.ingredientsFinishIDS = ingredientsFinish
            // print("dentro")
            
        }
    }

}
