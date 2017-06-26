//
//  FirebaseHelper.m
//  Looper
//
//  Created by hardik on 6/1/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "FirebaseHelper.h"
#include <CommonCrypto/CommonDigest.h>
#import "LoaderView.h"

@implementation FirebaseHelper

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
        [FIRDatabase database].persistenceEnabled = true;
        
    });
    return sharedInstance;
}

-(void)createFirebaseUser:(NSDictionary *)jsonObject successBlock:(void (^)(FIRUser *))successBlock errorBlock:(void (^)(NSError *))errorBlock
{

    NSString *userEmail = jsonObject[@"uEmail"];
        NSString *password = @"123456";
    
    [[FIRAuth auth] createUserWithEmail:userEmail password:password completion:^(FIRUser * _Nullable user, NSError * _Nullable error)
     {
        [LoaderView hideLoader];
         if (error == nil)
         {
             successBlock(user);
         }
         
     }];
}

-(void)authenticateFirebaseUser:(NSDictionary *)jsonObject successBlock:(void (^)(FIRUser *))successBlock errorBlock:(void (^)(NSError *))errorBlock
{
    NSString *userEmail = jsonObject[@"uEmail"];
    NSString *password = @"123456";
    
//    [LoaderView showLoader];
    [[FIRAuth auth] signInWithEmail:userEmail password:password completion:^(FIRUser * _Nullable user, NSError * _Nullable error)
     {
         [LoaderView hideLoader];
         if (error == nil)
         {
             successBlock(user);
         }
     }];
}

-(void)createUserProfile:(NSDictionary*)userDictionary
{
    NSString *userEmail = userDictionary[@"uEmail"];
//    NSDictionary *userDictionary = @{@"uEmail":userEmail,@"uid":firUser.uid,@"uName":uName,@"profilePic":response[@"vProfilePic"],@"fullName":response[@"vFullName"]};
//    NSDictionary *dict = @{@"uEmail" : userEmail,@"uName":userDictionary[@"vFullName"], @"uid":userDictionary[@"uid"],@""};
    
    
    NSString *userEmailSh1 = [self sha1:userEmail];
    
    FIRDatabaseReference *ref = [[FIRDatabase database] reference];
    
    
    [[ref child:[NSString stringWithFormat:@"%@/%@",FIREBASE_APP_USER,userEmailSh1]]setValue:userDictionary];
    
    
}

-(void)initialObservers
{
    //observing user initial chat
    [self chatObserver];
    //observing user last seen status(persistance)
    [self persistanceObserver];
    
    
}

-(void)chatObserver
{
    NSDictionary *dict = [DatabaseSharedInstance getCurrentUser];
    
    NSString *email = dict[@"uEmail"];
    
    FIRDatabaseReference *ref = [[FIRDatabase database] reference];
    
    /*[*/[[ref child:[NSString stringWithFormat:@"%@/%@/%@",FIREBASE_APP_USER,[self sha1:email],FIREBASE_APP_CHATS]]
          /*queryLimitedToLast:10]*/ observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
              [[DatabaseManager sharedInstance] insertIntoChatTable:snapshot];
              
              [self messageObserverWithPath:snapshot.key];
              //        [self lastMessage1:snapshot.key];
              
              [[ref child:[NSString stringWithFormat:@"%@/%@/%@",FIREBASE_APP_USER,[self sha1:email],FIREBASE_APP_CHATS]] observeEventType:FIRDataEventTypeChildChanged  withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                  NSLog(@"UNREAD COUNT %d",[snapshot.value[@"unreadCount"] intValue]);
                  [[DatabaseManager sharedInstance] updateUnreadCount:snapshot];
              }];
          }];
}



-(void)messageObserverWithPath:(NSString *)messagePath
{
    
    FIRDatabaseReference *ref = [[FIRDatabase database] reference];
    
    //    [ref queryLimitedToLast:10];
    
    [[ref child:[NSString stringWithFormat:@"%@/%@",FIREBASE_APP_MESSAGES,messagePath]]
     observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
         [[DatabaseManager sharedInstance] insertIntoMessageTable:snapshot];
     }];
    
}

-(void)lastMessage1:(NSString *)messagePath
{
    
    FIRDatabaseReference *ref = [[FIRDatabase database] reference];
    
    //    [ref queryLimitedToLast:10];
    
    [[[ref child:[NSString stringWithFormat:@"%@/%@",FIREBASE_APP_MESSAGES,messagePath]] queryLimitedToLast:1] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        [[DatabaseManager sharedInstance] insertIntoMessageTable:snapshot];
    }];
}

