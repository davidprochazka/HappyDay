//
//  PersonsTableViewController.swift
//  HappyDay
//
//  Created by David Prochazka on 09/03/16.
//  Copyright © 2016 David Prochazka. All rights reserved.
//

import UIKit
import CoreData

class PersonsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var teamViewControllerNC : UINavigationController? = nil
    
    var selectedTeam : Team? = nil
    var editedPersonIndexPath: NSIndexPath? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.rowHeight = 135

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0

    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PersonCell", forIndexPath: indexPath)
        self.configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        let personCell = cell as! PersonTableViewCell
        let fetchedPerson = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Person
        let imageData = fetchedPerson.image!
        personCell.personImage.image = UIImage(data: imageData)
        personCell.nameLabel?.text = fetchedPerson.name
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "newPerson" {
            let controller = (segue.destinationViewController as! UINavigationController).topViewController as! NewPersonViewController
            controller.selectedTeam = self.selectedTeam
        } else if segue.identifier == "personSelected" {
            let eventViewController = segue.destinationViewController as! EventViewController
            eventViewController.teamViewControllerNC = self.teamViewControllerNC
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let selectedPerson = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Person
                eventViewController.selectedPerson = selectedPerson
            }
        } else if segue.identifier == "editPerson" {
            let controller = (segue.destinationViewController as! UINavigationController).topViewController as! EditPersonViewController
            // Send selected team
            if let indexPath = self.editedPersonIndexPath {
                let selectedPerson = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Person
                controller.selectedPerson = selectedPerson
            }
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

    
    // MARK: - Fetched results controller
    
    var fetchedResultsController: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest()
        // Edit the entity name as appropriate.
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.entityForName("Person", inManagedObjectContext: managedObjectContext)
        fetchRequest.entity = entity
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // nadefinuji predikat
        let teamPredicate = NSPredicate(format: "team.name like %@", selectedTeam!.name!)
        fetchRequest.predicate = teamPredicate
        
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        
       
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
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
            self.editedPersonIndexPath = indexPath
            self.performSegueWithIdentifier("editPerson", sender: nil)
        })
        return [deleteAction,editAction]
    }
}
