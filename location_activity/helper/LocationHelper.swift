//
//  LocationHelper.swift
//  location_activity
//
//  Created by phattarapon on 25/7/2565 BE.
//

import MapKit
import Foundation

protocol LocationHelperDelegate {
    func onLocationUpdated(location: Location)
    func onLocationUpdateFailed(error: Error)
}

extension NSNotification.Name {
    static let LocationHelperDidUpdatedSelectedLocation =  NSNotification.Name("ttrs.location.source.selected")
    static let LocationHelperDidUpdatedGPSLocation =  NSNotification.Name("ttrs.location.source.gps")
    static let LocationHelperDidError =  NSNotification.Name("ttrs.location.updated.error")
    static let LocationHelperShareLocation =  NSNotification.Name("ttrs.location.source.shareLocation")
}

class LocationHelper : NSObject {
    
    public var delegate: LocationHelperDelegate?
    
    /*
     * location
     *
     * Description:
     *      Get the selected location from helper
     *      Set the user's selected location as its location
     */
    private var useAlwayUpdating:Bool?
    public var location: Location?
    public var locationSelected: Location? {
        didSet {
            if Reachability.isConnectedToNetwork() {
                if let location = self.locationSelected {
                       self.geoUpdate(location: location) { (location) in
                            self.location = location
                            self.stopUpdateLocation()
                    }
                }
            }else {
                if let location = self.locationSelected {
                    self.locationUpdate(location: location){ (location) in
                            self.location = location
                    }
                }
            }
        }
    }
    
    /*
     * gpsLocation
     *
     * Description:
     *      Get detected current location that updating from GPS
     */
    private(set) var gpsLocation: Location?
    
    private var locm: CLLocationManager?
    private var geocoder: CLGeocoder?
    
    private static var instance: LocationHelper = {
        let instance = LocationHelper()
        instance.locm = CLLocationManager()
        instance.geocoder = CLGeocoder()
        return instance
    }()
    
    //MARK: Shared
    
    public static func shared() -> LocationHelper{
        return instance
    }
    
    //MARK: Functions
    
    public func update(){
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
    
    //MARK: Updater
    
    private func geoUpdate(location: Location, completionHandler: ((Location) -> Void)?) {
        self.geoUpdate(location: CLLocation.init(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), completionHandler: completionHandler)
    }
    
    private func geoUpdate(location: CLLocation, completionHandler: ((Location) -> Void)?) {
        self.geocoder?.reverseGeocodeLocation(location, completionHandler: { (places, err) in
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
                if let thoroughfare = place?.thoroughfare {
                    named = named + "\(thoroughfare), "
                }
                if let locality = place?.locality {
                    named = named + "\(locality), "
                }
                if let administrativeArea = place?.administrativeArea {
                    named = named + "\(administrativeArea), "
                }
                
                if named == "" {
                    named = NSLocalizedString("Unnamed street", comment: "")
                }
                
                let loc = Location.init(name: named, location: location, grocoder: named)
                if let delegate = self.delegate {
                    delegate.onLocationUpdated(location: loc)
                }
                
                NotificationCenter.default.post(name: .LocationHelperDidUpdatedSelectedLocation, object: loc)
                if let block = completionHandler {
                    block(loc)
                }
            }
            
        })
    }

    func stopUpdateLocation() {
        self.useAlwayUpdating = false
        self.locm?.stopUpdatingLocation()
    }
    
    private func locationUpdate(location: Location, completionHandler: ((Location) -> Void)?) {
        var loc = location
        if location.name.isEmpty {
           let coordinate = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
           let grocoder =  "\(location.coordinate.latitude) , \(location.coordinate.longitude)"
           loc = Location(name: "", location: coordinate , grocoder: grocoder)
          
        }
        self.location = loc
        NotificationCenter.default.post(name: .LocationHelperDidUpdatedSelectedLocation, object: loc)
    }
    
    func isAllowPermissionLocation() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
                case .notDetermined, .restricted, .denied:
                    print("No access")
                case .authorizedAlways, .authorizedWhenInUse:
                    print("Access")
                    return true
                @unknown default:
                break
            }
        } else {
            print("Location services are not enabled")
        }
        return false
    }
}

extension LocationHelper : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locm?.stopUpdatingLocation()
         if self.useAlwayUpdating != false {
            if locations.count > 0 {
                let loc = locations.first
                self.geoUpdate(location: loc!) { (location) in
                    self.gpsLocation = location
                    if self.location == nil {
                        self.location = location
                    }
                    
                }
            }
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

