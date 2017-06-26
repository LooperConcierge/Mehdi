//
//  ChatParticipants+CoreDataProperties.h
//  ObjcScrollview
//
//  Created by hardik on 1/29/16.
//  Copyright © 2016 looper. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ChatParticipants.h"
@class Chat;
NS_ASSUME_NONNULL_BEGIN

@interface ChatParticipants (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *cEmail;
@property (nullable, nonatomic, retain) NSNumber *chatCreationDate;
@property (nullable, nonatomic, retain) NSString *cName;
@property (nullable, nonatomic, retain) Chat *chat;
@property (nullable, nonatomic, retain) NSString *profilePic;

@end

NS_ASSUME_NONNULL_END
