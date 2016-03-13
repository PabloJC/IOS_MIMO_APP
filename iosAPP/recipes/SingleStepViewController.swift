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
        
        let background = CAGradientLayer().blueToWhite()
        background.frame = self.view.bounds
        taskDescriptionTextView.layer.cornerRadius = 5
        taskImageView.layer.masksToBounds = true
        taskImageView.layer.cornerRadius = 5.0
        
        self.view.layer.insertSublayer(background, atIndex: 0)
        self.taskNameLabel.text =  NSLocalizedString("PASO",comment:"Paso") + " " + (task?.name)!
        self.taskDescriptionTextView.text = task?.taskDescription
       checkConectivity()
        
    }
    
    func checkConectivity(){
        if task?.photo != "" && appDelegate.isConected {
             self.view.makeToastActivity(.Center)
            let url = NSURL(string: task!.photo)
            self.taskImageView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "sinImagen"))
            self.view.hideToastActivity()
        }
        else {
            self.taskImageView.image = UIImage(named: "sinImagen")
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
