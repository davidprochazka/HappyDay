//
//  TeamCollectionViewCell.swift
//  HappyDaysCollectionVersion
//
//  Created by David Prochazka on 10/05/16.
//  Copyright © 2016 David Prochazka. All rights reserved.
//

import UIKit

class TeamCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var teamImage: UIImageView!
    @IBOutlet weak var teamLabel: UILabel!

    override func awakeFromNib(){
        super.awakeFromNib()
        self.selected = false
    }
    
    override var selected : Bool {
        didSet {
            if selected{
                self.backgroundColor = UIColor.redColor()
            } else {
                self.backgroundColor = UIColor.blueColor()
            }
            
            //self.backgroundColor = selected ? UIColor.whiteColor() : UIColor.blackColor()
        }
    }
}
