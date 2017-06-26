//
//  DatabaseManager.m
//  FirebaseManager
//
//  Created by hardik on 2/12/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "DatabaseManager.h"
#import "Messages.h"

#import "Chat.h"

@implementation DatabaseManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    
    });
    return sharedInstance;
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "demo.Looper" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Looper" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Looper.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


-(void)setCurrentUser:(NSDictionary *)dictionary
{
    [[NSUserDefaults standardUserDefaults] setObject:dictionary forKey:USER_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSDictionary *) getCurrentUser
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:USER_KEY])
    {
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:USER_KEY];
        return dict;
    }
    else
    {
        return nil;
    }
}

-(void)insertIntoChatTable:(FIRDataSnapshot *)snap
{
//    NSDictionary *dict = snap.value;
    NSLog(@"Snap value %@ & key is %@",snap.value,snap.key);
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:snap.value];
    [dict setObject:snap.key forKey:@"chatID"];
    Chat *chatObject = [Chat fetchObjectWithID:snap.key];
    
    if (chatObject == nil)
    {
        [Chat insertObjectIntoChat:dict];
        [[DatabaseManager sharedInstance] saveContext];
    }
    else
    {
        chatObject.unreadCount =  [NSNumber numberWithInt:[dict[@"unreadCount"] intValue]];
        [[DatabaseManager sharedInstance] saveContext];
    }
}

-(void)updateUnreadCount:(FIRDataSnapshot *)snap
{
   Chat *chatObject = [Chat fetchObjectWithID:snap.key];
    if (chatObject == nil)
    {
    }
    else
    {
        
        chatObject.unreadCount =  [NSNumber numberWithInt:[snap.value[@"unreadCount"] intValue]];
        [[DatabaseManager sharedInstance] saveContext];
    }
}
-(void)insertIntoMessageTable:(FIRDataSnapshot *)snap
{
    NSLog(@"Snap value %@ & key is %@",snap.value,snap.key);
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:snap.value];
    [dict setObject:snap.key forKey:@"mUID"];
    
    Chat *chatObject = [Chat fetchObjectWithID:dict[@"mID"]];
//    NSArray *messageArr = [chatObject.chatMessages allObjects];
    Messages *messageObject = [Messages fetchAllChatObjWIthID:snap.key];
    
    if (messageObject == nil )
    {
        messageObject = [Messages insertObjectIntoMessages:dict];
        messageObject.messageOfChat = chatObject;
        
//        if(chatObject.unreadCount > 0)
//        {
//            chatObject.unreadCount = [NSNumber numberWithInt:[chatObject.unreadCount intValue]+1];
//        }
        [[DatabaseManager sharedInstance] saveContext];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kNotificationChatReceive" object:nil];
    }
    else
    {
//        messageObject.messageOfChat = chatObject;
//        [[DatabaseManager sharedInstance] saveContext];
    }
    
    
}
@end
