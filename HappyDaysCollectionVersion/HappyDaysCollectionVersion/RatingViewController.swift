//
//  RatingViewController.swift
//  HappyDaysCollectionVersion
//
//  Created by David Prochazka on 24/05/16.
//  Copyright © 2016 David Prochazka. All rights reserved.
//

import UIKit

class RatingViewController: UIViewController {

    var selectedPerson: Person? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func saveNewEvent(happiness: Float){
        Event.createEventForPerson(self.selectedPerson!, withHappiness: happiness, inTime: NSDate())
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let statsController = (segue.destinationViewController as! UINavigationController).topViewController as! StatsViewController
        statsController.rootNavigationController = self.navigationController
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

    @IBAction func closeClick(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
