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
    @IBOutlet weak var authorLabel: UITextView!
    @IBOutlet weak var contentCell: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()

    
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
