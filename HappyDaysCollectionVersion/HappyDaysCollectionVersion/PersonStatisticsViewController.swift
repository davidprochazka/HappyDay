//
//  StatsViewController.swift
//  HappyDaysCollectionVersion
//
//  Created by David Prochazka on 24/05/16.
//  Copyright © 2016 David Prochazka. All rights reserved.
//

import UIKit
import CoreData
import MessageUI

protocol PersonStatisticsViewControllerDelegate {
    func didCloseStats()
}

class PersonStatisticsViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    var managedObjectContext: NSManagedObjectContext? = nil
    var selectedPerson: Person? = nil
    
    var selectedMood: Int? = nil
    
    var delegate: PersonStatisticsViewControllerDelegate? = nil

    @IBOutlet weak var currentMoodLabel: UILabel!
    @IBOutlet weak var weekMoodLabel: UILabel!
    @IBOutlet weak var monthMoodLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = selectedPerson!.name! + "'s statistics"
        
        // po navratu z hodnoticiho view muze byt view bez MOC
        if self.managedObjectContext == nil {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            self.managedObjectContext = appDelegate.managedObjectContext
        }
        
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func closeClicked(sender: AnyObject) {
        delegate?.didCloseStats()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func configureView(){
        let stats = PersonStatistics(person: selectedPerson!, moc: managedObjectContext!)
        stats.calculate()
        currentMoodLabel.text = selectedMood?.description
        weekMoodLabel.text = (round(stats.avg7*10)/10).description
        monthMoodLabel.text = (round(stats.avg30*10)/10).description
    }
    
    @IBAction func exportData(sender: AnyObject) {
        let export = StatisticsExport(ctrl: self, moc: managedObjectContext!)
        export.sendCsvInMail()
    }
}

