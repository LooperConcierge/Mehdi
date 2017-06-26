//
//  ChatParticipants.m
//  ObjcScrollview
//
//  Created by hardik on 1/28/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "ChatParticipants.h"
#import "AppDelegate.h"
#import "DatabaseManager.h"


@implementation ChatParticipants

// Insert code here to add functionality to your managed object subclass
static NSString *entityName = @"ChatParticipants";

// Insert code here to add functionality to your managed object subclass
+(ChatParticipants *)insertObjectIntoChatParticipants:(NSDictionary *)dict chatObj:(Chat *)chatObj1
{
    ChatParticipants *chatObj = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:DatabaseSharedInstance.managedObjectContext];
    
    
    
    chatObj.cName = dict[@"uName"];
    chatObj.cEmail = dict[@"uEmail"];
    chatObj.profilePic = dict[@"profilePic"];
    chatObj.chatCreationDate = [NSNumber numberWithDouble:[dict[@"creationDate"] doubleValue]];
    chatObj.chat = chatObj1;
//    [AppdelegateObj saveContext];
    return chatObj;
}


+(ChatParticipants *)updateObjectIntoChatParticipants:(NSDictionary *)dict chatObj:(ChatParticipants *)chatObject chat:(Chat *)chat
{
    chatObject.cName = dict[@"uName"];
    chatObject.cEmail = dict[@"uEmail"];
    chatObject.chat = chat;
    [DatabaseSharedInstance saveContext];
    
    return chatObject;
}


+(ChatParticipants *)fetchChatParticipantWithUserEmail:(NSString *)email
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *desc = [NSEntityDescription entityForName:entityName inManagedObjectContext:DatabaseSharedInstance.managedObjectContext];
    
    [request setEntity:desc];

    NSPredicate *pred = [NSPredicate predicateWithFormat:@"cEmail = %@",email];

    [request setPredicate:pred];
    
    NSError *error;
    
    NSArray *result = [DatabaseSharedInstance.managedObjectContext executeFetchRequest:request error:&error];
    
    if (result.count > 0)
    {
        return result[0];
    }
    else
    {
        return nil;
    }


}

+(NSArray *)fetchAllChatsParticipants
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *desc = [NSEntityDescription entityForName:entityName inManagedObjectContext:DatabaseSharedInstance.managedObjectContext];
    
    [request setEntity:desc];
    
    //    NSPredicate *pred = [NSPredicate predicateWithFormat:@"chatID = %@",chatID];
    
    //    [request setPredicate:pred];
    
    NSError *error;
    
    NSArray *result = [DatabaseSharedInstance.managedObjectContext executeFetchRequest:request error:&error];
    
    return result;
}
@end
