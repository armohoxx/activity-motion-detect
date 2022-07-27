//
//  DateExtension.swift
//  location_activity
//
//  Created by phattarapon on 26/7/2565 BE.
//

import Foundation
import UIKit

extension Date {
    
    func dateString() -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd MMM yyyy"
        return dateFormat.string(from: self)
    }
    func dateStringLocaleEN() -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy/MM/dd"
        dateFormat.locale = Locale(identifier: "en_US")
        return dateFormat.string(from: self)
    }
    
    
    func dateKeyString() -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd_MMM_yyyy"
        return dateFormat.string(from: self)
    }
    
    func dateTimeString() -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd MMM yyyy HH:mm:ss"
        return dateFormat.string(from: self)
    }
    
    func dateTimeKeyString() -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd_MMM_yyyy_HH_mm_ss"
        return dateFormat.string(from: self)
    }
    
    func dateStringWithSlash() -> Date {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: self)
        let day = calendar.component(.day, from: self)
        let year = calendar.component(.year, from: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.date(from: "\(month)/\(day)/\(year)") ?? Date()
    }
    
    func HHmm() -> String {
           let timeFormat = DateFormatter()
           timeFormat.dateFormat = "HH:mm"
           return timeFormat.string(from: self)
    }
        
    func ddMMM() -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd MMM"
        dateFormat.timeZone = .current
        return dateFormat.string(from: self)
    }
    
    static func GMT07TimeInterval() -> TimeInterval {
        let alwayGMT = Int(Date().timeIntervalSince1970) + TimeZone.current.secondsFromGMT()
        let alwayGMT07 = alwayGMT + (TimeZone.init(identifier: "Asia/Bangkok")?.secondsFromGMT() ?? 25200) // 25200 = GMT+7
        return TimeInterval(alwayGMT07)
    }
    
    func dateTimeStringHHmm() -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd/MM/yyyy HH:mm"
        return dateFormat.string(from: self)
    }
}
