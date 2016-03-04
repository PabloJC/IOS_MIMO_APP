//
//  StepViewController.swift
//  iosAPP
//
//  Created by mikel balduciel diaz on 15/2/16.
//  Copyright © 2016 mikel balduciel diaz. All rights reserved.
//

import UIKit

class StepViewController: UIViewController {
    @IBOutlet weak var PreviousBT: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var nextBT: UIButton!
    @IBOutlet weak var uiTextField: UITextField!
    @IBOutlet weak var btAlarm: UIButton!
    var recipe : Recipe?
    var notifications = [Notification]()
    var tasks = [AnyObject]()
    var currentTaskPos = 0
    var timer = NSTimer();
    var startDate:NSDate?;
    var tiempoPicker = ""
    var pickerNSDate :NSDate?
    var timerAlert : NSDate?
    var t : Task?
    var total :Double?
    
    var currentNotification = Notification()
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
       // toolbar()
       if recipe?.tasks.count > 0 {
            tasks = recipe!.tasks.sort({ (task, task2) -> Bool in
                let t = task as Task
                let t2 = task2 as Task
                return t.name < t2.name
            })
            t = tasks[currentTaskPos] as? Task
            //self.taskName.text = "Paso " + (t?.name)!
        self.taskName.text =  NSLocalizedString("PASO",comment:"Paso") + " " + (t?.name)!
            self.descriptionLabel.text = t?.taskDescription
          //  self.tiempoPicker = tiempo(Double((t?.seconds)!))
         total = Double((t?.seconds)!)
        self.uiTextField.text = tiempo(Double((t?.seconds)!))
        
            //print (NSDate())
        if(self.findNotification()){
            print("Notificación encontrada")
            total = currentNotification.firedate.timeIntervalSinceNow
            self.timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("updateTimer"), userInfo: nil, repeats: true);
            btAlarm.enabled = false
        }else{
            btAlarm.enabled = true
        }
        
       }else {
        self.nextBT.setTitle(NSLocalizedString("FINALIZAR", comment: "Finalizar"), forState: .Normal)
        
        }
    }
    
    
    func findNotification() -> Bool{
        var res = false
        do{
            if let dso = try NotificationsDataHelper.findNotificationByTask((t?.taskIdServer)!){
                currentNotification = dso
                print(currentNotification)
                res = true
                
            }
        }catch _{
            print("Error al encontrar Notification")
        }
        return res

    }

    
    func stopTimer() {
        self.timer.invalidate();
    }
    
   func updateTimer() {
        // Create date from the elapsed time
        let currentDate:NSDate = NSDate();
        let timeInterval:NSTimeInterval = currentDate.timeIntervalSinceDate(self.startDate!);
        
        
       /*
        if let pD = pickerNSDate  {
            let calendar = NSCalendar.currentCalendar()
            let comp = calendar.components([.Hour, .Minute, .Second], fromDate: pD)
            let hour = comp.hour * 3600
            let minute = comp.minute * 60
            let second = comp.second
            total =  Double(hour + minute + second)
        }*/
    
        
        let timeIntervalCountDown = total! - timeInterval
        //let timeAlert = total! + timeInterval
        let timerDate:NSDate = NSDate(timeIntervalSince1970: timeIntervalCountDown);
       // print(timerDate)
        
        //timerAlert = NSDate(timeIntervalSinceNow: total!)

        // Create a date formatter
        let dateFormatter = NSDateFormatter();
        dateFormatter.dateFormat = "mm:ss";
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0);
        
        // Format the elapsed time and set it to the label
        let timeString = dateFormatter.stringFromDate(timerDate);
        if timeIntervalCountDown <= 0 {
            stopTimer()
            self.uiTextField.text = tiempo(Double((t?.seconds)!))
            if findNotification() {
                btAlarm.enabled = false
                total = 0
                
            }else {
                btAlarm.enabled = true
                total = Double((t?.seconds)!)
            }
            
        }else{
            self.uiTextField.text = timeString
        }
    }
   
    
    @IBAction func nextAction(sender: AnyObject) {
        stopTimer()
        
        print ( "current: \(currentTaskPos) tamaño: \(tasks.count)" )
       
        if currentTaskPos < tasks.count-1{
            if currentTaskPos == tasks.count-2 {
                let bt = sender as! UIButton
                bt.setTitle(NSLocalizedString("FINALIZAR", comment: "Finalizar"), forState: .Normal)
                print("boton cambiado a finalizar")
            }
            if currentTaskPos >= 0 {
                self.PreviousBT.enabled = true
            }
            currentTaskPos++
            t = tasks[currentTaskPos] as? Task
            self.taskName.text = NSLocalizedString("PASO",comment:"Paso") + " " + (t?.name)!
            total = Double((t?.seconds)!)
            self.uiTextField.text = tiempo(Double((t?.seconds)!))
            self.descriptionLabel.text = t?.taskDescription
            
        }
        else {
            
            self.performSegueWithIdentifier("endRecipe", sender: self)
            print("restar ingredientes")
            //realizar la comprobacion de ingredientes restantes
        }
        if(self.findNotification()){
            print("Notificación encontrada")
            total = currentNotification.firedate.timeIntervalSinceNow
            self.timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("updateTimer"), userInfo: nil, repeats: true);
            btAlarm.enabled = false
        }else{
            btAlarm.enabled = true
        }
    }
    
    @IBAction func previousAction(sender: AnyObject) {
        stopTimer()
       
        print ( "current: \(currentTaskPos) tamaño: \(tasks.count)" )
        if currentTaskPos > 0 {
            
            if currentTaskPos < tasks.count {
                self.nextBT.setTitle(NSLocalizedString("SIGUIENTE",comment:"Siguiente"), forState: .Normal)
            }
            
            currentTaskPos--
            t = tasks[currentTaskPos] as? Task
            self.taskName.text = NSLocalizedString("PASO",comment:"Paso") + " " + (t?.name)!
            total = Double((t?.seconds)!)
            self.uiTextField.text = tiempo(Double((t?.seconds)!))
            self.descriptionLabel.text = t?.taskDescription
            if currentTaskPos == 0 {
                print("boton disable")
                let bt = sender as! UIButton
                bt.enabled = false
            }

        }
        if(self.findNotification()){
            print("Notificación encontrada")
            total = currentNotification.firedate.timeIntervalSinceNow
            self.timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("updateTimer"), userInfo: nil, repeats: true);
            btAlarm.enabled = false
        }else{
            btAlarm.enabled = true
        }    }
   /* @IBAction func countDownAction(sender: UIButton) {
        
        sender.selected = !sender.selected;
        //if selected fire timer, otherwise stop
        if (sender.selected) {
            uiTextField.enabled = false
            self.timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("updateTimer"), userInfo: nil, repeats: true);
            self.startDate = NSDate();
        } else {
            uiTextField.enabled = true
            self.stopTimer();
        }
    }*/
    
    @IBAction func alarmAction(sender: AnyObject) {
        
        let settings = UIApplication.sharedApplication().currentUserNotificationSettings()
        
        if settings!.types == .None {
            //let ac = UIAlertController(title: "Can't schedule", message: "Either we don't have permission to schedule notifications, or we haven't asked yet.", preferredStyle: .Alert)
            let ac = UIAlertController(title: "Alarma no admitida", message: "Debido a que no tenemos permisos para activar notificaciones, o no te lo hemos preguntado con anterioridad", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
            return
        }else{
        
        
        
        let sender2 = sender as! UIButton
        //if selected fire timer, otherwise stop
            uiTextField.enabled = false
            self.timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("updateTimer"), userInfo: nil, repeats: true);
            self.startDate = NSDate();
            sender2.enabled = false
        
        timerAlert = NSDate(timeIntervalSinceNow: total!)
        // 1
        let notification = UILocalNotification()
        // 15
        print(timerAlert)
        notification.userInfo = Dictionary<String, AnyObject> ()
        notification.fireDate = fixedNotificationDate(timerAlert!)
        // 3
        //notification.alertBody = "La Tarea \(t!.name) de la receta '\(recipe!.name)' pendiente de revision"
        notification.alertBody = NSString(format: NSLocalizedString("NOTIFICACION", comment: "notificacion"),"\(t!.name)","\(recipe!.name)") as String
        //notification.soundName = UILocalNotificationDefaultSoundName
        var sound = NSUserDefaults.standardUserDefaults().dictionaryForKey("sound")
            print ("el setting diccionario es: \(sound)")
        var sound2 = NSUserDefaults.standardUserDefaults().stringForKey("sound")
            print ("el setting string es: \(sound2)")
        notification.soundName = "one_piece_zoro.wav"

        print("numero de notificaciones pendientes" + "\(UIApplication.sharedApplication().applicationIconBadgeNumber)")
        //UIApplication.sharedApplication().applicationIconBadgeNumber =  UIApplication.sharedApplication().applicationIconBadgeNumber + 1
        //notification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber
            
        // 7
        
        let ntf = Notification()
        ntf.firedate = timerAlert!
        ntf.recipeId = (recipe?.recipeIdServer)!
        ntf.taskId = (t?.taskIdServer)!
        
        do{
            
            let id = try NotificationsDataHelper.insert(ntf)
            print (id)
            notification.userInfo = ["uid" : Int(id) ]
            print("Notificacion insertada")
         }catch _{
            print("Error al crear el ingrediente")
        }
        
            do{
                let notificaciones = try NotificationsDataHelper.findAll()
                notification.applicationIconBadgeNumber =  (notificaciones?.count)!
            }catch _ {
                print("error al mostrar notificaciones")
            }
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        }
        
    }
    
    
    func fixedNotificationDate(dateToFix: NSDate) -> NSDate {
        
        let dateComponents: NSDateComponents = NSCalendar.currentCalendar().components([NSCalendarUnit.Day, NSCalendarUnit.Month, NSCalendarUnit.Year, NSCalendarUnit.Hour, NSCalendarUnit.Minute,NSCalendarUnit.Second], fromDate: dateToFix)
        let fixedDate: NSDate = NSCalendar.currentCalendar().dateFromComponents(dateComponents)!
        
        return fixedDate
        
    }

    
    /*@IBAction func textFieldEditing(sender: UITextField) {
        let datePickerView: UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.CountDownTimer
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: Selector("datePickerValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func datePickerValueChanged(sender: UIDatePicker) {
       
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "mm:ss";
        tiempoPicker = dateFormatter.stringFromDate(sender.date)
        pickerNSDate  = sender.date
        uiTextField.text = dateFormatter.stringFromDate(sender.date)
        
    }*/
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
    /*func toolbar (){
        let toolBar = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.size.width, 40.0))
        
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBar.barStyle = UIBarStyle.BlackTranslucent
        
        toolBar.tintColor = UIColor.whiteColor()
        
        toolBar.backgroundColor = UIColor.blackColor()
        let okBarBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "donePressed:")
        toolBar.setItems([okBarBtn], animated: true)
        uiTextField.inputAccessoryView = toolBar
    }
    func donePressed(sender: UIBarButtonItem) {
        
        uiTextField.resignFirstResponder()
        
    }*/

}
