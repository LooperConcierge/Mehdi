//
//  FirebaseChatMgr.swift
//  YouGroup
//
//  Created by Ketan on 8/19/16.
//  Copyright © 2016 YouGroup. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth
//import FirebaseCore
//import FirebaseAuth
//import FirebaseMessaging
//import SwiftyJSON

extension Array where Element: Equatable {
    func arrayRemovingObject(object: Element) -> [Element] {
        return filter { $0 != object }
    }
}


class MessageClass: NSObject {
    var strMessage: String!
    var strSenderId: String!
    var strReciverId: String!
    var strSenderName: String!
    var strReciverName: String!
    var strMembers: String!
    var strMsgType: String!
    var strTimeStamp: String!
    var urlReciverPhoto: NSURL!
}

class FirebaseChatManager: NSObject {

    let FIREBASEREF_USERS                           = "/Users/"
    let FIREBASEREF_PROFILE                         = "/Profile/"
    let FIREBASEREF_RECENT_CHAT                     = "/RecentChats/"
    let FIREBASEREF_ONETOONECHAT                    = "/OneToOne/"
    let kCurrentDateTimestamp                       = [".sv": "timestamp"]
    
    
    
    
    
    let MESSAGE_DIRECTORY                   = "/messages/"
    let RECENT_CHAT_DIRECTORY               = "/recentChat/"
    let LAST_SEEN_MSG_TIME_STAMP            = "/lastSeenMsgTimeStamp/"
    
    
    
    
    var mainRef: FIRDatabaseReference = FIRDatabaseReference()
    
    var arrUserObservers = [String]()
    var isAddObserverForRecentChatList = false
    var isAddObserverForRecentChatNewList = false
    var handle: UInt = 0
    
    // MARK:- Setup Methods
    
    class var sharedInstance : FirebaseChatManager {
      
      get {
        struct Static {
          static var instance : FirebaseChatManager? = nil
        }
        
        if !(Static.instance != nil) {
          Static.instance = FirebaseChatManager()
          Static.instance?.setUp()
        }
        
        return Static.instance!
      }
    }
    
    func setUp() {
        FIRDatabase.database().persistenceEnabled = false
        mainRef = FIRDatabase.database().reference()
    }
    
    //MARK: - Other Methods
    
    func getTimeFromTimeStemp(timeStamp: Double) -> String {
        
        let date = NSDate(timeIntervalSince1970: timeStamp/1000)
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "hh:mm a"
        return dateformatter.string(from: date as Date)
    }
    
    // MARK:- 1 to 1 - User Profile in Firebase (For get profile details)
    
    func addOrUpdateSelfUserInFireBase(userDetail: UserClass) {
        
        let strUserPath: String = String(format: "%@%@%@%@", mainRef, FIREBASEREF_USERS, userDetail.strUserId, FIREBASEREF_PROFILE)
        let firebaseUserPath = FIRDatabase.database().reference(fromURL: strUserPath)
        let userProfile = NSMutableDictionary()
        userProfile.setValue("\(userDetail.urlProfile!)", forKey:"photo")
        userProfile.setValue("\(userDetail.strName)", forKey:"name")
        userProfile.setValue(kCurrentDateTimestamp, forKey:"lastseen")
        userProfile.setValue("yes", forKey:"isonline")
        userProfile.setValue("\(userDetail.strUserId)", forKey:"userid")
        userProfile.setValue("\(userDetail.isProfileGroupEnable)", forKey:"isProfileGroupEnable")
        firebaseUserPath.updateChildValues(userProfile as [NSObject : AnyObject])
        //Auto ofline
        firebaseUserPath.child("lastseen").onDisconnectSetValue(kCurrentDateTimestamp)
        firebaseUserPath.child("isonline").onDisconnectSetValue("no")
    }
    
    func addOrUpdateOtherUserInFireBase(strUserId: String, strName:String, photo:String) {
        
        let strOtherUserURL: String = String(format: "%@%@%@/%@", mainRef, FIREBASEREF_USERS, strUserId, FIREBASEREF_PROFILE)
        let firebaseOtherUserPath = FIRDatabase.database().reference(fromURL: strOtherUserURL)
        let userProfile = NSMutableDictionary()
        userProfile.setValue("\(photo)", forKey:"photo")
        userProfile.setValue("\(strName)", forKey:"name")
        userProfile.setValue("\(strUserId)", forKey:"userid")
        
        firebaseOtherUserPath.updateChildValues(userProfile as [NSObject : AnyObject])
    }
    
    func setUserAsOnlineOrOffline(isOnline: Bool, strUserId:String) {
        
        var strStatus = "no"
        
        if(isOnline == true) {
            strStatus = "yes"
        }
        
        let strUserURL: String = String(format: "%@%@%@/%@", mainRef, FIREBASEREF_USERS, strUserId, FIREBASEREF_PROFILE)
        let firebaseUserPath = FIRDatabase.database().reference(fromURL: strUserURL)
        let userProfile = NSMutableDictionary()
        userProfile.setValue(kCurrentDateTimestamp, forKey:"lastseen")
        userProfile.setValue(strStatus, forKey:"isonline")
        firebaseUserPath.updateChildValues(userProfile as [NSObject : AnyObject])
        
        //Auto offline
        firebaseUserPath.child("isonline").onDisconnectSetValue("no")
        
    }
    
