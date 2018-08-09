//
//  FavouriteQuotesTableViewCell.swift
//  Pquotes
//
//  Created by Abdul Basit on 12/07/18.
//  Copyright © 2018 Yaseen Dar. All rights reserved.
//

import UIKit

class FavouriteQuotesTableViewCell: UITableViewCell {

    @IBOutlet weak var contentCell: UIView!
    
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var quotesTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
