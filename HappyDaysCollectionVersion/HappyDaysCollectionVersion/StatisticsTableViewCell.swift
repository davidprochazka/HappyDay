//
//  StatisticsTableViewCell.swift
//  HappyDaysCollectionVersion
//
//  Created by David Prochazka on 25/05/16.
//  Copyright © 2016 David Prochazka. All rights reserved.
//

import UIKit

class StatisticsTableViewCell: UITableViewCell {

    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var rating: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
