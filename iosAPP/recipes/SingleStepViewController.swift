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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
