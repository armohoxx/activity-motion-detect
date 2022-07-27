//
//  User.swift
//  location_activity
//
//  Created by phattarapon on 26/7/2565 BE.
//

import Mapper
import UIKit

class User : NSObject, Mappable , NSCoding {
    
    var objectID: String
    var identity: String
    var sessionToken:String
    var recoveryEmail: String?
    var userData: String?
    var profile: Profile?

    required init(map: Mapper) throws {
        self.objectID = try map.from("objectId")
        self.identity = try map.from("username")
        self.sessionToken = try map.from("sessionToken")
        self.recoveryEmail = map.optionalFrom("reset_password_email")
        self.profile = nil
    }
    
    // MARK: NSCoding
    
    required init(coder decoder: NSCoder) {
        self.objectID = decoder.decodeObject(forKey: "objectId") as? String ?? ""
        self.identity = decoder.decodeObject(forKey: "identity") as? String ?? ""
        self.sessionToken = decoder.decodeObject(forKey: "sessionToken") as? String ?? ""
        self.recoveryEmail = decoder.decodeObject(forKey: "email") as? String ?? nil
        self.userData = decoder.decodeObject(forKey: "userData") as? String ?? nil
        self.profile = decoder.decodeObject(forKey: "profile") as? Profile ?? nil
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(objectID,forKey: "objectId")
        aCoder.encode(identity,forKey: "identity")
        aCoder.encode(sessionToken,forKey: "sessionToken")
        aCoder.encode(recoveryEmail,forKey: "email")
        aCoder.encode(userData,forKey: "userData")
        aCoder.encode(profile,forKey: "profile")
    }
    
}



