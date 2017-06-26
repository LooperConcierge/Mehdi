//
//  UserClass.swift
//  SocialNetworkApp
//
//  Created by Ketan on 5/20/16.
//
//

import UIKit
///import SwiftyJSON

class UserClass: NSObject {
    
    var strEmail = ""
    var strPassword = ""
    var strDevice_token = ""
    var strFacebookId = ""
    var strTwitterId = ""
    var strAccess_Token = ""
    var strName = ""
    var strlastSeenTime = ""
    var strUserId = ""
    var strUserName = ""
    var strBio = ""
    var strWebsite = ""
    var strCountry = ""
    var strFollowStatus = ""
    var strMsgFrom = ""
    var isProfileGroupEnable = ""
    //var isGroup = false
    var isJoinComm = false
    var isOnLine = false
    var isPrivacyOn = false
    
    var urlProfile: NSURL?
    
    var profileImage: UIImage?
    
    
    
    static let sharedInstance = UserClass()
    
    //MARK: - Chatting
    var arrFriends = [UserClass]()
    var arrMessages = [AnyObject]()
    var intUnreadMsgCountUser = 0
    
  
}