-(void)persistanceObserver
{
    FIRDatabaseReference *ref = [[FIRDatabase database] reference];
    
    [[ref child:[NSString stringWithFormat:@"%@",FIREBASE_APP_PERSISTANCE]]
     observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
         NSLog(@"child added %@",snapshot);
     }];
    //    Firebase *ref = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@/%@",FIREBASE_APP_URL,FIREBASE_APP_PERSISTANCE]];
    //
    //
    //    [ref observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot)
    //     {
    //         NSLog(@"child added %@",snapshot);
    //     }];
    
}

-(void)getAllFirebaseUserList
{
    FIRDatabaseReference *ref = [[FIRDatabase database] reference];
    
    [[ref child:[NSString stringWithFormat:@"%@",FIREBASE_APP_USER]]
     observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
         NSLog(@"SNAP KEY %@ SNAP VALUE %@",snapshot.key,snapshot.value);
     }];
    //    Firebase *ref = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@/%@",FIREBASE_APP_URL,FIREBASE_APP_USER]];
    //
    //    [ref observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot)
    //     {
    //         NSLog(@"SNAP KEY %@ SNAP VALUE %@",snapshot.key,snapshot.value);
    //     }];
}

-(void)setPersistanceOfUser:(NSString *)userEmail status:(NSString*)status
{
    NSString *userEmailSh1 = [self sha1:userEmail];
    
    //    FIRDatabaseReference *ref = [[FIRDatabase database] referenceWithPath:[NSString stringWithFormat:@"%@/%@",FIREBASE_APP_PERSISTANCE,userEmailSh1]];
    FIRDatabaseReference *ref = [[FIRDatabase database] reference];
    
    
    //    Firebase *ref = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@/%@/%@",FIREBASE_APP_URL,FIREBASE_APP_PERSISTANCE,userEmailSh1]];
    //    [Firebase se];
    NSDictionary *dictPersistance = @{@"status" : status,@"timeStamp":[FIRServerValue timestamp]};
    
    [[ref child:[NSString stringWithFormat:@"%@/%@",FIREBASE_APP_PERSISTANCE,userEmailSh1]] setValue:dictPersistance];
    
    [[ref child:[NSString stringWithFormat:@"%@/%@",FIREBASE_APP_PERSISTANCE,userEmailSh1]] onDisconnectUpdateChildValues:@{@"status" : @(0),@"timeStamp":[FIRServerValue timestamp]}];
    
    //    [ref setValue:dictPersistance];
    //
    //    [ref onDisconnectUpdateChildValues:@{@"status" : @(0),@"timeStamp":[FIRServerValue timestamp]}];
    
}

- (NSString *)sha1:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(cStr, strlen(cStr), result);
    NSString *s = [NSString  stringWithFormat:
                   @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   result[0], result[1], result[2], result[3], result[4],
                   result[5], result[6], result[7],
                   result[8], result[9], result[10], result[11], result[12],
                   result[13], result[14], result[15],
                   result[16], result[17], result[18], result[19]
                   ];
    
    return s;
}

-(NSString *)sortStringAlphabatically:(NSString *)inputString
{
    NSString *outputString = @"";
    
    NSMutableArray *arrChar = [[NSMutableArray alloc] init];
    
    for (int i = 0 ; i < inputString.length ; i++)
    {
        //        let myNSString = inputString as NSString
        //
        //        let char = myNSString.substringWithRange(NSRange(location: i, length: 1))
        //
        NSString *character = [inputString substringWithRange:NSMakeRange(i, 1)];
        [arrChar addObject:character];
    }
    
    [arrChar sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return obj2 < obj1;
    }];
    
    
    outputString = [arrChar componentsJoinedByString:@""];
    
    outputString = [outputString stringByReplacingOccurrencesOfString:@"." withString:@""];
    outputString = [outputString stringByReplacingOccurrencesOfString:@"$" withString:@""];
    outputString = [outputString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    outputString = [outputString stringByReplacingOccurrencesOfString:@"@" withString:@""];
    
    return outputString;
    
}

-(void)firebaseRemoveAllObservers
{
    FIRDatabaseReference *ref = [[FIRDatabase database] reference];
    [ref removeAllObservers];
}
@end
