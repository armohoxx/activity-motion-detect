//
//  Profile.swift
//  location_activity
//
//  Created by phattarapon on 26/7/2565 BE.
//

import Mapper
import UIKit
import MapKit

class Profile: NSObject, Mappable , NSCoding {
    
    var name: String
    var lastname: String
    var identityType: Int
    var email: String?
    var telephone: String?
    var language: String?
    var departCountry: String?
    var notificationToken: String?
    var certificationToken: String?
    var registrationCertificationToken: String?
    var dailyHistory: String?
    var isTrack: Bool
    var isReportedDone: Bool
    var isDetentionPlaceAdded: Bool
    var reportedQuarantineAt: TimeInterval
    var reportedStartedAt: TimeInterval
    var reportedUpdatedAt: TimeInterval
    var reportedEndAt: TimeInterval
    var detentions: [ShelterInPlace] = []

    required init(map: Mapper) throws {
        self.name = try map.from("data.name")
        self.lastname = try map.from("data.lname")
        self.identityType = try map.from("data.identity_type")
        self.reportedQuarantineAt = try map.from("data.reported_quarantine_at")
        self.reportedStartedAt = try map.from("data.reported_started_at")
        self.reportedUpdatedAt = try map.from("data.reported_updated_at")
        self.reportedEndAt = try map.from("data.reported_end_at")
        self.email = map.optionalFrom("data.email")
        self.telephone = map.optionalFrom("data.tel")
        self.departCountry = map.optionalFrom("data.depart_country")
        self.notificationToken = map.optionalFrom("data.appnotification_token")
        self.certificationToken = map.optionalFrom("data.cert_token")
        self.registrationCertificationToken = map.optionalFrom("data.cert_register")
        self.dailyHistory = map.optionalFrom("data.daily_history")
        self.isTrack = map.optionalFrom("data.is_track") ?? true
        self.isReportedDone = map.optionalFrom("data.reported_done") ?? false
        self.isDetentionPlaceAdded = map.optionalFrom("data.is_detention_place_added") ?? false
       
        var dataDetention:[NSDictionary]?
        dataDetention = map.optionalFrom("data.detention")
        if let dataPlace = dataDetention {
            for data in dataPlace {
                if let place = ShelterInPlace.from(data) {
                    place.provinceID = map.optionalFrom("data.province_id")
                    detentions.append(place)
                }
            }
        }
        
//        #warning("mockup")
//        let home = ShelterInPlace()
//        home.selectedCoordinate = CLLocationCoordinate2D(latitude: 14.0604891, longitude: 100.5962051)
//        let workPlace = ShelterInPlace()
//        workPlace.selectedCoordinate = CLLocationCoordinate2D(latitude: 14.076561, longitude: 100.6004755)
//        self.detentions = [home, workPlace]
    }
    
    // MARK: NSCoding
    
    required init(coder decoder: NSCoder) {
        self.name = decoder.decodeObject(forKey: "name") as? String ?? ""
        self.lastname = decoder.decodeObject(forKey: "lname") as? String ?? ""
        self.identityType = decoder.decodeInteger(forKey: "identity_type")
        self.email = decoder.decodeObject(forKey: "email") as? String
        self.telephone = decoder.decodeObject(forKey: "telephone") as? String
        self.departCountry = decoder.decodeObject(forKey: "depart_country") as? String
        self.notificationToken = decoder.decodeObject(forKey: "appnotification_token") as? String
        self.certificationToken = decoder.decodeObject(forKey: "cert_token") as? String
        self.registrationCertificationToken = decoder.decodeObject(forKey: "cert_register") as? String
        self.dailyHistory = decoder.decodeObject(forKey: "daily_history") as? String
        self.isTrack = decoder.decodeBool(forKey: "is_track")
        self.reportedQuarantineAt = decoder.decodeDouble(forKey: "reported_quarantine_at")
        self.reportedStartedAt = decoder.decodeDouble(forKey: "reported_started_at")
        self.reportedUpdatedAt = decoder.decodeDouble(forKey: "reported_updated_at")
        self.reportedEndAt = decoder.decodeDouble(forKey: "reported_end_at")
        self.isReportedDone = decoder.decodeBool(forKey: "reported_done")
        self.isDetentionPlaceAdded = decoder.decodeBool(forKey: "is_detention_place_added")
        self.detentions = decoder.decodeObject(forKey: "detention") as? [ShelterInPlace] ?? []
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name,forKey: "name")
        aCoder.encode(lastname,forKey: "lname")
        aCoder.encode(identityType, forKey: "identity_type")
        aCoder.encode(email,forKey: "email")
        aCoder.encode(telephone,forKey: "telephone")
        aCoder.encode(notificationToken,forKey: "appnotification_token")
        aCoder.encode(certificationToken,forKey: "cert_token")
        aCoder.encode(registrationCertificationToken, forKey: "cert_register")
        aCoder.encode(dailyHistory,forKey: "daily_history")
        aCoder.encode(isTrack, forKey: "is_track")
        aCoder.encode(reportedQuarantineAt, forKey: "reported_quarantine_at")
        aCoder.encode(reportedStartedAt, forKey: "reported_started_at")
        aCoder.encode(reportedUpdatedAt, forKey: "reported_updated_at")
        aCoder.encode(reportedEndAt, forKey: "reported_end_at")
        aCoder.encode(departCountry, forKey: "depart_country")
        aCoder.encode(isReportedDone, forKey: "reported_done")
        aCoder.encode(isDetentionPlaceAdded, forKey: "is_detention_place_added")
        aCoder.encode(detentions, forKey: "detention")
    }
    
}
