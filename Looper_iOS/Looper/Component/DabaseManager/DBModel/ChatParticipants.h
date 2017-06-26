//
//  ChatParticipants.h
//  ObjcScrollview
//
//  Created by hardik on 1/28/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Chat.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatParticipants : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

+(ChatParticipants *)insertObjectIntoChatParticipants:(NSDictionary *)dict chatObj:(Chat *)chatObj;

+(ChatParticipants *)updateObjectIntoChatParticipants:(NSDictionary *)dict chatObj:(ChatParticipants *)chatObject chat:(Chat *)chat;

+(NSArray *)fetchAllChatsParticipants;

+(ChatParticipants *)fetchChatParticipantWithUserEmail:(NSString *)email;

@end

NS_ASSUME_NONNULL_END

#import "ChatParticipants+CoreDataProperties.h"
