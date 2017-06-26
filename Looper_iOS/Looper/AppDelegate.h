//
//  AppDelegate.h
//  Looper
//
//  Created by hardik on 1/30/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "LooperUtility.h"
//#import "MBProgressHUD.h"

#define AppdelegateObject ((AppDelegate *)[[UIApplication sharedApplication] delegate])


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//@property (strong, nonatomic) MBProgressHUD *hud;

@property (strong, nonatomic) NSString *deviceToken;

@property (strong,nonatomic) LooperUtility *looperGlobalObject;

@property (strong,nonatomic) NSDictionary *apnsDictionary;
@property  BOOL isAlreadyTabbar;

-(void)handlePushNotification:(NSDictionary *)dictionary;
-(void)getApiKey;
-(void)authenticateUser;
-(void)removeSubViews;
@end