    func addObserverForUser(strUserId: String, completionHandler: @escaping (_ strUserId: String, _ conversations: Dictionary<String, AnyObject>)-> Void) {
        
        if(arrUserObservers.contains(strUserId) == false) {
            
            arrUserObservers.append(strUserId)
            
            let strUserURL: String = String(format: "%@%@%@", mainRef, FIREBASEREF_USERS, strUserId)
            let firebaseUserPath = FIRDatabase.database().reference(fromURL: strUserURL)
            
            print(strUserURL)
            
            firebaseUserPath.queryOrderedByKey().observe(.childChanged, with: { (snapShot) in
                
                let dict = snapShot.value as? Dictionary<String, AnyObject>
                completionHandler((snapShot.ref.parent?.key)!, dict!)
            })
        }
    }
    
    func getUserDetail(strUserId: String, completionHandler: @escaping (_ isSuccess: Bool, _ conversations: Dictionary<String, AnyObject>)-> Void) {
        
        let strUserURL: String = String(format: "%@%@%@%@", mainRef, FIREBASEREF_USERS, strUserId, FIREBASEREF_PROFILE)
        let firebaseUserPath = FIRDatabase.database().reference(fromURL: strUserURL)
        
        firebaseUserPath.queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapShot) in
            
            let dict = snapShot.value as? Dictionary<String, AnyObject>
            
