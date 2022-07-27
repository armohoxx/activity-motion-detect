//
//  LocationUpdater.swift
//  location_activity
//
//  Created by phattarapon on 26/7/2565 BE.
//

import Foundation
import UIKit
import MapKit
import XCGLogger

class LocationUpdater: NSObject {
    
    public static var shared: LocationUpdater = {
        let instance = LocationUpdater()
        instance.restoreBufferedLocations()
        return instance
    }()
    var lastUpdated: Date = Date()
    var bgIdentifier: UIBackgroundTaskIdentifier = .invalid
    var isUpdating: Bool = false
    var updateMinuteThreshold: Int = 10
    
    /*
     * locationsInLatestArea
     *
     * Discussion:
     *      The list of locations that appear in latest area eg. Area0, Area1 or OutOfArea. Changed the area, the stored locations are cleared.
     */
    var locationsInLatestArea: [WrappedCLLocation] = []
    let locationsInLatestAreaKey = "LocationsInLatestAreaKey"
    
    /*
     *  startUpdater
     *
     *  Discussion:
     *      Spawns an updater and pushes the latest location to api
     *      An interval of updating is configurated on remote config using UpdateMinuteThreshold key.
     */
    func startUpdater(){
        if self.isUpdating {
            Logger.shared.debug("[Updater] locationUpdater is currently updating...")
            return
        }
        self.isUpdating = true
        
        if let location = LocationHelper.shared.location {
            self.postTrackedLocation(location)
        }
        
        LocationHelper.shared.update { (lastLocation) in
            let calender:Calendar = Calendar.current
            let diff = calender.dateComponents([.hour, .minute, .second], from: self.lastUpdated, to: Date())
            if let min = diff.minute {
                self.updateMinuteThreshold = UserSession.shared.getTrackingMinInterval()
                //MARK: push activity (กิจกรรมดำเนินอยู่เเล้วหยุดนิ่งจะทำไงดี?)
                if (min >= self.updateMinuteThreshold) {
                    Logger.shared.debug("postTrackedLocation min : \(self.updateMinuteThreshold)")
                    self.postTrackedLocation(lastLocation)
                    self.lastUpdated = Date()
                }
            }
        }
    }
    
    func postTrackedLocation(_ lastLocation: CLLocation?) {
        self.bgIdentifier = UIApplication.shared.beginBackgroundTask(withName: "th.or.nectec.updater.task.tracker") {
            self.loggingNotification(message: "the background task is expired")
        }
        
        if let user = UserSession.shared.getUser(),
            user.profile?.isTrack == true {
            var postMessage = "posted location failed,"
            
            if let lastLocation = lastLocation {
                let wrappedLocation: WrappedCLLocation = self.manipulateWrappedLocation(location: lastLocation)
                self.locationsInLatestArea.append(wrappedLocation)
                self.syncBufferedLocations()
                
                postMessage = String.init(format: "%@ posts %f, %f, horizontalAcc=%.0f, inArea=%d, refID=%d, distance=%.0fm, duration=%ds", user.identity, wrappedLocation.coordinate.latitude, wrappedLocation.coordinate.longitude, wrappedLocation.horizontalAccuracy, wrappedLocation.isInArea, wrappedLocation.referenceDetentionNumber, wrappedLocation.distance, wrappedLocation.durationInArea)
                self.loggingNotification(message: postMessage)
                
                if Reachability.isConnectedToNetwork() {
                    Logger.shared.debug("Reachability : isConnectedToNetwork")
                }else{
                    Logger.shared.debug("Reachability : not isConnectedToNetwork")
                    UserSession.shared.addTimelineLocation(location: wrappedLocation)
                }
                
                #if DEBUG
                Logger.shared.debug("skiped post the location due to debugging")
                #else
                NetworkAdapter.request(target: .LocationCheckup(user: user, location: wrappedLocation), success: { (response) in
                    // nothing todo
                }) { (error) in
                    self.loggingNotification(message: "\(postMessage) \(error.localizedDescription)")
                }
                #endif
                self.loggingNotification(message: "the background task is ended")
                
                // store in local storage
                LocationHelper.shared.geoUpdate { (name) in
                    let now = Date()
                    let geo = Geocoder()
                    geo.name = name
                    geo.at = now.timeIntervalSince1970
                    geo.coordinate = wrappedLocation.coordinate
                    UserSession.shared.addTimeline(geo: geo, dateKey: now.dateKeyString())
                }
                
                UIApplication.shared.endBackgroundTask(self.bgIdentifier)
            }else{
                self.loggingNotification(message: "\(postMessage) due to no location")
            }
        }else{
            loggingNotification(message: "location helper stopped tracking due to no actived user, or non-tracking user")
            LocationHelper.shared.stopUpdateLocation()
        }
    }
    
