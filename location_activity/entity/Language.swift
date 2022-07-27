//
//  Language.swift
//  location_activity
//
//  Created by phattarapon on 26/7/2565 BE.
//

import Foundation
import Mapper

class Language : NSObject, Mappable {
    
    var code: String
    var name: String
    var iconURL: URL?
    var localizedFileURL: URL?
    
    required override init() {
        self.code = ""
        self.name = ""
    }
    
    required init(map: Mapper) throws {
        self.code = try map.from("code")
        self.name = try map.from("name")
        self.iconURL = map.optionalFrom("icon_url")
        self.localizedFileURL = map.optionalFrom("localized_file_url")
    }
    
    func getDefaultEmbededLanguages() -> Array<Language> {
        // TODO: change localized file urls
        let zh = Language()
        zh.code = "zh"
        zh.name = "中文"
        zh.iconURL = URL(string: "https://blog.hometify.co/localized_file/zh.png")
        zh.localizedFileURL = URL(string: "https://blog.hometify.co/localized_file/zh.strings")
        
        let en = Language()
        en.code = "en"
        en.name = "English"
        en.iconURL = URL(string: "https://blog.hometify.co/localized_file/en.png")
        en.localizedFileURL = URL(string: "https://blog.hometify.co/localized_file/en.strings")
        
        let th = Language()
        th.code = "th"
        th.name = "ไทย"
        th.iconURL = URL(string: "https://blog.hometify.co/localized_file/th.png")
        th.localizedFileURL = URL(string: "https://blog.hometify.co/localized_file/th.strings")
        return [th, en, zh]
    }
}
