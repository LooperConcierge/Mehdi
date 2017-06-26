//
//  Messages.h
//  ObjcScrollview
//
//  Created by hardik on 1/28/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Chat.h"

NS_ASSUME_NONNULL_BEGIN

@interface Messages : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
+(Messages *)insertObjectIntoMessages:(NSDictionary *)dict;

+(Messages *)updateObjectIntoMessages:(NSDictionary *)dict chatObj:(Messages *)chatObject;

+(NSFetchRequest *)fetchAllChatsMessages;

+(Messages *)fetchAllChatObjWIthID:(NSString *)mUID;

+(NSArray *)unReadCOunt:(NSArray *)arrMessage;

+(NSArray *)setMessageRead:(NSArray *)arrMessage;

+(NSFetchRequest *)fetchAllMessageObjWIth:(Chat *)chatObj;



+ (NSArray *)getMessagesOfChatId:(NSString *)chatId Offset:(NSInteger)Offset fetchLimit:(NSInteger)fetchLimit;
@end

NS_ASSUME_NONNULL_END

#import "Messages+CoreDataProperties.h"
