//
//  RemoteConfigHelper.swift
//  location_activity
//
//  Created by phattarapon on 26/7/2565 BE.
//

import Foundation
import FirebaseRemoteConfig
import Mapper
import Moya
import Kingfisher

class RemoteConfigHelper: NSObject {
    
    static let shared = RemoteConfigHelper()
    
    struct RemoteConstants {
        static let TrackingMinInterval = "tracking_min_interval"
        static let RegistrationEnabled = "registration_enabled"
        static let LatestVersionOnly = "latest_version_only"
        static let AvailableLanguages = "available_languages"
        static let DefaultAuthenAPIURL = "default_authen_api_url"
        static let DefaultFrontendAPIURL = "default_frontend_api_url"
        static let DefaultPublicAPIURL = "default_public_api_url"
        static let DefaultAPIURL = "default_api_url"
        static let ParseApplicationID = "parse_application_id"
        static let MinimumRequirementEnabled = "ios_minimum_requirement_enabled"
        static let DefaultSponsorImageURL = "default_sponsor_image_url"
        static let DefaultQuarantineVerificationDeadline = "default_quarantine_verification_deadline_min"
        static let DefaultQuarantineVerificationTimeInterval = "default_quarantine_verification_time_interval"
        static let DefaultHelpURL = "manual_url"
        static let DefaultProvinceList = "province_list_rev1"
        static let DefaultOrgList = "org_list_rev1"
        static let DefaultWristbandAPIURL = "default_wristband_api_url"
        static let DefaultRadiusAreaPlace = "default_radius_area_place"
        static var DefaultTrackingMinVehicle = "tracking_min_interval_in_vehicle"
        static var DefaultTrackingMinRunning = "tracking_min_interval_running"
        static var DefaultTrackingMinWalking = "tracking_min_interval_walking"
        static let DefaultLimitIncomingCall = "limit_incoming_call"
    }

    //private let remote = RemoteConfig.remoteConfig()

    var defaultAPIURL = Constants.DefaultAPIURL
    var defaultAuthenAPIURL = Constants.DefaultAuthenAPIURL
    var defaultFrontendAPIURL = Constants.DefaultFrontendURL
    var defaultPublicAPIURL = Constants.DefaultPublicAPIURL
    var parseApplicationID = Constants.ParseApplicationID
    var defaultSponsorImageURL = Constants.DefaultSponsorImageURL
    var defaultHelpURL = Constants.DefaultHelpURL
    var defaultWristbandAPIURL = Constants.DefaultWristbandAPIURL
    var defaultProvinceList = Constants.DefaultProvinceListRev
    var defaultOrgList = Constants.DefaultOrgListRev
    var defaultRadiuses = Constants.DefaultRadiusAreaPlace
    var defaultTrackingMinVehicleInterval = Constants.DefaultTrackingMinVehicleInterval
    var defaultTrackingMinCyclingInterval = Constants.DefaultTrackingMinCyclingInterval
    var defaultTrackingMinRunningInterval = Constants.DefaultTrackingMinRunningInterval
    var defaultTrackingMinWalkingInterval = Constants.DefaultTrackingMinWalkingInterval
    var defaultTrackingMinInterval = Constants.DefaultTrackingMinInterval
    var isRegistrationEnabled = false
    var isLatestVersionOnly = false
    var minimumRequirementEnabled = false
    var defaultQuarantineVerificationDeadline: TimeInterval = 60 * 60 // min
    var defaultQuarantineVerificationTimeInterval: TimeInterval = 10 * 60 // min
    var availableLanguages = Array<Language>()
    var sponsorImage:UIImage?
    var limitIncomingCall = Constants.DefaultTime