            if(dict != nil) {
                completionHandler(true, dict!)
            }
          
        })
        
    }
  
  func getAllUserDetail(completionHandler: @escaping (_ isSuccess: Bool, _ conversations: [AnyObject])-> Void) {
    
    let strUserURL: String = String(format: "%@%@", mainRef, FIREBASEREF_USERS)
    let firebaseUserPath = FIRDatabase.database().reference(fromURL: strUserURL)
    
    firebaseUserPath.queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapShot) in
      var arrConversations = [AnyObject]()
      if let dict = snapShot.value as? Dictionary<String, AnyObject> {
        
        if dict.keys.count > 0 {
          
          for key: String in Array(dict.keys) {
            arrConversations.append(((dict[key]! as? Dictionary<String, AnyObject>)? ["Profile"])!)
          }
        }
      }
        completionHandler(true, arrConversations)
    })
    
  }
  
    //MARK: - 1 to 1 - Recent Chat List in Firebase
  
    func getRecentChatListForUser(strUserId:String, completionHandler: @escaping (_ isSuccess: Bool, _ conversations: Array<AnyObject>)-> Void) {
        
        let strRecentChatURL: String = String(format: "%@%@%@", mainRef, FIREBASEREF_RECENT_CHAT, strUserId)
        let firebaseRecentChatPath = FIRDatabase.database().reference(fromURL: strRecentChatURL)
        
        var arrConversations = Array<AnyObject>()
        
        firebaseRecentChatPath.queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapShot) in
            
            if let dict = snapShot.valueInExportFormat() as? Dictionary<String, AnyObject> {
                
//                print(dict)
                if dict.keys.count > 0 {
                    
                    for key: String in Array(dict.keys) {
                        arrConversations.append(dict[key]!)
                    }
                }
            }
            if arrConversations.count > 0
            {completionHandler(true, arrConversations)}
            else {completionHandler(true, [])}
            
        })
    }
    
    func addObserveForRecentChatNewUser(strUserId:String, completionHandler: @escaping (_ isSuccess: Bool, _ conversations: Dictionary<String, AnyObject>)-> Void) {
        
        if(isAddObserverForRecentChatNewList == false) {
            
            isAddObserverForRecentChatNewList = true
            
            let strRecentChatURL: String = String(format: "%@%@%@", mainRef, FIREBASEREF_RECENT_CHAT, strUserId)
            let firebaseRecentChatPath = FIRDatabase.database().reference(fromURL: strRecentChatURL)
            
            firebaseRecentChatPath.queryOrderedByKey().observe(.childChanged, with: { (snapShot) in
                let dict = snapShot.value as? Dictionary<String, AnyObject>
                completionHandler(true, dict!)
            })
          
          firebaseRecentChatPath.queryOrderedByKey().observe(.childRemoved, with: { (snapShot) in
            let dict = snapShot.value as? Dictionary<String, AnyObject>
            completionHandler(true, dict!)
          })
        }
    }
    
    func addObserveForRecentChatListForUser(strUserId:String, completionHandler: @escaping (_ isSuccess: Bool, _ conversations: Dictionary<String, AnyObject>)-> Void) {
        
        if(isAddObserverForRecentChatList == false) {
            
            isAddObserverForRecentChatList = true
            
            let strRecentChatURL: String = String(format: "%@%@%@", mainRef, FIREBASEREF_RECENT_CHAT, strUserId)
            let firebaseRecentChatPath = FIRDatabase.database().reference(fromURL: strRecentChatURL)
            
            firebaseRecentChatPath.queryOrderedByKey().observe(.childChanged, with: { (snapShot) in
                let dict = snapShot.value as? Dictionary<String, AnyObject>
                completionHandler(true, dict!)
            })
          
          firebaseRecentChatPath.queryOrderedByKey().observe(.childRemoved, with: { (snapShot) in
            let dict = snapShot.value as? Dictionary<String, AnyObject>
            completionHandler(true, dict!)
          })
          
        }
    }
    
    //Must call before sent message to any person
    func addUserInRecentChatListForUser(strUserId:String, strOtherUserId:String, strOtherUserName:String, strOtherUserPhoto:String, strMsg:String, strMsgType:String, completionHandler: (_ isSuccess: Bool, _ conversations: Array<AnyObject>)-> Void) {
    
        
        //This entry is created in myUserId node
        let strMyRecentChatURL: String = String(format: "%@%@%@/%@", mainRef, FIREBASEREF_RECENT_CHAT, strUserId, strOtherUserId)
        let firebaseMyRecentChatPath = FIRDatabase.database().reference(fromURL: strMyRecentChatURL)
        
        let dictMyRecentChatInfo = NSMutableDictionary()
        dictMyRecentChatInfo.setValue(strOtherUserId, forKey:"userid")
        dictMyRecentChatInfo.setValue(strOtherUserName, forKey:"name")
        dictMyRecentChatInfo.setValue(strOtherUserPhoto, forKey:"photo")
        dictMyRecentChatInfo.setValue(strMsg, forKey:"msg")
        dictMyRecentChatInfo.setValue(strMsgType, forKey:"msgType")
        dictMyRecentChatInfo.setValue(kCurrentDateTimestamp, forKey:"msgtime")
        dictMyRecentChatInfo.setValue("no", forKey:"isgroup")
        
        firebaseMyRecentChatPath.updateChildValues(dictMyRecentChatInfo as [NSObject : AnyObject])
        
        addOrUpdateOtherUserInFireBase(strUserId: strOtherUserId, strName: strOtherUserName, photo: strOtherUserPhoto)
      
        //This entry is created in OtherUserId node
        let strOtherRecentChatURL: String = String(format: "%@%@%@/%@", mainRef, FIREBASEREF_RECENT_CHAT, strOtherUserId, strUserId)
        let firebaseOtherRecentChatPath = FIRDatabase.database().reference(fromURL: strOtherRecentChatURL)
        
        let userObj = LooperUtility.getCurrentUser()
        let dictOtherRecentChatInfo = NSMutableDictionary()
        dictOtherRecentChatInfo.setValue(strUserId, forKey:"userid")
        dictOtherRecentChatInfo.setValue(userObj?.vFullName!, forKey:"name")
        //dictOtherRecentChatInfo.setValue("\(UserClass.sharedInstance.urlProfile!)", forKey:"photo")
        dictOtherRecentChatInfo.setValue("\(userObj!.vProfilePic!)", forKey:"photo")
        dictOtherRecentChatInfo.setValue(strMsg, forKey:"msg")
        dictOtherRecentChatInfo.setValue(strMsgType, forKey:"msgType")
        dictOtherRecentChatInfo.setValue(kCurrentDateTimestamp, forKey:"msgtime")
        dictOtherRecentChatInfo.setValue(kCurrentDateTimestamp, forKey:"lastseen")
        dictOtherRecentChatInfo.setValue("yes", forKey:"isonline")
        dictOtherRecentChatInfo.setValue("no", forKey:"isgroup")
        
        firebaseOtherRecentChatPath.updateChildValues(dictOtherRecentChatInfo as [NSObject : AnyObject])
        
    }
    
    
    func sendMessageInOneToOneChat(msgObject: MessageClass) {
        
        addUserInRecentChatListForUser(strUserId: msgObject.strSenderId!, strOtherUserId: msgObject.strReciverId!, strOtherUserName: msgObject.strReciverName!, strOtherUserPhoto: "\(msgObject.urlReciverPhoto!)", strMsg: msgObject.strMessage!, strMsgType: msgObject.strMsgType!) { (isSuccess, conversations) in
        }
        
        var strMessageURL = ""
        
        if(Int(msgObject.strSenderId)! < Int(msgObject.strReciverId)!) {
            strMessageURL = String(format: "%@%@%@_%@", self.mainRef, self.FIREBASEREF_ONETOONECHAT, msgObject.strSenderId, msgObject.strReciverId)
        }
        else {
            strMessageURL = String(format: "%@%@%@_%@", self.mainRef, self.FIREBASEREF_ONETOONECHAT, msgObject.strReciverId, msgObject.strSenderId)
        }
        
        let firebaseMessagePath = FIRDatabase.database().reference(fromURL: strMessageURL)
        let message = NSMutableDictionary()
        message.setValue(msgObject.strSenderName!, forKey:"sendername")
        message.setValue(msgObject.strSenderId!, forKey:"senderid")
        message.setValue(self.kCurrentDateTimestamp, forKey:"messagetimestamp")
        message.setValue(msgObject.strMsgType!, forKey:"type")
        message.setValue(msgObject.strMessage, forKey:"messgae")
        message.setValue(msgObject.strReciverId! , forKey:"reciverid")
        let messageRef = firebaseMessagePath.childByAutoId()
        messageRef.setValue(message)
        
        //Add message for notification
        
        let strNotificationUrl = String(format: "%@/queue/tasks", self.mainRef)
        let firebaseNotiPath = FIRDatabase.database().reference(fromURL: strNotificationUrl)
        let notiMsg = NSMutableDictionary()
        
        notiMsg.setValue(msgObject.strSenderId!, forKey:"senderid")
        notiMsg.setValue(msgObject.strMessage!, forKey:"messgae")
        notiMsg.setValue(msgObject.strReciverId!, forKey:"reciverid")
        notiMsg.setValue(msgObject.strSenderName!, forKey:"sendername")
        notiMsg.setValue("", forKey:"groupid")
        notiMsg.setValue("", forKey:"groupname")
        
        let notiRef = firebaseNotiPath.childByAutoId()
        notiRef.setValue(notiMsg)
        //FIRMessaging.messaging().subscribe(toTopic: strNotificationUrl)
      
    }
    
    //MARK: - 1 to 1 - Get Messages
    
    func removeObserverNewMessageInChatScreen(isGroup:Bool, strUserId:String, strOtherId:String, completionHandler: (_ isSuccess: Bool, _ conversations: Dictionary<String, AnyObject>)-> Void) {
        
        var strMessageURL = ""
        
        if(isGroup == true) {
            strMessageURL = String(format: "%@%@%@", self.mainRef, self.FIREBASEREF_ONETOONECHAT, strOtherId)
        }
        else {
            
            if(Int(strUserId)! < Int(strOtherId)!) {
                strMessageURL = String(format: "%@%@%@_%@", self.mainRef, self.FIREBASEREF_ONETOONECHAT, strUserId, strOtherId)
            }
            else {
                strMessageURL = String(format: "%@%@%@_%@", self.mainRef, self.FIREBASEREF_ONETOONECHAT, strOtherId, strUserId)
            }
        }
        
        let messagePath = FIRDatabase.database().reference(fromURL: strMessageURL)
        
        messagePath.removeObserver(withHandle: handle)
    }
    
    func removeRecentChatObserverNewMessageInChatScreen(isGroup:Bool, strUserId:String, completionHandler: (_ isSuccess: Bool, _ conversations: Dictionary<String, AnyObject>)-> Void) {
        
        
        let strRecentChatURL: String = String(format: "%@%@%@", mainRef, FIREBASEREF_RECENT_CHAT, strUserId)
        let firebaseRecentChatPath = FIRDatabase.database().reference(fromURL: strRecentChatURL)
        firebaseRecentChatPath.removeObserver(withHandle: handle)
    }
    
    func addObserveForNewMessageInChatScreen(isGroup:Bool, strUserId:String, strLastTime:String ,strOtherId:String, completionHandler: @escaping (_ isSuccess: Bool, _ conversations: Dictionary<String, AnyObject>)-> Void) {
        
        var strMessageURL = ""
        
        if(isGroup == true) {
            strMessageURL = String(format: "%@%@%@", self.mainRef, self.FIREBASEREF_ONETOONECHAT, strOtherId)
        }
        else {
            
            if(Int(strUserId)! < Int(strOtherId)!) {
                strMessageURL = String(format: "%@%@%@_%@", self.mainRef, self.FIREBASEREF_ONETOONECHAT, strUserId, strOtherId)
            }
            else {
                strMessageURL = String(format: "%@%@%@_%@", self.mainRef, self.FIREBASEREF_ONETOONECHAT, strOtherId, strUserId)
            }
            
        }
        
        print("Add Observe: \(strMessageURL)")
        print("Time : \(NSNumber.init(value: Double(strLastTime)!+1000))")

        let messagePath = FIRDatabase.database().reference(fromURL: strMessageURL)
        
        handle = messagePath.queryOrdered(byChild: "messagetimestamp").queryStarting(atValue: NSNumber.init(value: Double(strLastTime)!+1)).observe(.childAdded, with:  { (snapShot) in
        
            let dict = snapShot.value as? Dictionary<String, AnyObject>
            completionHandler(true, dict!)
        })
    }
    
