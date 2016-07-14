//
//  RatingViewController.swift
//  HappyDaysCollectionVersion
//
//  Created by David Prochazka on 24/05/16.
//  Copyright © 2016 David Prochazka. All rights reserved.
//

import UIKit


class RatingViewController: UIViewController, PersonStatisticsViewControllerDelegate {

    var selectedPerson: Person? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = selectedPerson!.name! + "'s mood"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveNewEvent(happiness: Float){
        Event.createEventForPerson(self.selectedPerson!, withHappiness: happiness, inTime: NSDate())
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let statsController = (segue.destinationViewController as! UINavigationController).topViewController as! PersonStatisticsViewController
        statsController.delegate = self
        statsController.selectedPerson = self.selectedPerson
        
        if segue.identifier == "verySadTouch" {
            self.saveNewEvent(4.0)
            statsController.selectedMood = 4
        } else if segue.identifier == "sadTouch" {
            self.saveNewEvent(3.0)
            statsController.selectedMood = 3
        } else if segue.identifier == "happyTouch" {
            self.saveNewEvent(2.0)
            statsController.selectedMood = 2
        } else if segue.identifier == "veryHappyTouch" {
            self.saveNewEvent(1.0)
            statsController.selectedMood = 1
        }
        

    }
    
    /**
     Delegated method. Return to Teams after the user closes PersonStatistics.
     */
    func didCloseStats() {
        navigationController?.popToRootViewControllerAnimated(true)
    }
}
