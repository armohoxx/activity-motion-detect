//
//  ShelterInPlace.swift
//  location_activity
//
//  Created by phattarapon on 26/7/2565 BE.
//

import Foundation
import Mapper
import MapKit

class ShelterInPlace: NSObject, Mappable, NSCoding {
    
    var address: String?
    var province: String?
    var provinceID: String?
    var detectedCoordinate: CLLocationCoordinate2D?
    var detectedAccuracy: CLLocationAccuracy = 0
    var selectedCoordinate: CLLocationCoordinate2D?
    var selectedAccuracy: CLLocationAccuracy = 0
    
    override init() {
        
    }
    
    required init(map: Mapper) throws {
      
        self.address = map.optionalFrom("address")
        self.province = map.optionalFrom("province")
        self.provinceID = map.optionalFrom("province_id")
        if let lat: CLLocationDegrees = map.optionalFrom("detected_lat"),
            let lng: CLLocationDegrees = map.optionalFrom("detected_lng") {
            self.detectedCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            if let accuracy: CLLocationAccuracy = map.optionalFrom("detected_accuracy") {
                self.detectedAccuracy = accuracy
            }
        }
        
        if let lat: CLLocationDegrees = map.optionalFrom("selected_lat"),
            let lng: CLLocationDegrees = map.optionalFrom("selected_lng") {
            self.selectedCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            if let accuracy: CLLocationAccuracy = map.optionalFrom("selected_accuracy") {
                self.selectedAccuracy = accuracy
            }
        }
    }
    
    // MARK: NSCoding
    
    required init(coder decoder: NSCoder) {
        self.address = decoder.decodeObject(forKey: "address") as? String
        self.province = decoder.decodeObject(forKey: "province") as? String
        self.provinceID = decoder.decodeObject(forKey: "province_id") as? String
        let lat = decoder.decodeDouble(forKey: "detected_coord_lat")
        let lng = decoder.decodeDouble(forKey: "detected_coord_lng")
        self.detectedCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        self.detectedAccuracy = CLLocationAccuracy(decoder.decodeInteger(forKey: "detected_accuracy"))
        let selectedLat = decoder.decodeDouble(forKey: "selected_coord_lat")
        let selectedLng = decoder.decodeDouble(forKey: "selected_coord_lng")
        self.selectedCoordinate = CLLocationCoordinate2D(latitude: selectedLat, longitude: selectedLng)
        self.selectedAccuracy = CLLocationAccuracy(decoder.decodeInteger(forKey: "selected_accuracy"))
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.address, forKey: "address")
        aCoder.encode(self.province, forKey: "province")
        aCoder.encode(self.provinceID, forKey: "province_id")
        aCoder.encode(Double(self.detectedCoordinate?.latitude ?? 0), forKey: "detected_coord_lat")
        aCoder.encode(Double(self.detectedCoordinate?.longitude ?? 0), forKey: "detected_coord_lng")
        aCoder.encode(Int(self.detectedAccuracy), forKey: "detected_accuracy")
        aCoder.encode(Double(self.selectedCoordinate?.latitude ?? 0), forKey: "selected_coord_lat")
        aCoder.encode(Double(self.selectedCoordinate?.longitude ?? 0), forKey: "selected_coord_lng")
        aCoder.encode(Int(self.selectedAccuracy), forKey: "selected_accuracy")
    }
    
}
