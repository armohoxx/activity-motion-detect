//
//  Geocoder.swift
//  location_activity
//
//  Created by phattarapon on 26/7/2565 BE.
//

import Foundation
import MapKit

class Geocoder: NSObject, NSCoding {
    
    var name: String
    var at: TimeInterval
    var coordinate: CLLocationCoordinate2D
    
    // MARK: NSCoding
    
    override init() {
        self.name = ""
        self.at = Date().timeIntervalSince1970
        self.coordinate = CLLocationCoordinate2D.init()
    }
    
    required init(coder decoder: NSCoder) {
        self.name = decoder.decodeObject(forKey: "name") as? String ?? "unnamed_street"
        self.at = decoder.decodeDouble(forKey: "at")
        let lat = decoder.decodeDouble(forKey: "lat")
        let lng = decoder.decodeDouble(forKey: "lng")
        self.coordinate = CLLocationCoordinate2D.init(latitude: lat, longitude: lng)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(at, forKey: "at")
        aCoder.encode(coordinate.latitude, forKey: "lat")
        aCoder.encode(coordinate.longitude, forKey: "lng")
    }
    
}

