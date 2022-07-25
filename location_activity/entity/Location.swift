//
//  Location.swift
//  location_activity
//
//  Created by phattarapon on 25/7/2565 BE.
//

import Mapper
import MapKit

class Location : NSObject, NSCoding, Mappable {
    
    var name: String
    var geocoder: String
    var coordinate: CLLocationCoordinate2D
    var referenceIndex: Int?
    var locationDescription: String?
    var locationImage: UIImage?
    var locationImageUrl: URL?
    
    required init(map: Mapper) throws {
        self.coordinate = CLLocationCoordinate2D.init()
        if let lat: Double = map.optionalFrom("location_coordinate.latitude"),
            let lng: Double = map.optionalFrom("location_coordinate.longitude"){
            self.coordinate = CLLocationCoordinate2D.init(latitude: lat, longitude: lng)
        }
        self.locationDescription = map.optionalFrom("location_description")
        self.geocoder = map.optionalFrom("location_geocoder") ?? ""
        self.name = map.optionalFrom("location_name") ?? ""
    }
    
    init(name: String, location: CLLocation, grocoder: String) {
        self.name = name
        self.geocoder = grocoder
        self.coordinate = location.coordinate
    }
    
    init(name: String, location: CLLocation, grocoder: String,locationDescription: String?,locationImage: UIImage?) {
        self.name = name
        self.geocoder = grocoder
        self.coordinate = location.coordinate
        self.locationDescription = locationDescription
        self.locationImage = locationImage
    }
    
    // MARK: NSCoding
    required init(coder decoder: NSCoder) {
        name = decoder.decodeObject(forKey: "name") as? String ?? ""
        geocoder = decoder.decodeObject(forKey: "geocoder") as? String ?? ""
        let la = decoder.decodeFloat(forKey: "latitude")
        let lo = decoder.decodeFloat(forKey: "longitude")
        let cll = CLLocation(latitude: CLLocationDegrees(la),longitude: CLLocationDegrees(lo))
        coordinate = cll.coordinate
        locationDescription = decoder.decodeObject(forKey: "description") as? String ?? ""
        locationImage = decoder.decodeObject(forKey: "image") as? UIImage ?? nil
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name,forKey: "name")
        aCoder.encode(geocoder,forKey: "geocoder")
        aCoder.encode(coordinate.latitude,forKey: "latitude")
        aCoder.encode(coordinate.longitude,forKey: "longitude")
        aCoder.encode(coordinate.longitude,forKey: "longitude")
        aCoder.encode(locationDescription,forKey: "description")
        aCoder.encode(locationImage,forKey: "image")
    }
}
