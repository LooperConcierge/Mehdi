//
//  Chat+CoreDataProperties.m
//  ObjcScrollview
//
//  Created by hardik on 1/29/16.
//  Copyright © 2016 looper. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Chat+CoreDataProperties.h"

@implementation Chat (CoreDataProperties)

@dynamic chatID;
@dynamic currentUserUid;
@dynamic chatMessages;
@dynamic participants;
@dynamic unreadCount;

@end
