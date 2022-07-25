//
//  DBActivity.swift
//  location_activity
//
//  Created by phattarapon on 22/7/2565 BE.
//

import Foundation
import SQLite
import UIKit

class DBActivity {
    static let sharedInstance: DBActivity = DBActivity()
    var database: Connection? = nil
    let filename: String = "DBActivity.sqlite"
    
    private init() {
        do {
            let documentDirectory = try FileManager.default.url(for: .applicationSupportDirectory,
                                                                in: .userDomainMask,
                                                                appropriateFor: nil, create: true)
            let directoryURL = documentDirectory.appendingPathComponent("location-activity-app").appendingPathComponent("Database")
            
            do {
                try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Someting wrong in folder DB")
            }
            
            let fileUrl = try! FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("location-activity-app").appendingPathComponent("Database").appendingPathComponent(filename)
            
            database = try Connection(fileUrl.path)
        } catch {
            print("create connection to database error : \(error)")
            //database = nil
        }
    }
    
    func createTable() {
        DBActivityHelper.createActivityTable()
    }
}
