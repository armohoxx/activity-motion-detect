//
//  UserSession.swift
//  location_activity
//
//  Created by phattarapon on 26/7/2565 BE.
//

import UIKit

extension NSNotification.Name {
    static let UserSessionDidUpdatedDailyHistory =  NSNotification.Name("UserSessionDidUpdatedDailyHistory")
}

class UserSession {
    
    static let shared = UserSession()
    static let userSessionKey = "userSession"
    static let appToken = "appToken"
    static let isValid = "isValid"
    static let selectedLanguage = "selectedLanguage"
    static let dailyHistoryKey = "dailyHistory"
    static let timelineLocationKey = "timelineLocationKey"
    
    static let pairedWristbandUID = "pairedWristbandUID"
    static let wristbandNDEF = "wristbandNDEF"
    static let usingWristband = "usingWristband"
    static let verificationRefID = "verificationRefID"
    static let receivedVerificationSignalAt = "receivedVerificationSignalAt"
    static let isDetentionPlaceAdded = "isDetentionPlaceAdded"
    static let trackingMinInterval = "trackingMinInterval"
    static let timelineWrappedCLLocationKey = "timelineWrappedCLLocationKey"
    static let indexLocationKey = "indexLocation"
    static let roomVideoCallHistoryKey = "roomVideoCallHistory"
    static let isVideoCall = "isVideoCall"
    static let isVibrationVideoCall = "isVibrationVideoCall"
    
    var isAlreadyCheckupOnThisDay: Bool = false
    
    // MARK: User
    func IsUserLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: UserSession.isValid)
    }
    
    func setUser(user: User){
        do {
            let objUser = try NSKeyedArchiver.archivedData(withRootObject: user, requiringSecureCoding: false)
            UserDefaults.standard.set(true, forKey: UserSession.isValid)
            UserDefaults.standard.set(objUser, forKey: UserSession.userSessionKey)
            UserDefaults.standard.synchronize()
        }catch let error {
            print(error.localizedDescription)
        }
    }
    
    func getUser() -> User? {
        do {
            if let userObject = UserDefaults.standard.data(forKey: UserSession.userSessionKey),
               let user = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(userObject) as? User{
                return user
            }
        } catch let error {
            print(error.localizedDescription)
        }
        return nil
    }
    
    // MARK: Tracking Min Interval
    func setTrackingMinInterval(interval: Int) {
        UserDefaults.standard.set(interval, forKey: UserSession.trackingMinInterval)
        UserDefaults.standard.synchronize()
    }
    
    func getTrackingMinInterval() -> Int {
        var interval = UserDefaults.standard.integer(forKey: UserSession.trackingMinInterval)
        if interval <= 0 {
            interval = 10
        }
        return interval
    }
    
    // MARK: Timeline
    func addTimeline(geo: Geocoder, dateKey: String){
        guard let identity = self.getUser()?.identity else {
            return
        }
        do {
            let keyOnDay = "\(UserSession.timelineLocationKey)_\(dateKey)_\(identity)"
            var locations = self.getTimeline(dateKey: dateKey)
            locations.append(geo)
            let locationObjs = try NSKeyedArchiver.archivedData(withRootObject: locations, requiringSecureCoding: false)
            UserDefaults.standard.set(locationObjs, forKey: keyOnDay)
            UserDefaults.standard.synchronize()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func getTimeline(dateKey: String) -> [Geocoder] {
        guard let identity = self.getUser()?.identity else {
            return []
        }
        do {
            let keyOnDay = "\(UserSession.timelineLocationKey)_\(dateKey)_\(identity)"
            if let userObject = UserDefaults.standard.data(forKey: keyOnDay),
               let locations = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(userObject) as? [Geocoder]{
                return locations
            }
        } catch let error {
            print(error.localizedDescription)
        }
        return []
    }
    
    // MARK: Location in local storage
    //timelineWrappedCLLocationKey
    func addTimelineLocation(location: WrappedCLLocation){
        guard let identity = self.getUser()?.identity else {
            return
        }
        Logger.shared.debug("addTimelineLocation")
        do {
            var locations = self.getTimelineLocation()
            locations.append(location)
            let locationObjs = try NSKeyedArchiver.archivedData(withRootObject: locations, requiringSecureCoding: false)
            UserDefaults.standard.set(locationObjs, forKey: "\(UserSession.timelineWrappedCLLocationKey)_\(identity)")
            UserDefaults.standard.synchronize()
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
    
    func getTimelineLocation() -> [WrappedCLLocation] {
        guard let identity = self.getUser()?.identity else {
            return []
        }
        do {
            if let userObject = UserDefaults.standard.data(forKey: "\(UserSession.timelineWrappedCLLocationKey)_\(identity)"),
                let locations = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(userObject) as? [WrappedCLLocation]{
                return locations
            }
        } catch let error {
            print(error.localizedDescription)
        }
        return []
    }
    
    func storeLocation(){
        print("addLocation")
        let data = UserSession.shared.getTimelineLocationJsonString()
        let locationArray = data.chunked(into: 5)
        var indexdata = 0
        let indexLocation = UserSession.shared.getIndexTimelineLocation()
        for index in indexLocation..<locationArray.count {
            indexdata = index
            let locationJson = UserSession.shared.toJsonString(location: locationArray[index])
            print("locationJson = ",locationJson)
        }
        
        if indexdata == (locationArray.count - 1) {
//            UserSession.shared.clearTimelineLocation()
        }else {
            UserSession.shared.setIndexTimelineLocation(index: indexdata)
        }
    }
    
    func getTimelineLocationJsonString() -> [[String: Any]] {
        let data = UserSession.shared.getTimelineLocation()
        var jsonObject1 = [[String: Any]]()
    
        for da1 in data {
            let dd1 = da1.toJSON()
            jsonObject1.append(dd1)
        }
        return jsonObject1
    }
    
    func setIndexTimelineLocation(index: Int) {
        UserDefaults.standard.set(index, forKey: UserSession.indexLocationKey)
        UserDefaults.standard.synchronize()
    }
    
    func getIndexTimelineLocation() -> Int {
        let index = UserDefaults.standard.integer(forKey: UserSession.indexLocationKey)
        return index
    
    }
    
    func toJsonString(location:[[String: Any]]) -> String {
        if let theJSONData = try?  JSONSerialization.data(
              withJSONObject: location,
              options: .prettyPrinted
              ),
              let theJSONText = String(data: theJSONData,
                                       encoding: String.Encoding.ascii) {
            return theJSONText
        }
        return ""
    }
       
    // MARK: Setting
    func setDebugSettingForKeys(mode: DebugMode, value: Bool) {
        UserDefaults.standard.set(value, forKey: mode.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    func getDebugSettingForKeys(mode: DebugMode) -> Bool {
        if let userObject = UserDefaults.standard.object(forKey: mode.rawValue) as?  Bool {
            return userObject
        }
        return false
    }
}
