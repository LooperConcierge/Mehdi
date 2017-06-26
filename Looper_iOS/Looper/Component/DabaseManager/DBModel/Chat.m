//
//  Chat.m
//  ObjcScrollview
//
//  Created by hardik on 1/28/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "Chat.h"
#import "ChatParticipants.h"
#import "Messages.h"
#import "DatabaseManager.h"

@implementation Chat

static NSString *entityName = @"Chat";

// Insert code here to add functionality to your managed object subclass
+(Chat *)insertObjectIntoChat:(NSDictionary *)dict
{
    Chat *chatObj = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:DatabaseSharedInstance.managedObjectContext];
    
    
    NSDictionary *currentUser = [DatabaseSharedInstance getCurrentUser];
    
    chatObj.chatID = dict[@"chatID"];
    chatObj.currentUserUid = currentUser[@"uid"];
    chatObj.unreadCount = [NSNumber numberWithInt:[dict[@"unreadCount"] intValue]];
    NSDictionary *participants = dict[@"participants"];
    
    ChatParticipants *chatparicipants;
    
    for (NSString *key in participants.allKeys)
    {
        NSDictionary *dictParticipant = participants[key];
        if (![dictParticipant[@"uEmail"] isEqualToString:currentUser[@"uEmail"]])
        {
            chatparicipants = [ChatParticipants fetchChatParticipantWithUserEmail:dictParticipant[@"uName"]];
            if (chatparicipants == nil)
            {
                chatparicipants = [ChatParticipants insertObjectIntoChatParticipants:dictParticipant chatObj:chatObj];
            }
        }
        
    }
    chatObj.participants = chatparicipants;
    return chatObj;
//    [AppdelegateObj saveContext];
    
}

+(Chat *)updateObjectIntoChat:(NSDictionary *)dict chatObj:(Chat *)chatObject
{
    chatObject.chatID = dict[@"chatID"];
    
    return chatObject;
}

+(Chat *)fetchObjectWithID:(NSString *)chatID
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *desc = [NSEntityDescription entityForName:entityName inManagedObjectContext:DatabaseSharedInstance.managedObjectContext];
    
    [request setEntity:desc];
    
    NSDictionary *currentUser = [DatabaseSharedInstance getCurrentUser];

    NSPredicate *pred = [NSPredicate predicateWithFormat:@"chatID = %@ && currentUserUid = %@",chatID,currentUser[@"uid"]];
    
    [request setPredicate:pred];
    
    NSError *error;
    
    NSArray *result = [DatabaseSharedInstance.managedObjectContext executeFetchRequest:request error:&error];
    
    if (result.count >0)
    {
        return result[0];
    }
    return nil;
}

+(NSFetchRequest *)fetchAllChatsForCurrentUser
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *desc = [NSEntityDescription entityForName:entityName inManagedObjectContext:DatabaseSharedInstance.managedObjectContext];
    
    [request setEntity:desc];
    
    NSDictionary *currentUser = [DatabaseSharedInstance getCurrentUser];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"currentUserUid = %@",currentUser[@"uid"]];
    
//    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"chatID" ascending:NO];timestamp
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"chatID" ascending:NO];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    [request setPredicate:pred];
    
    return request;
//    NSError *error;
    
//    NSArray *result = [DatabaseSharedInstance.managedObjectContext executeFetchRequest:request error:&error];
    
//    return result;
}
@end