    func loggingNotification(message: String){
        Logger.shared.debug(message)
        let debug = UserSession.shared.getDebugSettingForKeys(mode: .DebuggingNotificationEnabled)
        if debug {
            let content = UNMutableNotificationContent()
            content.title = "Updater Tracker"
            content.body = message
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest(identifier: "UpdaterNotification", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
        
    }
    
}

/*
 * Saves or restores a list of locations in latest area.
 */
extension LocationUpdater {
    
    private func restoreBufferedLocations() {
        let unarchived = UserDefaults.standard.data(forKey: locationsInLatestAreaKey)
        var storedLocations: [WrappedCLLocation] = []
        do {
            if unarchived != nil {
                storedLocations = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(unarchived!) as! [WrappedCLLocation]
            }
        } catch let error {
            debugPrint(error.localizedDescription)
        }
        self.locationsInLatestArea = storedLocations
    }
    
    private func syncBufferedLocations(){
        do {
            let encodedData = try NSKeyedArchiver.archivedData(withRootObject: self.locationsInLatestArea, requiringSecureCoding: false)
            UserDefaults.standard.set(encodedData, forKey: locationsInLatestAreaKey)
            UserDefaults.standard.synchronize()
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }
    
}

/*
 * Location buffering and calculating area of self-quarantine features
 * Reference area, isInArea, Duration
 */
extension LocationUpdater {
    
    private func manipulateWrappedLocation(location: CLLocation) -> WrappedCLLocation {
        let at = Date().timeIntervalSince1970
        
        // is user in self-quarantine area ?
        var candidateLocations: [WrappedCLLocation] = []
        let expectedRadiuses: [CLLocationDistance] = RemoteConfigHelper.shared.defaultRadiuses
        if let profile = UserSession.shared.getUser()?.profile {
            for (index, detention) in profile.detentions.enumerated() {
                if let useRadius = (index < expectedRadiuses.count) ? expectedRadiuses[index] : expectedRadiuses.last {
                    if let coordinate = detention.selectedCoordinate {
                        
                        // create candidate
                        let wrappedLocation = WrappedCLLocation(location: location)
                        wrappedLocation.at = at
                        wrappedLocation.setIsInArea(using: coordinate, radius: useRadius)
                        wrappedLocation.radiuses = expectedRadiuses
                        wrappedLocation.referenceDetentionNumber = index
                        candidateLocations.append(wrappedLocation)
                    }
                }
            }
        }
        
        // select wrapped location that will be sent to an api.
        var selectedWrappedLocation = WrappedCLLocation(location: location) // default
        
        // checking the candidate information
        for candidate in candidateLocations {
            if candidate.isInArea {
                selectedWrappedLocation = candidate // is in area ?
                break
            } else if selectedWrappedLocation.distance == 0 {
                selectedWrappedLocation = candidate // replace the default
            } else if (candidate.distance < selectedWrappedLocation.distance) {
                selectedWrappedLocation = candidate // replaced, if the distance is lowest
            }
        }
        
        // how much time that the user spend on this area
        if let latestStoredLocation = self.locationsInLatestArea.last {
            if selectedWrappedLocation.isInArea == latestStoredLocation.isInArea,
               selectedWrappedLocation.referenceDetentionNumber == latestStoredLocation.referenceDetentionNumber {
                // still on the same area from previous loc
            } else {
                self.locationsInLatestArea = []
            }
        }
        
        selectedWrappedLocation.setDuration(using: self.locationsInLatestArea)
        return selectedWrappedLocation
    }
    
}

