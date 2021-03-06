//
//  TeamsCollectionViewController.swift
//  HappyDaysCollectionVersion
//
//  Created by David Prochazka on 10/05/16.
//  Copyright © 2016 David Prochazka. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "TeamCell"

class TeamsCollectionViewController: UICollectionViewController, NSFetchedResultsControllerDelegate {
    
    var managedObjectContext: NSManagedObjectContext? = nil
    var newTeamButton: UIBarButtonItem? = nil
    var editTeamButton: UIBarButtonItem? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.managedObjectContext == nil {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            self.managedObjectContext = appDelegate.managedObjectContext
        }
        
        newTeamButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(TeamsCollectionViewController.newTeamClicked))
        editTeamButton = UIBarButtonItem(title: "Edit", style: .Plain, target:self, action: #selector(TeamsCollectionViewController.editButtonClicked))
        
        navigationItem.rightBarButtonItems = [editTeamButton!]
        navigationItem.leftBarButtonItems = []
    }
    
    func refresh(){
        viewWillAppear(true)
    }
    
    /// This code is necessary for update of the items after some object name or image is changed
    /// From some unknown reason is called Move instead of Update, hence this code is manually refresh the data
    override func viewWillAppear(animated: Bool) {
        collectionView?.reloadItemsAtIndexPaths(collectionView!.indexPathsForVisibleItems())
    }

    func newTeamClicked(){
        performSegueWithIdentifier("newTeam", sender: self)
    }
    
    func editButtonClicked(){

        setEditing(!editing, animated: true)
        updateLeftButtonBarItems(editing)

        if (editing) {
            editTeamButton?.title = "Done"
        } else {
            editTeamButton?.title = "Edit"
        }
    }

    
    func updateLeftButtonBarItems(editing: Bool){
        if (editing){
            navigationItem.leftBarButtonItems?.append(newTeamButton!)
        } else {
            navigationItem.leftBarButtonItems?.popLast()
        }
    }
    
    func editItem(object: NSManagedObject){
        performSegueWithIdentifier("editTeam", sender: self)
    }
    
    func deleteItem(object: NSManagedObject){
        let team = object as! Team
        team.deleteTeam()
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if (editing){
            let cell = collectionView.cellForItemAtIndexPath(indexPath)
            projectOptionsClick(cell!, indexPath: indexPath)
        }
    }
    
    func projectOptionsClick(cell: UICollectionViewCell, indexPath: NSIndexPath?) {
        
        let object = _fetchedResultsController?.objectAtIndexPath(indexPath!) as! NSManagedObject
        
        let optionMenu = UIAlertController(title: String(format: "Choose an action:"), message: "BlaBla", preferredStyle: .ActionSheet)
        
        let action = UIAlertAction(title: "Edit", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.editItem(object)
        })
        let action2 = UIAlertAction(title: "Delete", style: .Destructive, handler: {
            (alert: UIAlertAction!) -> Void in
            self.deleteItem(object)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        optionMenu.addAction(action)
        optionMenu.addAction(action2)
        optionMenu.addAction(cancelAction)
        
        // Musi byt pro tablety
        optionMenu.popoverPresentationController?.sourceView = cell
        optionMenu.popoverPresentationController?.sourceRect = cell.bounds
        optionMenu.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.Up
        
        presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // If someone clicked on a team button
        if segue.identifier == "teamSelected" {
            let personsViewController = segue.destinationViewController as! PersonsCollectionViewController
            // Send selected team
            if let indexPath = self.collectionView?.indexPathsForSelectedItems()?.first {
                let selectedTeam = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Team
                personsViewController.selectedTeam = selectedTeam
            }
        } else if segue.identifier == "editTeam" {
            let navigationViewController = segue.destinationViewController as! UINavigationController
            let newTeamViewController = navigationViewController.childViewControllers[0] as! TeamDetailViewController

            // Send selected team
            if let indexPath = self.collectionView?.indexPathsForSelectedItems()?.first {
                let selectedTeam = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Team
                newTeamViewController.editedTeam = selectedTeam
            }
        }
    }

    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        return !editing
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! TeamCollectionViewCell
        self.configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: UICollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        let teamCell = cell as! TeamCollectionViewCell
        let fetchedTeam = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Team
        
        let imageData = fetchedTeam.image
        if imageData != nil {
            teamCell.teamImage.image = UIImage(data: imageData!)
        }else{
            teamCell.teamImage.image = UIImage(named: "hamster")
        }
        
        teamCell.teamLabel?.text = (fetchedTeam.name)
    }
    
    // MARK: UICollectionViewDelegate

    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
/*
    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    
    
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
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
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
    
    
    // MARK: Connection between UICollectionViewController and CoreData
    
    var blockOperations: [NSBlockOperation] = []


    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        blockOperations.removeAll(keepCapacity: false)
    }
 
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        if type == NSFetchedResultsChangeType.Insert {
            blockOperations.append(
                NSBlockOperation(block: { [weak self] in
                    if let this = self {
                        this.collectionView!.insertItemsAtIndexPaths([newIndexPath!])
                    }
                    })
            )
        } else if type == NSFetchedResultsChangeType.Update {
            blockOperations.append(
                NSBlockOperation(block: { [weak self] in
                    if let this = self {
                        this.collectionView!.reloadItemsAtIndexPaths([indexPath!])
                    }
                    })
            )
        } else if type == NSFetchedResultsChangeType.Move {
            blockOperations.append(
                NSBlockOperation(block: { [weak self] in
                    if let this = self {
                        this.collectionView!.moveItemAtIndexPath(indexPath!, toIndexPath: newIndexPath!)
                    }
                    })
            )
        } else if type == NSFetchedResultsChangeType.Delete {
            //print("Delete Object: \(indexPath)")
            blockOperations.append(
                NSBlockOperation(block: { [weak self] in
                    if let this = self {
                        this.collectionView!.deleteItemsAtIndexPaths([indexPath!])
                    }
                    })
            )
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        
        if type == NSFetchedResultsChangeType.Insert {
            //print("Insert Section: \(sectionIndex)")
            blockOperations.append(
                NSBlockOperation(block: { [weak self] in
                    if let this = self {
                        this.collectionView!.insertSections(NSIndexSet(index: sectionIndex))
                    }
                    })
            )
        } else if type == NSFetchedResultsChangeType.Update {
            blockOperations.append(
                NSBlockOperation(block: { [weak self] in
                    if let this = self {
                        this.collectionView!.reloadSections(NSIndexSet(index: sectionIndex))
                    }
                    })
            )
        } else if type == NSFetchedResultsChangeType.Delete {
            print("Delete Section: \(sectionIndex)")
            
            blockOperations.append(
                NSBlockOperation(block: { [weak self] in
                    if let this = self {
                        this.collectionView!.deleteSections(NSIndexSet(index: sectionIndex))
                    }
                    })
            )
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        collectionView!.performBatchUpdates({ () -> Void in
            for operation: NSBlockOperation in self.blockOperations {
                operation.start()
            }
            }, completion: { (finished) -> Void in
                self.blockOperations.removeAll(keepCapacity: false)
        })
    }

    
    deinit {
        // Cancel all block operations when VC deallocates
        for operation: NSBlockOperation in blockOperations {
            operation.cancel()
        }
        
        blockOperations.removeAll(keepCapacity: false)
    }
}
