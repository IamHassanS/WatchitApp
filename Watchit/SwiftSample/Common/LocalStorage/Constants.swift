

import Foundation
import UIKit

// MARK: - Application Details
/**
 isSimulator is a Global Variable.isSimulator used to identfy the current running mechine
 - note : Used in segregate Simulator and device to do appropriate action
 */
var isSimulator : Bool { return TARGET_OS_SIMULATOR != 0 }
/**
 AppVersion is a Global Variable.AppVersion used to get the current app version from info plist
 - note : Used in Force update functionality to get newer version update
 */
var AppVersion : String? = { return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String }()


// MARK: - UserDefaults Easy Access
/**
 userDefaults is a Global Variable.
 - note : userDefaults used to store and retrive details from Local Storage (Short Access)
 */
let userDefaults = UserDefaults.standard

var Global_UserProfile = UserProfileDataModel()


let infoPlist = PlistReader<InfoPlistKeys>()
/**
 */
let APIBaseUrl : String = (infoPlist?.value(for: .App_URL) ?? "").replacingOccurrences(of: "\\", with: "")
let APIImageUrlString = (infoPlist?.value(for: .Image_URL) ?? "").replacingOccurrences(of: "\\", with: "")

 let APIUrl : String = APIBaseUrl
//+ "api/"

//let Global_UserType : String = "User" //(infoPlist?.value(for: .UserType) ?? "")
