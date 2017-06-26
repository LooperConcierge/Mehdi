//
//  Chat+CoreDataProperties.h
//  ObjcScrollview
//
//  Created by hardik on 1/29/16.
//  Copyright © 2016 looper. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Chat.h"

NS_ASSUME_NONNULL_BEGIN

@interface Chat (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *chatID;
@property (nullable, nonatomic, retain) NSNumber *unreadCount;
@property (nullable, nonatomic, retain) NSString *currentUserUid;
@property (nullable, nonatomic, retain) NSSet<Messages *> *chatMessages;
@property (nullable, nonatomic, retain) ChatParticipants *participants;

@end

@interface Chat (CoreDataGeneratedAccessors)

- (void)addChatMessagesObject:(Messages *)value;
- (void)removeChatMessagesObject:(Messages *)value;
- (void)addChatMessages:(NSSet<Messages *> *)values;
- (void)removeChatMessages:(NSSet<Messages *> *)values;

@end

NS_ASSUME_NONNULL_END
