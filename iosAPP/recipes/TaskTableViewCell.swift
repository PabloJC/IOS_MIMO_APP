//
//  TaskTableViewCell.swift
//  iosAPP
//
//  Created by mikel balduciel diaz on 28/2/16.
//  Copyright © 2016 mikel balduciel diaz. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var imageTask: UIImageView!
    @IBOutlet weak var nameTaskLandscape: UILabel!
    @IBOutlet weak var nameTaskPortrait: UILabel!

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
