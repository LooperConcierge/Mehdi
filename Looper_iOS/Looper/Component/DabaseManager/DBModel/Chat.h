//
//  Chat.h
//  ObjcScrollview
//
//  Created by hardik on 1/28/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

@class ChatParticipants, Messages;

NS_ASSUME_NONNULL_BEGIN


@interface Chat : NSManagedObject

+(Chat*)insertObjectIntoChat:(NSDictionary *)dict;

+(Chat *)updateObjectIntoChat:(NSDictionary *)dict chatObj:(Chat *)chatObject;

+(Chat *)fetchObjectWithID:(NSString *)chatID;

+(NSFetchRequest *)fetchAllChatsForCurrentUser;

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "Chat+CoreDataProperties.h"
