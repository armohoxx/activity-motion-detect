//
//  LocationHelper.swift
//  location_activity
//
//  Created by phattarapon on 26/7/2565 BE.
//

import MapKit
import UIKit
import Foundation

protocol LocationHelperDelegate {
    func onLocationUpdated(location: CLLocation)
    func onLocationUpdateFailed(error: Error)
}

extension NSNotification.Name {
    //static let LocationHelperDidUpdatedSelectedLocation =  NSNotification.Name("location.source.selected")
    static let LocationSpeedHelperDidUpdatedSelectedLocation =  NSNotification.Name("location.source.selected.speed")
    static let LocationHelperDidUpdatedGPSLocation =  NSNotification.Name("th.or.nstda.aat.vwatch.location.updated")
    static let LocationHelperDidError =  NSNotification.Name("th.or.nstda.aat.vwatch.location.updated.updated.error")
    static let LocationHelperShareLocation =  NSNotification.Name("th.or.nstda.aat.vwatch.location.updated.location.source.shareLocation")
}

class LocationHelper : NSObject{
    
    public var updateCompletion: ((CLLocation?) -> Void)?
    public var delegate: LocationHelperDelegate?
    
    /*
     * location
     *
     * Description:
     *      Get the selected location from helper
     *      Set the user's selected location as its location
     */
    public var location: CLLocation?
    
    private var locm: CLLocationManager?
    private var geocoder: CLGeocoder?
    
    public static var shared: LocationHelper = {
        let instance = LocationHelper()
        instance.locm = CLLocationManager()
        instance.locm?.allowsBackgroundLocationUpdates = true
        instance.locm?.desiredAccuracy = 200
        instance.geocoder = CLGeocoder()
        return instance
    }()
    
    //MARK: Functions
    
    public func update() {
        self.locm?.delegate = self
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            self.locm?.requestAlwaysAuthorization()
            break
        case .authorizedWhenInUse:
            // Enable basic location features
            self.locm?.requestAlwaysAuthorization()
            break
        case .restricted, .denied:
            // Disable location features
            break
        case .authorizedAlways:
            // Enable any of your app's location features
            break
        default:
            break
        }
        self.locm?.startUpdatingLocation()
    }
    
    public func update(completion: ((CLLocation?) -> Void)?) {
        self.updateCompletion = completion
        self.update()
    }

    func stopUpdateLocation() {
        self.locm?.stopUpdatingLocation()
    }
    
    //MARK: Updater
    
    public func geoUpdate(completionHandler: ((String) -> Void)?) {
        self.geoUpdate(locale: Locale.current, completionHandler: completionHandler)
    }
  
    public func geoUpdate(locale: Locale, completionHandler: ((String) -> Void)?) {
        //let defaultStreetName = "unnamed_street".localized()
        let defaultStreetName = "unnamed_street"
        guard let location = self.location else {
            if let block = completionHandler {
                block(defaultStreetName)
            }
            return;
        }
        self.geocoder?.reverseGeocodeLocation(location, preferredLocale: locale, completionHandler: { (places, err) in
            guard err == nil else {
                if let delegate = self.delegate {
                    delegate.onLocationUpdateFailed(error: err!)
                }
                NotificationCenter.default.post(name: .LocationHelperDidError, object: err)
                return;
            }
            
            if let places = places,
                places.count > 0 {
                var named = ""
                let place = places.first
                if let name = place?.name {
                    named = named + "\(name), "
                }
                if let thoroughfare = place?.thoroughfare {
                    named = named + "\(thoroughfare), "
                }
                if let locality = place?.locality {
                    named = named + "\(locality), "
                }
                if let administrativeArea = place?.administrativeArea {
                    named = named + "\(administrativeArea), "
                }
                if let zipcode = place?.postalCode {
                    named = named + "\(zipcode), "
                }
                
                if named == "" {
                    named = defaultStreetName
                }
                
//                let loc = Location.init(name: named, location: location, grocoder: named)
//
//                if let delegate = self.delegate {
//                    delegate.onLocationUpdated(location: loc)
//                }
//
//                NotificationCenter.default.post(name: .LocationHelperDidUpdatedSelectedLocation, object: loc)
                
                if let block = completionHandler {
                    block(named)
                }
            }
            
        })
    }

}

extension LocationHelper : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.count > 0 {
            let loc = locations.first
            let location = locations.last! as CLLocation
            let speed: Double = 3.6 * location.speed
            
            NotificationCenter.default.post(name: .LocationHelperDidUpdatedGPSLocation, object: loc)
            if let completion = self.updateCompletion {
                completion(loc)
            }
            
            if speed < 0 {
                NotificationCenter.default.post(name: .LocationSpeedHelperDidUpdatedSelectedLocation, object: 0)
            } else {
                NotificationCenter.default.post(name: .LocationSpeedHelperDidUpdatedSelectedLocation, object: speed)
            }
            self.location = loc
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let delegate = self.delegate {
            delegate.onLocationUpdateFailed(error: error)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied, .restricted, .notDetermined:
            let err = NSError(domain: "To turn on Location Services for apps. Go to Settings > Privacy > Location Services.", code: 500, userInfo:nil)
            if let delegate = self.delegate {
                delegate.onLocationUpdateFailed(error: err)
            }
            debugPrint(err.localizedDescription)
        default:
            self.update()
        }
    }
    
}
