//
//  StatisticsTableViewController.swift
//  HappyDaysCollectionVersion
//
//  Created by David Prochazka on 24/06/16.
//  Copyright © 2016 David Prochazka. All rights reserved.
//

import UIKit
import CoreData
import MessageUI

class TeamStatisticsTableViewController: UITableViewController, MFMailComposeViewControllerDelegate, NSFetchedResultsControllerDelegate {

    var managedObjectContext: NSManagedObjectContext? = nil

    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.managedObjectContext == nil {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            self.managedObjectContext = appDelegate.managedObjectContext
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // reload team data and recalculate statistics after the view appeared
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchedResultsController.sections![section].numberOfObjects
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("teamStatCell", forIndexPath: indexPath) as! TeamStatisticsTableViewCell
        let team = fetchedResultsController.objectAtIndexPath(indexPath) as! Team
        
        cell.teamName.text = team.name
        let imageData = team.image
        if imageData != nil {
            cell.teamImage.image = UIImage(data: imageData!)
        }else{
            cell.teamImage.image = UIImage(named: "hamster")
        }
        
        let stats = TeamStatistics(team: team, moc: managedObjectContext!)
        stats.calculate()
        cell.avg7.text = String(round(stats.avg7*10)/10)
        cell.avg30.text = String(round(stats.avg30*10)/10)
        
        return cell
    }

    
    // MARK: - Fetch Results Controller
    
    var fetchedResultsController: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entityForName("Team", inManagedObjectContext: self.managedObjectContext!)
        fetchRequest.entity = entity
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //print("Unresolved error \(error), \(error.userInfo)")
            abort()
        }
        
        return _fetchedResultsController!
    }
    var _fetchedResultsController: NSFetchedResultsController? = nil
    
    
    // MARK:- Export
    @IBAction func exportData(sender: AnyObject) {
        let export = StatisticsExport(ctrl: self, moc: managedObjectContext!)
        export.sendCsvInMail()
    }
    
    /**
     Closes export mail dialog.
     */
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
