//
//  FirebaseHelper.h
//  Looper
//
//  Created by hardik on 6/1/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Firebase;
#import "DatabaseManager.h"

#define kNotificationChatReceive  @"kNotificationChatReceive"

#define FBManagerSharedInstance ((FirebaseHelper *)[FirebaseHelper sharedInstance])

#define FIREBASE_APPNAME @"FBMANAGER"

//#define FIREBASE_APP_URL  @"https://fbmanager.firebaseio.com"

#define FIREBASE_APP_USER   @"user"

#define FIREBASE_APP_PARTICIPANTS   @"participants"

#define FIREBASE_APP_MESSAGES   @"messages"

#define FIREBASE_APP_CHATS   @"chats"

#define FIREBASE_APP_PERSISTANCE   @"persistance"



@interface FirebaseHelper : NSObject

+ (instancetype)sharedInstance;

#pragma MArk - firebase mathods

-(void)createFirebaseUser:(NSDictionary *)jsonObject
             successBlock:(void (^)(FIRUser *))successBlock
               errorBlock:(void (^)(NSError *))errorBlock;

-(void)authenticateFirebaseUser:(NSDictionary*)jsonObject
                   successBlock:(void (^)(FIRUser *response))successBlock
                     errorBlock:(void (^)(NSError *error))errorBlock;

-(void)createUserProfile:(NSDictionary*)userDictionary;

-(void)initialObservers;

-(void)getAllFirebaseUserList;

-(void)setPersistanceOfUser:(NSString *)userEmail status:(NSString*)status;

-(void)firebaseRemoveAllObservers;

-(NSString *)sortStringAlphabatically:(NSString *)inputString;

@end
