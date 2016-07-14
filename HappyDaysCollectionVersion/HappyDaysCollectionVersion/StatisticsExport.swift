//
//  StatisticsExport.swift
//  HappyDaysCollectionVersion
//
//  Created by Ivo Pisarovic on 14/07/16.
//  Copyright © 2016 David Prochazka. All rights reserved.
//

import Foundation
import CoreData
import MessageUI

class StatisticsExport: NSObject, MFMailComposeViewControllerDelegate {
    
    var ctrl: UIViewController
    var moc: NSManagedObjectContext
    
    init(ctrl: UIViewController, moc: NSManagedObjectContext){
        self.ctrl = ctrl
        self.moc = moc
    }
    
    func sendCsvInMail(){
        let filePath = storeDataIntoCsv()
        sendMailWithFile(filePath)
    }
    
    func getCsvLine(event: Event) -> String {
        let time = event.timeStamp! ?? ""
        let rating = event.happiness! ?? ""
        let name = event.person!.name ?? ""
        let team = event.person!.team!.name ?? ""
        
        return "\(time!),\(rating!),\(name),\(team)\n"
    }
    
    internal func fetchAllEvents()->NSFetchedResultsController{
        let fetchRequest = NSFetchRequest()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entityForName("Event", inManagedObjectContext: self.moc)
        fetchRequest.entity = entity
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.moc, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //print("Unresolved error \(error), \(error.userInfo)")
            abort()
        }
        
        return fetchedResultsController
    }
    
    func storeDataIntoCsv () -> String{
        let events = fetchAllEvents().fetchedObjects as! [Event]
        
        // 2
        let exportFilePath = NSTemporaryDirectory() + "my_mood.csv"
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
    
    func sendMailWithFile(filePath: String) {
        if( MFMailComposeViewController.canSendMail() ) {
            
            let mailComposer = MFMailComposeViewController()
            
            // Delegate must be UIViewController !!! Otherwise it crashes!
            mailComposer.mailComposeDelegate = ctrl as? MFMailComposeViewControllerDelegate
            
            mailComposer.setSubject("Your data export from Happy Days aplication")
            let now = NSDate().description
            mailComposer.setMessageBody("Data export from \(now).)." , isHTML: false)
            
            if let fileData = NSData(contentsOfFile: filePath) {
                mailComposer.addAttachmentData(fileData, mimeType: "text/plain", fileName: "export.csv")
            }
            
            ctrl.presentViewController(mailComposer, animated: true, completion: nil)
        } else {
            // pokud neni definovany klient s uctem
            let alertController = UIAlertController(title: "Email account not set", message:
                "Please, add at least one email account to your device. This account will be used to send the data.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            
            ctrl.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
}
