//
//  WrappedCLLocation.swift
//  location_activity
//
//  Created by phattarapon on 26/7/2565 BE.
//

import Foundation
import MapKit

class WrappedCLLocation: CLLocation {
    
    var at: TimeInterval = Date().timeIntervalSince1970
    var isInArea: Bool = false
    var durationInArea: Int64 = 0
    var distance: CLLocationDistance = 0
    var radiuses: [CLLocationDistance] = [50, 500]
    var referenceDetentionNumber: Int = 0
    
    init(location: CLLocation) {
        super.init(coordinate: location.coordinate, altitude: location.altitude, horizontalAccuracy: location.horizontalAccuracy, verticalAccuracy: location.verticalAccuracy, timestamp: location.timestamp)
        self.at = Date().timeIntervalSince1970
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.at = coder.decodeDouble(forKey: "at")
        self.isInArea = coder.decodeBool(forKey: "is_in_area")
        self.durationInArea = coder.decodeInt64(forKey: "duration")
        self.distance = coder.decodeDouble(forKey: "distance")
        self.radiuses = coder.decodeObject(forKey: "radiuses") as! [CLLocationDistance]
        self.referenceDetentionNumber = coder.decodeInteger(forKey: "ref_detention_id")
    }
    
    override func encode(with coder: NSCoder) {
        super.encode(with: coder)
        coder.encode(self.at, forKey: "at")
        coder.encode(self.isInArea, forKey: "is_in_area")
        coder.encode(self.durationInArea, forKey: "duration")
        coder.encode(self.radiuses, forKey: "radiuses")
        coder.encode(self.distance, forKey: "distance")
        coder.encode(self.referenceDetentionNumber, forKey: "ref_detention_id")
    }
    
    func radiusesJoined() -> String{
        var radiusesStringArray: [String] = []
        for radius in self.radiuses {
            radiusesStringArray.append("\(radius)")
        }
        return radiusesStringArray.joined(separator: ",")
    }
    
}

extension WrappedCLLocation {
    
    public func setDuration(using list: [WrappedCLLocation]) {
        if let firstLocation = list.first {
            self.durationInArea = Int64(self.at - firstLocation.at)
        } else {
            self.durationInArea = 0
        }
    }
    
    public func setIsInArea(using coordinate: CLLocationCoordinate2D, radius: CLLocationDistance) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let distance:CLLocationDistance = self.distance(from: location)
        self.distance = distance
        self.isInArea = (distance <= radius)
    }
    
}


extension WrappedCLLocation {
    
    func toJSON() -> Dictionary<String, Any> {
        return [
            "last_lat": self.coordinate.latitude,
            "last_lng": self.coordinate.latitude,
            "accuracy": self.horizontalAccuracy,
            "is_home": (self.referenceDetentionNumber == 0),
            "is_in_area": self.isInArea,
            "reference_area": self.referenceDetentionNumber,
            "duration": self.durationInArea,
            "radiuses": self.radiusesJoined()
        ]
    }
}

