//
//  ActivityForm.swift
//  location_activity
//
//  Created by phattarapon on 22/7/2565 BE.
//

import UIKit

struct ActivityForm {
    var id: Int?
    var activity: String?
    var date: String?
    var confident: String?
    var speed: Double?
    var location: String?
    
    init(activity: String?, date: String?, confident: String, speed: Double, location: String) {
        self.activity = activity
        self.date = date
        self.confident = confident
        self.speed = speed
        self.location = location
    }
    
    init() {
        self.id = 0
        self.activity = ""
        self.date = ""
        self.confident = ""
        self.speed = 0.0
    }
}