//    func getLastMessage(strUserId:String, strOtherId:String, strLastMessageTimestemp:AnyObject, completionHandler: (isSuccess: Bool, conversations: Array<AnyObject>)-> Void) {
//        
//        var strChatId = ""
//        
//        if(Int(strUserId) < Int(strOtherId)) {
//            strChatId = String(format: "%@%@%@_%@", self.mainRef, self.FIREBASEREF_ONETOONECHAT, strUserId, strOtherId)
//        }
//        else {
//            strChatId = String(format: "%@%@%@_%@", self.mainRef, self.FIREBASEREF_ONETOONECHAT, strOtherId, strUserId)
//        }
//        
//        let messagePath = FIRDatabase.database().referenceFromURL(strChatId)
//        
//        var messages = Array<AnyObject>()
//        
//        messagePath.queryOrderedByChild("messagetimestamp").queryStartingAtValue(strLastMessageTimestemp).observeEventType(.ChildAdded, withBlock: { (snapShot) in
//            
//            if let dict = snapShot.value as? Dictionary<String, AnyObject> {
//                
//                if dict.keys.count > 0 {
//                    
//                    for key: String in Array(dict.keys) {
//                        messages.append(dict[key]!)
//                    }
//                }
//            }
//            
//            completionHandler(isSuccess: true, conversations: messages)
//            
//        })
//    }
    
    
    func totalNumberOfMessages(isGroup:Bool, strUserId:String, strOtherId:String, completionHandler: @escaping (_ counter: Int)-> Void) {
        
        var strMessageURL = ""
        
        if(isGroup == true) {
            strMessageURL = String(format: "%@%@%@", self.mainRef, self.FIREBASEREF_ONETOONECHAT, strOtherId)
        }
        else {
            
            if(Int(strUserId)! < Int(strOtherId)!) {
                strMessageURL = String(format: "%@%@%@_%@", self.mainRef, self.FIREBASEREF_ONETOONECHAT, strUserId, strOtherId)
            }
            else {
                strMessageURL = String(format: "%@%@%@_%@", self.mainRef, self.FIREBASEREF_ONETOONECHAT, strOtherId, strUserId)
            }
        }
        
        let messagePath = FIRDatabase.database().reference(fromURL: strMessageURL)
        
        messagePath.observeSingleEvent(of: .value, with:  { (snapshot) in
            let counts =  Int(snapshot.childrenCount)
            completionHandler(counts)
        })
    }

    
    func getListMessages(isGroup:Bool, strUserId:String, strOtherId:String, Counter: UInt, completionHandler: @escaping (_ isSuccess: Bool, _ conversations: Array<AnyObject>)-> Void) {

        print("Limit Counter: \(Counter)")

        var strMessageURL = ""
        
        if(isGroup == true) {
            strMessageURL = String(format: "%@%@%@", self.mainRef, self.FIREBASEREF_ONETOONECHAT, strOtherId)
        }
        else {
            if(Int(strUserId)! < Int(strOtherId)!) {
                strMessageURL = String(format: "%@%@%@_%@", self.mainRef, self.FIREBASEREF_ONETOONECHAT, strUserId, strOtherId)
            }
            else {
                strMessageURL = String(format: "%@%@%@_%@", self.mainRef, self.FIREBASEREF_ONETOONECHAT, strOtherId, strUserId)
            }
        }
        
        var messages = Array<AnyObject>()
        let messagePath = FIRDatabase.database().reference(fromURL: strMessageURL)
      
        messagePath.queryLimited(toLast: Counter).observeSingleEvent(of: .value, with: { (snapShot) in
            
            if let dict = snapShot.value as? Dictionary<String, AnyObject> {
                
                if dict.keys.count > 0 {
                    
                    for key: String in Array(dict.keys) {
                        
                       // print(dict[key])
                        
                        messages.append(dict[key]!)
                    }
                }
            }
            
            completionHandler(true, messages)
        })
    }
    /*
    func sendMediaMessageToOneToOneChat(imgData:NSData, strOtherUser:String, strUserName:String, urlPhoto:NSURL) {
        
        let imageName = NSUUID().uuidString
        
        let storage = FIRStorage.storage().reference().child("\(imageName).png")
        storage.put(imgData as Data, metadata: nil) { (data, error) in
            
            if(error != nil) {
                //print(error)
                return
            }
            
            let messageDetial = MessageClass()
            messageDetial.strMsgType = "image"
            messageDetial.strMessage = data?.downloadURL()?.absoluteString
            messageDetial.strSenderId = UserDefault.getUserId()
            messageDetial.strReciverId = strOtherUser
            messageDetial.strSenderName = UserDefault.getUserName()
            messageDetial.strReciverName = strUserName
            messageDetial.urlReciverPhoto = urlPhoto
            
            FirebaseChatManager.sharedInstance.sendMessageInOneToOneChat(msgObject: messageDetial)
        }
    }
  */
  func removeOneToOneUser(strUserId:String,strOtherUserID:String,completionHandler: @escaping (_ isSuccess: Bool)-> Void) {
    
    let strMyRecentChatURL: String = String(format: "%@%@%@/%@", mainRef, FIREBASEREF_RECENT_CHAT, strUserId, strOtherUserID)
    
    let strOtherRecentChatURL: String = String(format: "%@%@%@/%@", mainRef, FIREBASEREF_RECENT_CHAT, strOtherUserID,strUserId)
    
    let firebaseRecentChatPathOther = FIRDatabase.database().reference(fromURL: strOtherRecentChatURL)
    
    firebaseRecentChatPathOther.removeValue()
    
    let firebaseRecentChatPath = FIRDatabase.database().reference(fromURL: strMyRecentChatURL)
    
    firebaseRecentChatPath.removeValue { (error, reference) in
      
      var strMessageURL = ""
      if(error == nil){
        
        if(Int(strUserId)! < Int(strOtherUserID)!) {
          strMessageURL = String(format: "%@%@%@_%@", self.mainRef, self.FIREBASEREF_ONETOONECHAT, strUserId, strOtherUserID)
        }
        else {
          strMessageURL = String(format: "%@%@%@_%@", self.mainRef, self.FIREBASEREF_ONETOONECHAT, strOtherUserID, strUserId)
        }
        let firebaseMessagePath = FIRDatabase.database().reference(fromURL: strMessageURL)
        firebaseMessagePath.removeValue()
        completionHandler(true)
      }
      else{
        completionHandler(false)
      }
    }
  }
 
    //MARK: - Geroup Chat - Create Group
    
    var Timestamp: Int64 {
        let milliSeconds = Int64(NSDate().timeIntervalSince1970 * 1000)
        return milliSeconds
    }
    
    func changeGroupName(strGroupId:String, strName:String, strMembers:String) {
        
        let strOtherUserURL: String = String(format: "%@%@%@/%@", mainRef, FIREBASEREF_USERS, strGroupId, FIREBASEREF_PROFILE)
        let firebaseOtherUserPath = FIRDatabase.database().reference(fromURL: strOtherUserURL)
        let userProfile = NSMutableDictionary()
        userProfile.setValue("\(strName)", forKey:"name")
        firebaseOtherUserPath.updateChildValues(userProfile as [NSObject : AnyObject])
        
        var arrIds = strMembers.components(separatedBy: ",")
        
        for i in 0..<arrIds.count {
         
            let strRecentChatURL: String = String(format: "%@%@%@/%@", mainRef, FIREBASEREF_RECENT_CHAT, arrIds[i], strGroupId)
            let firebaseRecentChatPath = FIRDatabase.database().reference(fromURL: strRecentChatURL)
            firebaseRecentChatPath.updateChildValues(userProfile as [NSObject : AnyObject])
        }
        
    }
    /*
  func createGroupInFireBase(strName:String, strMembers:String, imgData:Data, completionHandler: @escaping (_ isSuccess: Bool,_ dicGroupInfo:NSMutableDictionary)-> Void) {
        
        let imageName = NSUUID().uuidString
      
        let storage = FIRStorage.storage().reference().child("\(imageName).png")
        storage.put(imgData as Data, metadata: nil) { (data, error) in
            
            if(error != nil) {
               // print(error)
                return
            }
          
            let strGroupID = "\(self.Timestamp)"
          
            let dicGroupInfo = self.createUpdateGroupInFirebase(strGroupName: strName, strMembers: strMembers, strGroupID: strGroupID, isCreated: false, data: data)
          
          completionHandler(true,dicGroupInfo)
            
        }
    }

    
  func updateGroupInFireBase(strGroupID:String,strName:String, strMembers:String, imgData:Data?, completionHandler: @escaping (_ isSuccess: Bool)-> Void) {
    
    if imgData != nil {
      
      let imageName = NSUUID().uuidString
      
      let storage = FIRStorage.storage().reference().child("\(imageName).png")
      storage.put(imgData!, metadata: nil) { (data, error) in
        
        if(error != nil) {
          // print(error)
          return
        }
        
        completionHandler(true)
        
       _ = self.createUpdateGroupInFirebase(strGroupName: strName, strMembers: strMembers, strGroupID: strGroupID, isCreated: false, data: data)
        
      }
      
    }
    else{
    
      completionHandler(true)
      
     _ = self.createUpdateGroupInFirebase(strGroupName: strName, strMembers: strMembers, strGroupID: strGroupID, isCreated: false, data: nil)
    
    }
    
  }
  
 
    
  func createUpdateGroupInFirebase(strGroupName:String,strMembers:String,strGroupID:String,isCreated:Bool,data:FIRStorageMetadata?) -> NSMutableDictionary {
    
    let strUserPath: String = String(format: "%@%@%@%@", self.mainRef, self.FIREBASEREF_USERS, strGroupID, self.FIREBASEREF_PROFILE)
    let firebaseUserPath = FIRDatabase.database().reference(fromURL: strUserPath)
    
    let userProfile = NSMutableDictionary()
    if isCreated {
      userProfile.setValue(data?.downloadURL()?.absoluteString, forKey:"photo")
    }
    else{
      if data != nil {
        userProfile.setValue(data?.downloadURL()?.absoluteString, forKey:"photo")
      }
    }
    userProfile.setValue("\(strGroupName)", forKey:"name")
    userProfile.setValue(self.kCurrentDateTimestamp, forKey:"lastseen")
    userProfile.setValue("", forKey:"isonline")
    userProfile.setValue("\(strGroupID)", forKey:"userid")
    userProfile.setValue("\(strMembers)", forKey:"members")
    
    firebaseUserPath.updateChildValues(userProfile as [NSObject : AnyObject])
    //Auto ofline
    firebaseUserPath.child("lastseen").onDisconnectSetValue(self.kCurrentDateTimestamp)
    
    var arrIds = strMembers.components(separatedBy:",")
    
    for i in 0..<arrIds.count {
      
      let strMyRecentChatURL: String = String(format: "%@%@%@/%@", self.mainRef, self.FIREBASEREF_RECENT_CHAT, arrIds[i], strGroupID)
      let firebaseMyRecentChatPath = FIRDatabase.database().reference(fromURL: strMyRecentChatURL)
      
      let dictMyRecentChatInfo = NSMutableDictionary()
      dictMyRecentChatInfo.setValue(strGroupID, forKey:"userid")
      dictMyRecentChatInfo.setValue(strGroupName, forKey:"name")
      if isCreated {
        dictMyRecentChatInfo.setValue(data?.downloadURL()?.absoluteString, forKey:"photo")
        dictMyRecentChatInfo.setValue("Welcome to group", forKey:"msg")
      }
      else{
        if data != nil {
          dictMyRecentChatInfo.setValue(data?.downloadURL()?.absoluteString, forKey:"photo")
        }
        
        //dictMyRecentChatInfo.setValue("", forKey:"msg")
      }

      dictMyRecentChatInfo.setValue("text", forKey:"msgType")
      dictMyRecentChatInfo.setValue(self.kCurrentDateTimestamp, forKey:"msgtime")
      dictMyRecentChatInfo.setValue("yes", forKey:"isgroup")
      dictMyRecentChatInfo.setValue(strMembers, forKey:"members")
      
      firebaseMyRecentChatPath.updateChildValues(dictMyRecentChatInfo as [NSObject : AnyObject])
      
    }
    
    return userProfile
  }
   */
  
  func deleteGroupInFirebase(strMembers:String,strGroupID:String,completionHandler: @escaping (_ isSuccess: Bool)-> Void) {
    
    // remove Profile User
    
    let strUserPath: String = String(format: "%@%@%@%@", self.mainRef, self.FIREBASEREF_USERS, strGroupID, self.FIREBASEREF_PROFILE)
    let firebaseUserPath = FIRDatabase.database().reference(fromURL: strUserPath)
    
    firebaseUserPath.removeValue()
    
    var arrIds = strMembers.components(separatedBy:",")
    
    // remove Recent Chat User
    
    for i in 0..<arrIds.count {
      
      let strMyRecentChatURL: String = String(format: "%@%@%@/%@", self.mainRef, self.FIREBASEREF_RECENT_CHAT, arrIds[i], strGroupID)
      let firebaseMyRecentChatPath = FIRDatabase.database().reference(fromURL: strMyRecentChatURL)
      
      firebaseMyRecentChatPath.removeValue()
      
    }
    
    // remove Group Chat
    
    let strChatPath: String = String(format: "%@%@%@", self.mainRef, self.FIREBASEREF_ONETOONECHAT, strGroupID)
    let firebaseChatPath = FIRDatabase.database().reference(fromURL: strChatPath)
    
    firebaseChatPath.removeValue()
    
    completionHandler(true)
  }
  /*
    func sendMediaMessageToGroupChat(imgData:NSData, msgObject: MessageClass) {
      
        let imageName = NSUUID().uuidString
      
        let storage = FIRStorage.storage().reference().child("\(imageName).png")
        storage.put(imgData as Data, metadata: nil) { (data, error) in
          
            if(error != nil) {
                //print(error)
                return
            }
            
            msgObject.strMessage = data?.downloadURL()?.absoluteString
            self.sendMessageInGroupChat(msgObject: msgObject)
        }
    }
    */
    func sendMessageInGroupChat(msgObject: MessageClass) {
        
        var arrIds = msgObject.strMembers.components(separatedBy: ",")//componentsSeparated(by: ",")
        
        for i in 0..<arrIds.count {
            
            let strMyRecentChatURL: String = String(format: "%@%@%@/%@", self.mainRef, self.FIREBASEREF_RECENT_CHAT, arrIds[i], msgObject.strReciverId)
            let firebaseMyRecentChatPath = FIRDatabase.database().reference(fromURL: strMyRecentChatURL)
            
            let dictMyRecentChatInfo = NSMutableDictionary()
            dictMyRecentChatInfo.setValue(msgObject.strMessage, forKey:"msg")
            dictMyRecentChatInfo.setValue(msgObject.strMsgType, forKey:"msgType")
            dictMyRecentChatInfo.setValue(self.kCurrentDateTimestamp, forKey:"msgtime")
            
            firebaseMyRecentChatPath.updateChildValues(dictMyRecentChatInfo as [NSObject : AnyObject])
            
        }
        
        
        
        let strMessageURL = String(format: "%@%@%@", self.mainRef, self.FIREBASEREF_ONETOONECHAT, msgObject.strReciverId)
        
        let firebaseMessagePath = FIRDatabase.database().reference(fromURL: strMessageURL)
        let message = NSMutableDictionary()
        message.setValue(msgObject.strSenderName, forKey:"sendername")
        message.setValue(msgObject.strSenderId, forKey:"senderid")
        message.setValue(self.kCurrentDateTimestamp, forKey:"messagetimestamp")
        message.setValue(msgObject.strMsgType, forKey:"type")
        message.setValue(msgObject.strMessage, forKey:"messgae")
        message.setValue(msgObject.strMembers , forKey:"reciverid")
        let messageRef = firebaseMessagePath.childByAutoId()
        messageRef.setValue(message)
        
        //Add message for notification
        
        let strNotificationUrl = String(format: "%@/queue/tasks", self.mainRef)
        let firebaseNotiPath = FIRDatabase.database().reference(fromURL: strNotificationUrl)
        let notiMsg = NSMutableDictionary()
        
        notiMsg.setValue(msgObject.strSenderId, forKey:"senderid")
        notiMsg.setValue(msgObject.strMessage, forKey:"messgae")
        notiMsg.setValue(msgObject.strMembers, forKey:"reciverid")
        notiMsg.setValue(msgObject.strSenderName, forKey:"sendername")
        notiMsg.setValue(msgObject.strReciverId, forKey:"groupid")
        notiMsg.setValue(msgObject.strReciverName, forKey:"groupname")
        
        let notiRef = firebaseNotiPath.childByAutoId()
        notiRef.setValue(notiMsg)
        
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func clearCooky()
    {
        URLCache.shared.removeAllCachedResponses()
        
        // deleting any associated cookies
        if let cookies = HTTPCookieStorage.shared.cookies{
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
    }
    /*
    func leaveUserFromGroup(strUserId:String, strMembers:String, strGroupId:String, completionHandler: (_ isSuccess: Bool)-> Void) {
        
        var arrIds = strMembers.components(separatedBy: ",")
        arrIds = arrIds.arrayRemovingObject(object: strUserId)
      
        let strIds = arrIds.joined(separator: ",")
        let strGroupProfileURL = String(format: "%@%@%@%@", self.mainRef, self.FIREBASEREF_USERS, strGroupId, FIREBASEREF_PROFILE)
        
        let firebaseGroupPath = FIRDatabase.database().reference(fromURL: strGroupProfileURL)
        let userProfile = NSMutableDictionary()
        userProfile.setValue("\(strIds)", forKey:"members")
        firebaseGroupPath.updateChildValues(userProfile as [NSObject : AnyObject])
      
        
        let strRecentChatURL: String = String(format: "%@%@%@/%@", mainRef, FIREBASEREF_RECENT_CHAT, strUserId, strGroupId)
        let firebaseMessagePath = FIRDatabase.database().reference(fromURL: strRecentChatURL)
        firebaseMessagePath.removeValue()
        
        
        for i in 0..<AppUtility.shared.arrRecentChat.count {
            
          let dictUserDetail = AppUtility.shared.arrRecentChat[i] as! [String:AnyObject]
          
            if(dictUserDetail["userid"]?.stringValue == strGroupId) {
                AppUtility.shared.arrRecentChat.remove(at: i)
                break
            }
        }
        
        let temp = NSMutableDictionary()
        temp.setValue(strIds, forKey:"members")
        
        for i in 0..<arrIds.count {
            let strGroupProfileURL = String(format: "%@%@%@/%@", self.mainRef, self.FIREBASEREF_RECENT_CHAT, arrIds[i], strGroupId)
            let firebaseUserPath = FIRDatabase.database().reference(fromURL: strGroupProfileURL)
            firebaseUserPath.updateChildValues(temp as [NSObject : AnyObject])
        }
      
        completionHandler(true)
        
    }
  

  func getGroupUserList(strMembers:String , completionHandler: @escaping (_ isSuccess: Bool, _ conversations: NSMutableArray)-> Void) {
    let arrUsers = strMembers.components(separatedBy: ",") as NSArray
    let arrUserDetail = NSMutableArray()
    //for strUserID in arrUsers {
    
      self.getAllUserDetail(completionHandler: { (isSuccess, arrAllUsers) in
        
        
        for strUserID in arrUsers {
          let predicate = NSPredicate(format: "userid == %@", strUserID as! String)
          let arrFilter = arrAllUsers.filter{ predicate.evaluate(with: $0) }
        
          if arrFilter.count > 0{
            
            let discInfo = arrFilter.first as! Dictionary<String, AnyObject>
          
            let maches = MyMatchesModel()
            maches.vName = discInfo["name"] as! String?
            maches.iUserID = discInfo["userid"] as! String?
            maches.vProfilePicture = discInfo["photo"] as! String?
            
            if maches.iUserID == (arrUsers.firstObject as! String){
              
              arrUserDetail.insert(maches, at: 0)
            }
            else{
              
              arrUserDetail.add(maches)
              
            }
          }
        }
        
        completionHandler(true,arrUserDetail)
      })
  }
  */
}
