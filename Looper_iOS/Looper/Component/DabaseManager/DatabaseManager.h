//
//  DatabaseManager.h
//  FirebaseManager
//
//  Created by hardik on 2/12/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@import Firebase;

#define DatabaseSharedInstance  ((DatabaseManager *)[DatabaseManager sharedInstance])
#define USER_KEY @"userDetail"


@interface DatabaseManager : NSObject

+(instancetype)sharedInstance;

/**
 *  Coredata properties
 */
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


-(void)setCurrentUser:(NSDictionary *)dictionary;
-(NSDictionary *)getCurrentUser;

-(void)insertIntoChatTable:(FIRDataSnapshot *)snap;
-(void)insertIntoMessageTable:(FIRDataSnapshot *)snap;
-(void)updateUnreadCount:(FIRDataSnapshot *)snap;
@end
