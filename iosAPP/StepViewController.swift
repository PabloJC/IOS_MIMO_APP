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
    override func viewDidLoad() {
        super.viewDidLoad()
        tasks = (recipe!.tasks?.allObjects)!
        let t = tasks[0] as? Task
        self.taskName.text = "Paso " + (t?.name)!
        self.descriptionLabel.text = t?.taskDescription
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
