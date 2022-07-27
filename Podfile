source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '12.0'

  def core
    use_frameworks!
    inhibit_all_warnings!
    pod 'Alamofire'
    pod 'SQLite.swift', '~> 0.11.5'
    pod 'FMDB'
    pod 'Firebase/Core'
    pod 'Firebase/Messaging'
    pod 'Firebase/Analytics'
    pod 'Firebase/RemoteConfig'
    pod 'Kingfisher'
    pod 'Moya'
    pod 'ModelMapper'
    pod 'XCGLogger', '~> 7.0.1'
  end

  def uikits
    use_frameworks!
    inhibit_all_warnings!
    pod 'MBProgressHUD'
    pod 'Localize-Swift', '~> 2.0'
  end

target 'location_activity' do
  core
  uikits
end
