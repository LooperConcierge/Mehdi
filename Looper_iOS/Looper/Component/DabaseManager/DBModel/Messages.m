//
//  Messages.m
//  ObjcScrollview
//
//  Created by hardik on 1/28/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "Messages.h"
#import "AppDelegate.h"
#import "DatabaseManager.h"

@implementation Messages

static NSString *entityName = @"Messages";

// Insert code here to add functionality to your managed object subclass
+(Messages *)insertObjectIntoMessages:(NSDictionary *)dict
{
    Messages *chatObj = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:DatabaseSharedInstance.managedObjectContext];
    
    
    
    chatObj.mText = dict[@"text"];
    chatObj.mTo = dict[@"to"];
    chatObj.mFrom = dict[@"from"];
    chatObj.mID = dict[@"mID"];
    chatObj.mUID = dict[@"mUID"];
    chatObj.timestamp = [NSNumber numberWithDouble:[dict[@"timestamp"] doubleValue]];
    chatObj.mRead = [NSNumber numberWithBool:0];
    
    
//        [AppdelegateObj saveContext];
    
    return chatObj;
}

+(Messages *)updateObjectIntoMessages:(NSDictionary *)dict chatObj:(Messages *)chatObject
{
    chatObject.mText = dict[@"text"];
    chatObject.mTo = dict[@"to"];
    chatObject.mFrom = dict[@"from"];
    chatObject.mID = dict[@"mID"];
    chatObject.mUID = dict[@"mUID"];
    chatObject.timestamp = [NSNumber numberWithDouble:[dict[@"timestamp"] doubleValue]];
//    chatObject.mRead = [NSNumber numberWithBool:0];
    
//    [AppdelegateObj saveContext];
    
    return chatObject;
}

+(NSFetchRequest *)fetchAllChatsMessages
{
    
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *desc = [NSEntityDescription entityForName:entityName inManagedObjectContext:DatabaseSharedInstance.managedObjectContext];
    
    NSDictionary *dict = [DatabaseSharedInstance getCurrentUser];
    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SUBQUERY(models, $m, ANY $m.currentUserUid IN %@).@count > 0",dict[@"uid"]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"messageOfChat.currentUserUid = %@",dict[@"uid"]];
    
    [request setEntity:desc];
    
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO];
    
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    //    NSPredicate *pred = [NSPredicate predicateWithFormat:@"chatID = %@",chatID];
    
    //    [request setPredicate:pred];
    
//    NSError *error;
    
//    NSArray *result = [DatabaseSharedInstance.managedObjectContext executeFetchRequest:request error:&error];
    
    return request;
}

+(Messages *)fetchAllChatObjWIthID:(NSString *)mUID
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSDictionary *dict = [DatabaseSharedInstance getCurrentUser];
    
    NSEntityDescription *desc = [NSEntityDescription entityForName:entityName inManagedObjectContext:DatabaseSharedInstance.managedObjectContext];
    
    [request setEntity:desc];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"mUID = %@ && messageOfChat.currentUserUid = %@",mUID,dict[@"uid"]];

    [request setPredicate:pred];
    
    NSError *error;
    
    NSArray *result = [DatabaseSharedInstance.managedObjectContext executeFetchRequest:request error:&error];
    
    if (result.count >0)
    {
         return result[0];
    }
    return nil;
}

+(NSFetchRequest *)fetchAllMessageObjWIth:(Chat *)chatObj
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *desc = [NSEntityDescription entityForName:entityName inManagedObjectContext:DatabaseSharedInstance.managedObjectContext];
    
    [request setEntity:desc];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"messageOfChat = %@ ",chatObj];
    
    [request setPredicate:pred];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
//    NSError *error;
//    
//    NSArray *result = [DatabaseSharedInstance.managedObjectContext executeFetchRequest:request error:&error];
    
    return request;
}

+ (NSArray *)getMessagesOfChatId:(NSString *)chatId Offset:(NSInteger)Offset fetchLimit:(NSInteger)fetchLimit {
    
    
    Chat *chatmodel = [Chat fetchObjectWithID:chatId];
    
    NSInteger messageCount = [chatmodel.chatMessages allObjects].count;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *desc = [NSEntityDescription entityForName:entityName inManagedObjectContext:DatabaseSharedInstance.managedObjectContext];
    [request setEntity:desc];
    
    request.predicate = [NSPredicate predicateWithFormat:@"messageOfChat = %@", chatmodel];
    
    if(Offset > 0) {
        Offset--;
    }
    
    NSInteger fatchOffset = messageCount-Offset;
    if(fatchOffset < 10)
        fetchLimit = fatchOffset;
    
    if(fetchLimit <= 0)
        return nil;
    
    request.fetchOffset = messageCount-Offset-fetchLimit;
    request.fetchLimit = fetchLimit;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES]];
    
    NSArray *arrChat1 = [[DatabaseSharedInstance.managedObjectContext executeFetchRequest:request error:nil] mutableCopy];
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:!(Offset > 0)];
    return [arrChat1 sortedArrayUsingDescriptors:@[sort]];
//    return  request;
    
}

+(NSArray *)unReadCOunt:(NSArray *)arrMessage
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mRead = 0"];
    
    NSArray *filterArr = [arrMessage filteredArrayUsingPredicate:predicate];
    
    return filterArr;
}

+(NSArray *)setMessageRead:(NSArray *)arrMessage
{
    for (Messages *messageObj in arrMessage)
    {
        messageObj.mRead = [NSNumber numberWithBool:1];
    }

    [DatabaseSharedInstance saveContext];
    
    return arrMessage;
}

@end
