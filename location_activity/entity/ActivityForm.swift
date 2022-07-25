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
    
    init(activity: String?, date: String?, confident: String, speed: Double) {
        self.activity = activity
        self.date = date
        self.confident = confident
        self.speed = speed
    }
    
    init() {
        self.id = 0
        self.activity = ""
        self.date = ""
        self.confident = ""
        self.speed = 0.0
    }
}