    // Fetches the remote configs and checks thier setting-up
    func fetchRemoteConfig() {
//        var expirationTime = 3600 * 7 // 7-day for production
//        #if DEBUG
//        expirationTime = 0
//        #endif
//        self.remote.fetch(withExpirationDuration: TimeInterval(expirationTime)) { (status, _) in
//
//            if status == .success {
//                // activate
//                self.remote.activate { _,_  in
////                    if let error = error {
////                        print("cannot activate remote config due to", error.localizedDescription)
////                    }
//                }
//
//                let trackingMinInterval = self.remote.configValue(forKey: RemoteConstants.TrackingMinInterval)
//                if let trackingMinInterval = trackingMinInterval.numberValue as? Int {
//                    LocationUpdater.shared.updateMinuteThreshold = trackingMinInterval
//                    RemoteConfigHelper.shared.defaultTrackingMinInterval = trackingMinInterval
//                }
//
//                let quarantineVerificationDeadline = self.remote.configValue(forKey: RemoteConstants.DefaultQuarantineVerificationDeadline)
//                if let deadline = quarantineVerificationDeadline.numberValue as? Int {
//                    RemoteConfigHelper.shared.defaultQuarantineVerificationDeadline = TimeInterval(deadline * 60)
//                }
//
//                let quarantineTimeInterval = self.remote.configValue(forKey: RemoteConstants.DefaultQuarantineVerificationTimeInterval)
//                if let quarantineTimeInterval = quarantineTimeInterval.numberValue as? Int {
//                    RemoteConfigHelper.shared.defaultQuarantineVerificationTimeInterval = TimeInterval(quarantineTimeInterval * 60)
//                }
//
//                let apiURL = self.remote.configValue(forKey: RemoteConstants.DefaultAPIURL)
//                if let apiURL = apiURL.stringValue {
//                    RemoteConfigHelper.shared.defaultAPIURL = apiURL
//                }
//
//                let authenAPIURL = self.remote.configValue(forKey: RemoteConstants.DefaultAuthenAPIURL)
//                if let authenAPIURL = authenAPIURL.stringValue {
//                    RemoteConfigHelper.shared.defaultAuthenAPIURL = authenAPIURL
//                }
//
//                let frontendAPIURL = self.remote.configValue(forKey: RemoteConstants.DefaultFrontendAPIURL)
//                if let frontendAPIURL = frontendAPIURL.stringValue {
//                    RemoteConfigHelper.shared.defaultFrontendAPIURL = frontendAPIURL
//                }
//
//                let publicAPIURL = self.remote.configValue(forKey: RemoteConstants.DefaultPublicAPIURL)
//                if let publicAPIURL = publicAPIURL.stringValue {
//                    RemoteConfigHelper.shared.defaultPublicAPIURL = publicAPIURL
//                }
//
//                let apiWristbandURL = self.remote.configValue(forKey: RemoteConstants.DefaultWristbandAPIURL)
//                    if let apiURL = apiWristbandURL.stringValue {
//                        RemoteConfigHelper.shared.defaultWristbandAPIURL = apiURL
//                }
//
//                let parseAppID = self.remote.configValue(forKey: RemoteConstants.ParseApplicationID)
//                if let parseAppID = parseAppID.stringValue {
//                    RemoteConfigHelper.shared.parseApplicationID = parseAppID
//                }
//
//                let imageURL = self.remote.configValue(forKey: RemoteConstants.DefaultSponsorImageURL)
//                if let imageURL = imageURL.stringValue {
//                     RemoteConfigHelper.shared.defaultSponsorImageURL = imageURL
//                }
//
//                let helpURL = self.remote.configValue(forKey: RemoteConstants.DefaultHelpURL)
//                if let helpURL = helpURL.jsonValue as? [String : String] {
//                    RemoteConfigHelper.shared.defaultHelpURL = helpURL
//                }
//
//                let provinceList = self.remote.configValue(forKey: RemoteConstants.DefaultProvinceList)
//                if let provinceList = provinceList.jsonValue as? [Dictionary<String, String>] {
//                    RemoteConfigHelper.shared.defaultProvinceList = provinceList
//                }
//
//                let orgList = self.remote.configValue(forKey: RemoteConstants.DefaultOrgList)
//                if let orgList = orgList.jsonValue as? [Dictionary<String, String>] {
//                    RemoteConfigHelper.shared.defaultOrgList = orgList
//                }
//
//                let registrationEnabled = self.remote.configValue(forKey: RemoteConstants.RegistrationEnabled)
//                RemoteConfigHelper.shared.isRegistrationEnabled = registrationEnabled.boolValue
//
//                let latestVersionOnly = self.remote.configValue(forKey: RemoteConstants.LatestVersionOnly)
//                RemoteConfigHelper.shared.isLatestVersionOnly = latestVersionOnly.boolValue
//
//                let minimumRequirementEnabled = self.remote.configValue(forKey: RemoteConstants.MinimumRequirementEnabled)
//                RemoteConfigHelper.shared.minimumRequirementEnabled = minimumRequirementEnabled.boolValue
//
//                let languages = self.remote.configValue(forKey: RemoteConstants.AvailableLanguages)
//                if let jsonData = languages.jsonValue as? NSArray,
//                    let availableLanguages = Language.from(jsonData){
//                    self.availableLanguages = availableLanguages
//                    // TODO: hot-reload available languages to the app
//                }
//
//                let radiusAreaPlace = self.remote.configValue(forKey: RemoteConstants.DefaultRadiusAreaPlace)
//                if let radius = radiusAreaPlace.jsonValue as? [Double] {
//                    RemoteConfigHelper.shared.defaultRadiuses = radius
//                }
//
//                let trackingMinVehicleInterval = self.remote.configValue(forKey: RemoteConstants.DefaultTrackingMinVehicle)
//                if let trackingMinVehicleInterval = trackingMinVehicleInterval.numberValue as? Int {
//                    RemoteConfigHelper.shared.defaultTrackingMinVehicleInterval = trackingMinVehicleInterval
//                }
//
//                let trackingMinRunningInterval = self.remote.configValue(forKey: RemoteConstants.DefaultTrackingMinRunning)
//                if let trackingMinRunningInterval = trackingMinRunningInterval.numberValue as? Int {
//                    RemoteConfigHelper.shared.defaultTrackingMinRunningInterval = trackingMinRunningInterval
//                }
//
//                let trackingMinWalkingInterval = self.remote.configValue(forKey: RemoteConstants.DefaultTrackingMinWalking)
//                if let trackingMinWalkingInterval = trackingMinWalkingInterval.numberValue as? Int {
//                    RemoteConfigHelper.shared.defaultTrackingMinWalkingInterval = trackingMinWalkingInterval
//                }
//                let limitIncomingCall = self.remote.configValue(forKey: RemoteConstants.DefaultLimitIncomingCall)
//                if let time = limitIncomingCall.numberValue as? Int  {
//                    RemoteConfigHelper.shared.limitIncomingCall = time
//                }
//            }
//        }
    }
    
    // Fetches Sponsor Image
    func fetchRemoteSponsorImage(){
        if let url = URL(string: RemoteConfigHelper.shared.defaultSponsorImageURL) {
             KingfisherManager.shared.retrieveImage(with: url) { (result) in
                switch result {
                case let .success(value):
                    self.sponsorImage = value.image
                    NotificationCenter.default.post(name: .VwatchReloadSponsorImageURL, object: nil)
                    break
                default:
                    print("cannot load an image")
                }
            }
        }
    }

}
