//
//  DBActivityHelper.swift
//  location_activity
//
//  Created by phattarapon on 22/7/2565 BE.
//

import Foundation
import SQLite

class DBActivityHelper {
    static var historyActivityTable = Table("historyActivity")
    static let id = Expression<Int>("id")
    static let activity = Expression<String?>("activity")
    static let date = Expression<String?>("date")
    static let confident = Expression<String?>("confident")
    static let speed = Expression<String?>("speed")
    
    var activityData = [ActivityForm]()
    
    static func createActivityTable() {
        guard let database = DBActivity.sharedInstance.database else {
            print("Database connection error")
            return
        }
    
        do {
            try database.run(historyActivityTable.create(ifNotExists: true) { historyActivityTable in
                historyActivityTable.column(id, primaryKey: true)
                historyActivityTable.column(activity)
                historyActivityTable.column(date)
                historyActivityTable.column(confident)
                historyActivityTable.column(speed)
            })
        } catch {
            print("historyActivityTable already exists: \(error)")
        }
    }
    
    static func insertActivity(historyActivity: ActivityForm) -> Bool? {
        var countRow: Int?
        
        guard let database = DBActivity.sharedInstance.database else {
            print("Database connection error")
            return nil
        }
        
        do {
            if let activityRow = historyActivity.activity,
               let dateRow = historyActivity.date,
               let confidentRow = historyActivity.confident,
               let speedRow = historyActivity.speed {
                
                for data in try database.prepare("select count(*) from historyActivity") {
                    if let dataCountRow: Int64 = Optional(data[0]) as? Int64 {
                        countRow = Int(dataCountRow)
                        let limitCount = (countRow ?? 0) + 1
                        
                        if limitCount > 20 {
                            print("data limit over 20 = \(String(describing: countRow))")
                            for _ in try database.prepare("delete from historyActivity where id in (select id from historyActivity LIMIT 1)") {
                                try database.run(historyActivityTable.insert(activity <- activityRow,
                                                                             date <- dateRow,
                                                                             confident <- confidentRow,
                                                                             speed <- String(speedRow)))
                            }
                        } else {
                            print("data = \(String(describing: countRow))")
                            try database.run(historyActivityTable.insert(activity <- activityRow,
                                                                         date <- dateRow,
                                                                         confident <- confidentRow,
                                                                         speed <- String(speedRow)))
                            
                            print("insert history activity")
                        }
                    } else {
                        countRow = nil
                        try database.run(historyActivityTable.insert(activity <- activityRow,
                                                                     date <- dateRow,
                                                                     confident <- confidentRow,
                                                                     speed <- String(speedRow)))
                        
                        print("insert history activity")
                    }
                }
                
            }
        } catch let error {
            print("Insert history activity failed: \(error)")
            return false
        }
        
        return false
    }
    
    func selectActivityData() -> [ActivityForm] {
        var activityId: Int?
        var activityName: String?
        var activityDate: String?
        var activityConfident: String?
        var activitySpeed: Double?
        
        guard let database = DBActivity.sharedInstance.database else {
            print("Database connection error")
            return self.activityData
        }
        
        do {
            for data in try database.prepare("select * from historyActivity order by id desc") {

                if let dataId: Int64 = Optional(data[0]) as? Int64 {
                    activityId = Int(dataId)
                 } else {
                    activityId = nil
                 }

                if let dataName: String = Optional(data[1]) as? String {
                    activityName = dataName
                } else {
                    activityName = nil
                }

                if let dataDate: String = Optional(data[2]) as? String {
                    activityDate = dataDate
                } else {
                    activityDate = nil
                }

                if let dataConfident: String = Optional(data[3]) as? String {
                    activityConfident = dataConfident
                } else {
                    activityConfident = nil
                }

                if let dataSpeed: String = Optional(data[4]) as? String {
                    activitySpeed = Double(dataSpeed)
                } else {
                    activitySpeed = nil
                }

                let activity = ActivityForm(activity: activityName,
                                            date: activityDate,
                                            confident: activityConfident ?? "",
                                            speed: activitySpeed ?? 0.0)

                self.activityData.append(activity)
            }
        } catch {
           print("electActivityData error")
        }
        
        return self.activityData
    }
}
