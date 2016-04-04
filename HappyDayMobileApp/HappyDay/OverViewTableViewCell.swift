//
//  OverViewTableViewCell.swift
//  HappyDay
//
//  Created by David Prochazka on 14/03/16.
//  Copyright © 2016 David Prochazka. All rights reserved.
//

import UIKit

class OverViewTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
