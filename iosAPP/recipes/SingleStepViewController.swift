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
    override func viewDidLoad() {
        super.viewDidLoad()
       self.taskNameLabel.text = "Paso " + (task?.name)!
        self.taskDescriptionTextView.text = task?.taskDescription
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
