//
//  StatisticsTableViewCell.swift
//  HappyDaysCollectionVersion
//
//  Created by David Prochazka on 25/05/16.
//  Copyright © 2016 David Prochazka. All rights reserved.
//

import UIKit

class StatisticsTableViewCell: UITableViewCell {

    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var lastSevenRatingLabel: UILabel!
    @IBOutlet weak var lastThirtyRatingLabel: UILabel!
    @IBOutlet weak var last365RatingLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
