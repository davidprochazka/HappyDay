//
//  Statistics.swift
//  HappyDaysCollectionVersion
//
//  Created by Ivo Pisarovic on 14/07/16.
//  Copyright © 2016 David Prochazka. All rights reserved.
//

import Foundation
import CoreData

class Statistics {
    
    var moc: NSManagedObjectContext? = nil
    
    var avg7: Double = 0
    var avg30: Double = 0
    
    init(moc: NSManagedObjectContext){
        self.moc = moc
    }
    
    func calculate(){
        let frc = performFetchRequest()
        calculateAverageMoods(frc)
    }
    
    internal func performFetchRequest()->NSFetchedResultsController{
        fatalError("Must Override")
    }
    
    internal func daysFromToday(startDate: NSDate) -> Int{
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day], fromDate: startDate, toDate: NSDate(), options: [])
        return components.day
    }
    
    internal func calculateAverageMoods(frc: NSFetchedResultsController)->Void{
        var sumWeek = 0.0
        var sumMonth = 0.0
        var countWeek = 0.0
        var countMonth = 0.0
        
        let events = frc.fetchedObjects as! [Event]
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
        
        avg7 = (round(sumWeek/countWeek*10)/10)
        avg30 = (round(sumMonth/countMonth*10)/10)
    }

}
