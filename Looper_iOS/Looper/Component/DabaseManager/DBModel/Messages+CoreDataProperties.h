//
//  Messages+CoreDataProperties.h
//  ObjcScrollview
//
//  Created by hardik on 1/28/16.
//  Copyright © 2016 looper. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Messages.h"
@class Chat;
NS_ASSUME_NONNULL_BEGIN

@interface Messages (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *mFrom;
@property (nullable, nonatomic, retain) NSNumber *mRead;
@property (nullable, nonatomic, retain) NSString *mText;
@property (nullable, nonatomic, retain) NSString *mTo;
@property (nullable, nonatomic, retain) NSString *mID;
@property (nullable, nonatomic, retain) NSString *mUID;
@property (nullable, nonatomic, retain) NSNumber *timestamp;
@property (nullable, nonatomic, retain) Chat *messageOfChat;

@end

NS_ASSUME_NONNULL_END
