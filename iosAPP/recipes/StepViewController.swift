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
    @IBOutlet weak var nextBT: UIButton!
    @IBOutlet weak var btAlarm: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var uiTextField: UITextField!
    
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
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setTextBt()
        if recipe?.tasks.count > 0 {
            tasks = recipe!.tasks.sort({ (task, task2) -> Bool in
                let t = task as Task
                let t2 = task2 as Task
                return t.name < t2.name
            })
            t = tasks[currentTaskPos] as? Task
            self.taskName.text =  NSLocalizedString("PASO",comment:"Paso") + " " + (t?.name)!
            self.descriptionLabel.text = t?.taskDescription
            total = Double((t?.seconds)!)
            self.uiTextField.text = tiempo(Double((t?.seconds)!))
            
            if t?.photo != "" && appDelegate.isConected {
                self.view.makeToastActivity(.Center)
                print(t!.photo)
                let url = NSURL(string: t!.photo)
                if let data = NSData(contentsOfURL: url!) {
                    self.imageView.image = UIImage(data: data)
                }
                self.view.hideToastActivity()
            }else {
                self.imageView.image = UIImage(named: "sinImagen")

            }
            if(self.findNotification()){
                total = currentNotification.firedate.timeIntervalSinceNow
                self.timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("updateTimer"), userInfo: nil, repeats: true);
                btAlarm.setImage(UIImage(named: "AlarmaActivada"), forState: .Normal)
                btAlarm.enabled = false
            }else{
                btAlarm.setImage(UIImage(named: "AlarmaReposo"), forState: .Normal)
                btAlarm.enabled = true
            }
            
        }else {
            self.nextBT.setTitle(NSLocalizedString("FINALIZAR", comment: "Finalizar"), forState: .Normal)
            
        }
        let background = CAGradientLayer().blueToWhite()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, atIndex: 0)
        descriptionLabel.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 5.0

    }
    func setTextBt(){
        self.btAlarm.setTitle(NSLocalizedString("ALARMA",comment:"Alarma"), forState: .Normal)
        self.nextBT.setTitle(NSLocalizedString("SIGUIENTE",comment:"Siguiente"), forState: .Normal)
        self.PreviousBT.setTitle(NSLocalizedString("ANTERIOR",comment:"Anterior"), forState: .Normal)
    }
    
    
    
    func findNotification() -> Bool{
        var res = false
        do{
            if let dso = try NotificationsDataHelper.findNotificationByTask((t?.taskIdServer)!){
                currentNotification = dso
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
        let currentDate:NSDate = NSDate();
        let timeInterval:NSTimeInterval = currentDate.timeIntervalSinceDate(self.startDate!);
        
        let timeIntervalCountDown = total! - timeInterval
        let timerDate:NSDate = NSDate(timeIntervalSince1970: timeIntervalCountDown);
        let dateFormatter = NSDateFormatter();
        dateFormatter.dateFormat = "mm:ss";
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0);
        let timeString = dateFormatter.stringFromDate(timerDate);
        if timeIntervalCountDown <= 0 {
            stopTimer()
            self.uiTextField.text = tiempo(Double((t?.seconds)!))
            if findNotification() {
                btAlarm.setImage(UIImage(named: "AlarmaActivada"), forState: .Normal)
                btAlarm.enabled = false
                total = 0
            }else {
                btAlarm.setImage(UIImage(named: "AlarmaReposo"), forState: .Normal)
                btAlarm.enabled = true
                total = Double((t?.seconds)!)
            }
        }else{
            self.uiTextField.text = timeString
        }
    }
    
    
    @IBAction func nextAction(sender: AnyObject) {
        self.view.makeToastActivity(.Center)
        stopTimer()
        
        if currentTaskPos < tasks.count-1{
            if currentTaskPos == tasks.count-2 {
                let bt = sender as! UIButton
                bt.setTitle(NSLocalizedString("FINALIZAR", comment: "Finalizar"), forState: .Normal)
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
            if t?.photo != "" && appDelegate.isConected {
                
                let url = NSURL(string: t!.photo)
                if let data = NSData(contentsOfURL: url!) {
                    self.imageView.image = UIImage(data: data)
                }
               
                
            }
            else {
                self.imageView.image = UIImage(named: "sinImagen")
                
            }
            
        }
        else {
            
            self.performSegueWithIdentifier("endRecipe", sender: self)
        }
        if(self.findNotification()){
            total = currentNotification.firedate.timeIntervalSinceNow
            self.timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("updateTimer"), userInfo: nil, repeats: true);
            btAlarm.setImage(UIImage(named: "AlarmaActivada"), forState: .Normal)
            btAlarm.enabled = false
        }else{
            btAlarm.setImage(UIImage(named: "AlarmaReposo"), forState: .Normal)
            btAlarm.enabled = true
        }
         self.view.hideToastActivity()
    }
    
    @IBAction func previousAction(sender: AnyObject) {
        self.view.makeToastActivity(.Center)
        stopTimer()
        
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
            if t?.photo != "" && appDelegate.isConected {
                let url = NSURL(string: t!.photo)
                if let data = NSData(contentsOfURL: url!) {
                    self.imageView.image = UIImage(data: data)
                }
            }
            else {
                self.imageView.image = UIImage(named: "sinImagen")
                
            }
            if currentTaskPos == 0 {
                let bt = sender as! UIButton
                bt.enabled = false
            }
            
        }
        if(self.findNotification()){
          
            total = currentNotification.firedate.timeIntervalSinceNow
            self.timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("updateTimer"), userInfo: nil, repeats: true);
            btAlarm.setImage(UIImage(named: "AlarmaActivada"), forState: .Normal)
            btAlarm.enabled = false
        }else{
            btAlarm.setImage(UIImage(named: "AlarmaReposo"), forState: .Normal)
            btAlarm.enabled = true
        }
         self.view.hideToastActivity()
    }
    
    @IBAction func alarmAction(sender: AnyObject) {
        btAlarm.setImage(UIImage(named: "AlarmaActivada"), forState: .Normal)
        let settings = UIApplication.sharedApplication().currentUserNotificationSettings()
        
        if settings!.types == .None {
            let ac = UIAlertController(title: NSLocalizedString("ALARMANOADMITIDA",comment:"Alarma no admitida"), message: NSLocalizedString("MENSAJEALARMA",comment:"Debido a que no tenemos permisos para activar notificaciones, o no te lo hemos preguntado con anterioridad"), preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
            return
        }else{
            let sender2 = sender as! UIButton
            uiTextField.enabled = false
            self.timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("updateTimer"), userInfo: nil, repeats: true);
            self.startDate = NSDate();
            sender2.enabled = false
            
            timerAlert = NSDate(timeIntervalSinceNow: total!)
            let notification = UILocalNotification()
            notification.userInfo = Dictionary<String, AnyObject> ()
            notification.fireDate = fixedNotificationDate(timerAlert!)
            notification.alertBody = NSString(format: NSLocalizedString("NOTIFICACION", comment: "notificacion"),"\(t!.name)","\(recipe!.name)") as String

            let freak = NSUserDefaults.standardUserDefaults().boolForKey("sound")
            if freak {
                notification.soundName = "one_piece_zoro.wav"
            }else {
                notification.soundName = UILocalNotificationDefaultSoundName
            }
            
            let ntf = Notification()
            ntf.firedate = timerAlert!
            ntf.recipeId = (recipe?.recipeIdServer)!
            ntf.taskId = (t?.taskIdServer)!
            
            do{
                
                let id = try NotificationsDataHelper.insert(ntf)
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
            view.makeToast(NSLocalizedString("ALARMACREADA",comment:"Notificación creada"), duration: 2.0, position: .Center)
        }
        
    }
    
    
    func fixedNotificationDate(dateToFix: NSDate) -> NSDate {
        
        let dateComponents: NSDateComponents = NSCalendar.currentCalendar().components([NSCalendarUnit.Day, NSCalendarUnit.Month, NSCalendarUnit.Year, NSCalendarUnit.Hour, NSCalendarUnit.Minute,NSCalendarUnit.Second], fromDate: dateToFix)
        let fixedDate: NSDate = NSCalendar.currentCalendar().dateFromComponents(dateComponents)!
        
        return fixedDate
        
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
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "endRecipe") {
            let svc = segue.destinationViewController as! FinalStepViewController
            var ingredientsFinish = [Int64]()
            for m in (self.recipe?.measures)!{
                ingredientsFinish.append(m.ingredient.ingredientIdServer)
            }
            
            svc.ingredientsFinishIDS = ingredientsFinish
        }
    }
}
