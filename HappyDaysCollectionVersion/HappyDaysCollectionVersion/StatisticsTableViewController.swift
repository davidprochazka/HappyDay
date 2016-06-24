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


class StatisticsTableViewController: UITableViewController, MFMailComposeViewControllerDelegate, NSFetchedResultsControllerDelegate {

    var managedObjectContext: NSManagedObjectContext? = nil

    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.managedObjectContext == nil {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            self.managedObjectContext = appDelegate.managedObjectContext
        }
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
        let cell = tableView.dequeueReusableCellWithIdentifier("teamStatCell", forIndexPath: indexPath) as! StatisticsTableViewCell
        let team = fetchedResultsController.objectAtIndexPath(indexPath) as! Team
        
        cell.teamName.text = team.name
        //cell.rating.text = team.
        return cell
    }
 

    func daysFromToday(startDate: NSDate) -> Int
    {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day], fromDate: startDate, toDate: NSDate(), options: [])
        return components.day
    }
    
    func calculateAverageMoods()->Void{
        var sumWeek = 0.0
        var sumMonth = 0.0
        var countWeek = 0.0
        var countMonth = 0.0
        
        let events = self.fetchedResultsController.fetchedObjects as! [Event]
        for actEvent in events{
            
            let differenceInDays = daysFromToday(actEvent.timeStamp!)
            
            if (differenceInDays < 7){
                sumWeek += Double(actEvent.happiness!)
                sumMonth += Double(actEvent.happiness!)
                countWeek += 1
                countMonth += 1
            } else if (differenceInDays < 30){
                sumMonth += Double(actEvent.happiness!)
                countMonth += 1
            }
        }
        
        //currentMoodLabel.text = selectedMood?.description
        //weekMoodLabel.text = (round(sumWeek/countWeek*10)/10).description
        //monthMoodLabel.text = (round(sumMonth/countMonth*10)/10).description
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
    
    func getCsvLine(event: Event) -> String {
        let time = event.timeStamp! ?? ""
        let rating = event.happiness! ?? ""
        let name = event.person!.name ?? ""
        let team = event.person!.team!.name ?? ""
        
        return "\(time),\(rating),\(name),\(team)\n"
    }
    
    func storeDataIntoCsv () -> String{
        let events = self.fetchedResultsController.fetchedObjects as! [Event]
        
        // 2
        let exportFilePath = NSTemporaryDirectory() + "export.csv"
        let exportFileURL = NSURL(fileURLWithPath: exportFilePath)
        NSFileManager.defaultManager().createFileAtPath(exportFilePath, contents: NSData(), attributes: nil)
        
        let fileHandle: NSFileHandle?
        do {
            fileHandle = try NSFileHandle(forWritingToURL: exportFileURL)
        } catch {
            let nserror = error as NSError
            print("ERROR: \(nserror)")
            fileHandle = nil
        }
        
        if let fileHandle = fileHandle {
            // 4
            for event in events {
                
                fileHandle.seekToEndOfFile()
                let csvData = getCsvLine(event).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
                fileHandle.writeData(csvData!)
            }
            
            // 5
            fileHandle.closeFile()
        }
        
        return exportFilePath;
    }
    
    @IBAction func exportData(sender: AnyObject) {
        let filePath = storeDataIntoCsv()
        sendMailWithFile(filePath)
    }
    
    func sendMailWithFile(filePath: String) {
        if( MFMailComposeViewController.canSendMail() ) {
            
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            
            mailComposer.setSubject("Data export from HappyDay aplication")
            let now = NSDate().description
            mailComposer.setMessageBody("Data export from \(now).)." , isHTML: false)
            
            if let fileData = NSData(contentsOfFile: filePath) {
                mailComposer.addAttachmentData(fileData, mimeType: "text/plain", fileName: "export.csv")
            }
            
            self.presentViewController(mailComposer, animated: true, completion: nil)
        } else {
            // pokud neni definovany klient s uctem
            let alertController = UIAlertController(title: "Email account not set", message:
                "Please, add at least one email account to your device. This account will be used to send the data.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
