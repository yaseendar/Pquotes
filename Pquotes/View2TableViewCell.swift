//
//  View2TableViewCell.swift
//  Pquotes
//
//  Created by Abdul Basit on 29/08/18.
//  Copyright © 2018 Yaseen Dar. All rights reserved.
//

import UIKit

class View2TableViewCell: UITableViewCell {

    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var quotesLabel: UILabel!
    @IBOutlet weak var contentCell: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
