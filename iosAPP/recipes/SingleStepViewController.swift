//
//  SingleStepViewController.swift
//  iosAPP
//
//  Created by mikel balduciel diaz on 16/2/16.
//  Copyright © 2016 mikel balduciel diaz. All rights reserved.
//

import UIKit

class SingleStepViewController: UIViewController {
    var task : Task?
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var taskDescriptionTextView: UITextView!
    @IBOutlet weak var taskImageView: UIImageView!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        self.taskNameLabel.text =  NSLocalizedString("PASO",comment:"Paso") + " " + (task?.name)!
        self.taskDescriptionTextView.text = task?.taskDescription
        if task?.photo != "" && appDelegate.isConected {
            let url = NSURL(string: task!.photo)
            if let data = NSData(contentsOfURL: url!) {
                self.taskImageView.image = UIImage(data: data)
            }
        }
        else {
            self.taskImageView.image = UIImage(named: "sinImagen")
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
