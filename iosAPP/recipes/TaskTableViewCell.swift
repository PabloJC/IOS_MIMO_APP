//
//  TaskTableViewCell.swift
//  iosAPP
//
//  Created by mikel balduciel diaz on 28/2/16.
//  Copyright © 2016 mikel balduciel diaz. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var imageTask: UIImageView!
    @IBOutlet weak var nameTaskLandscape: UILabel!
    @IBOutlet weak var nameTaskPortrait: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
