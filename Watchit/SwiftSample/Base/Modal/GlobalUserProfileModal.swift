//
//  GlobalUserDataModal.swift
//  Watchit
//
//  Created by HASSAN on 14/09/23.
//

import Foundation
// MARK: - UserProfileDataModel
class UserProfileDataModel: Codable {
    let statusCode, statusMessage: String
    var firstName, lastName: String
    let countryCode: String
    var userImage : String
    var emailID: String
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case firstName = "first_name"
        case  countryCode = "countryCode"
        case lastName = "last_name"
        case emailID = "emailID"
        case userImage = "userImage"
    }
    
    required init(from decoder : Decoder) throws{
             let container = try decoder.container(keyedBy: CodingKeys.self)
        self.statusMessage = container.safeDecodeValue(forKey: .statusMessage)
        self.statusCode = container.safeDecodeValue(forKey: .statusCode)
        self.countryCode = container.safeDecodeValue(forKey: .countryCode)
        self.firstName = container.safeDecodeValue(forKey: .firstName)
        self.lastName = container.safeDecodeValue(forKey: .lastName)
        self.emailID = container.safeDecodeValue(forKey: .emailID)
        self.userImage = container.safeDecodeValue(forKey: .userImage)

    }
    init () {
        self.statusCode = ""
        self.statusMessage = ""
 
        self.firstName = ""
        self.lastName = ""
        self.countryCode = ""
  
      
        self.emailID = ""
        self.userImage = ""

    }
    
    init (_ json : JSON) {
        self.statusMessage = json.string("status_message")
        self.statusCode = json.string("status_code")
        self.firstName = json.string("first_name")
        self.lastName = json.string("last_name")
        //self.mobileNumber = json.string("mobile_number")
        self.countryCode = json.string("email_id")
        self.emailID = json.string("email_id")
        self.userImage = json.string("userImage")

    }
    func storeUserBasicDetail(){
//        Constants().STOREVALUE(value: self.firstName, keyname: USER_FIRST_NAME)
//        Constants().STOREVALUE(value: self.lastName, keyname: USER_LAST_NAME)
//        Constants().STOREVALUE(value: self.profileImage, keyname: USER_IMAGE_THUMB)
//        Constants().STOREVALUE(value: self.emailID, keyname: USER_EMAIL_ID)
//        Constants().STOREVALUE(value: self.mobileNumber, keyname: USER_PHONE_NUMBER)
//        Constants().STOREVALUE(value: self.countryCode, keyname: USER_COUNTRY_CODE)

       // Constants().STOREVALUE(value: self.gender, keyname: USER_GENDER)
    }
    


}
