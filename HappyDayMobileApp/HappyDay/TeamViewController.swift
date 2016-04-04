//
//  MasterViewController.swift
//  HappyDay
//
//  Created by David Prochazka on 09/03/16.
//  Copyright © 2016 David Prochazka. All rights reserved.
//

import UIKit
import CoreData

class TeamViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var managedObjectContext: NSManagedObjectContext? = nil
    var editedTeamIndexPath: NSIndexPath? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Edit button on the left side
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        // Height of the team line, shloud be calculated automatically
        self.tableView.rowHeight = 135
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // If someone clicked on a team button
        if segue.identifier == "teamSelected" {
            // send our controller and MOC
            // It is not necessary to send MOC, can be instantiated separately in the seque.
            let personsViewController = segue.destinationViewController as! PersonsTableViewController
            personsViewController.teamViewControllerNC = self.navigationController
            // Send selected team
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let selectedTeam = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Team
                personsViewController.selectedTeam = selectedTeam
            }
        } else if segue.identifier == "editTeam" {
            let controller = (segue.destinationViewController as! UINavigationController).topViewController as! EditTeamViewController
            // Send selected team
            if let indexPath = self.editedTeamIndexPath {
                let selectedTeam = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Team
                controller.selectedTeam = selectedTeam
            }
        }
    }


    // MARK: - EditTeamDelegate
    
    // Saving changes in a team
    func saveEditedTeamWith(name: String, andImage image: UIImage,atIndexPath indexPath:NSIndexPath){
        
        let context = self.fetchedResultsController.managedObjectContext
        let team = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Team
        team.name = name
        team.image = UIImagePNGRepresentation(image)
        
        // Save the context.
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //print("Unresolved error \(error), \(error.userInfo)")
            abort()
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TeamCell", forIndexPath: indexPath)
        self.configureCell(cell, atIndexPath: indexPath)
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let context = self.fetchedResultsController.managedObjectContext
            context.deleteObject(self.fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject)
                
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                //print("Unresolved error \(error), \(error.userInfo)")
                abort()
            }
        }
    }

    // Support method that loads data into a table cell
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        let teamCell = cell as! TeamTableViewCell
        let fetchedTeam = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Team
        let imageData = fetchedTeam.image
        teamCell.teamImage.image = UIImage(data: imageData!)
        teamCell.nameLabel?.text = (fetchedTeam.name)
    }

    // MARK: - Fetched results controller

    var fetchedResultsController: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest()
        // Load Teams from database
        let entity = NSEntityDescription.entityForName("Team", inManagedObjectContext: self.managedObjectContext!)
        fetchRequest.entity = entity
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Sort records by the name.
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
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

    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }

    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
            case .Insert:
                self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
            case .Delete:
                self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
            default:
                return
        }
    }

    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
            case .Insert:
                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            case .Delete:
                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            case .Update:
                self.configureCell(tableView.cellForRowAtIndexPath(indexPath!)!, atIndexPath: indexPath!)
            case .Move:
                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        }
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
    
    // MARK: - Custom edit menu
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: "Delete" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            // smazu objekt jen z MOC, tabulka se aktualizuje automaticky
            self.tableView(self.tableView, commitEditingStyle: .Delete, forRowAtIndexPath: indexPath)
        })
        let editAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Edit" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            self.editedTeamIndexPath = indexPath
            self.performSegueWithIdentifier("editTeam", sender: nil)
            //let storyboard = UIStoryboard(name: "Main", bundle: nil)
            //let vc = storyboard.instantiateViewControllerWithIdentifier("editTeamView") as! UINavigationController
            //self.presentViewController(vc, animated: true, completion: nil)
        })
        return [deleteAction,editAction]
    }
}

