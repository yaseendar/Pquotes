//
//  ControllerViewCell.swift
//  Pquotes
//
//  Created by Abdul Basit on 20/08/18.
//  Copyright © 2018 Yaseen Dar. All rights reserved.
//

import UIKit

class ControllerViewCell: UITableViewCell {

    @IBOutlet weak var quoteCountLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
