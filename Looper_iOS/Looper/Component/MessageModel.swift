//
//  MessageModel.swift
//  Looper
//
//  Created by rakesh on 2/1/17.
//  Copyright © 2017 rakesh. All rights reserved.
//

import Foundation

class MessageModel: NSObject
{
    
    var strMessageType = ""
    var strMessage = ""
    var strSenderId = ""
    var strReceiverId = ""
    var strSenderName = ""
    var strMembers = ""
    var strReceiverName = ""
    var strReceiverPhoto = ""
    
    
    static let sharedInstance = MessageModel()
    
}
