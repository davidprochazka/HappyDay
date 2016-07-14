//
//  StatisticsTableViewCell.swift
//  HappyDaysCollectionVersion
//
//  Created by David Prochazka on 25/05/16.
//  Copyright © 2016 David Prochazka. All rights reserved.
//

import UIKit

class TeamStatisticsTableViewCell: UITableViewCell {

    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var avg7: UILabel!
    @IBOutlet weak var avg30: UILabel!
    @IBOutlet weak var teamImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
