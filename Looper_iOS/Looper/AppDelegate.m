//
//  AppDelegate.m
//  Looper
//
//  Created by hardik on 1/30/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <IQKeyboardManager/IQUIView+IQKeyboardToolbar.h>
#import "UIWindow+Mangagement.h"
#import "CustomTabbar.h"
#import "CustomTabbarLooper.h"
#import "BookLooperView.h"
#import "GeneralAboutView.h"
#import "TripDetailHistory.h"

@import Firebase;

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize looperGlobalObject,deviceToken,apnsDictionary,isAlreadyTabbar;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    isAlreadyTabbar = FALSE;
    
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    
    looperGlobalObject = [LooperUtility sharedInstance];

    [GMSServices provideAPIKey:GOOGLE_MAP_KEY];
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 0;
    
    [self initialSetup];
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:4];

    
    return YES;
}

-(void)initialSetup
{
//    [LooperUtility isAlreadyLoginLooper];// change according to user // looper or traveller
//    [LooperUtility isAlreadyLoginTraveler];
    [FIRApp configure];
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge
                                                                                         |UIUserNotificationTypeSound
                                                                                         |UIUserNotificationTypeAlert) categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    
    NSString *apiString = [LooperUtility getApiKeyUserDefaults];
    
    if (apiString.length == 0)
    {
        [self getApiKey];
    }
    
    UserModel *userObject = [LooperUtility getCurrentUser];
    if (userObject == nil)
    {
        [LooperUtility openLoginScreen];
    }
    else if (userObject.eIsLooper == 1)
    {
        AppdelegateObject.looperGlobalObject.isLooper = TRUE;
        [LooperUtility isAlreadyLoginLooper:false];
    }
    else if (userObject.eIsLooper == 0)
    {
        AppdelegateObject.looperGlobalObject.isLooper = FALSE;
        [LooperUtility isAlreadyLoginTraveler];
    }
    
    AppdelegateObject.deviceToken = @"";
}

-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{

    if (notificationSettings.types != UIUserNotificationTypeNone)
    {
        [application registerForRemoteNotifications];
    }
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken1
{
    NSString *token = [[deviceToken1 description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    deviceToken = token;
    NSLog(@"content---%@", token);
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Error %@",error);
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [self handlePushNotification:userInfo application:application];
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [[DatabaseManager sharedInstance] saveContext];
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

-(void)getApiKey
{
    [[ServiceHandler sharedInstance].webService getAPIKey:nil successBlock:^(NSDictionary *response)
    {
        
        [LooperUtility setApiKeyFromUserDefaults:response[@"key"]];
        
    } errorBlock:^(NSError *error)
    {
        
    }];
}

-(void)handlePushNotification:(NSDictionary *)dictionary application:(UIApplication *)application
{
    NSLog(@"APNS dict %@",dictionary);
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[dictionary[@"aps"][@"badge"] integerValue]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kObserverSetBadge" object:nil];
    
    UIViewController *vc = [AppdelegateObject.window visibleViewController];
    
    NSArray *pageNameArr = [[NSArray alloc] initWithArray:dictionary[@"USER_DATA"]];
    NSDictionary *pageDict = [pageNameArr lastObject];
    NSString *pageName = [pageDict valueForKey:@"page_name"];
    
    if (application.applicationState == UIApplicationStateBackground || application.applicationState == UIApplicationStateInactive)
    {
        apnsDictionary = dictionary;
        if (AppdelegateObject.looperGlobalObject.isLooper == true)
        {
            if ([vc isKindOfClass:[UITabBarController class]])
            {
                CustomTabbarLooper *ctl = (CustomTabbarLooper *)vc;
                isAlreadyTabbar = true;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
                    if ([pageName  isEqual: @"new_trip_request"])
                    {
                        
                        [ctl selectedtCOntrollerIndex:0];
                        
                    }
                    else if ([pageName  isEqual: @"payment_receive"] || [pageName  isEqual: @"change_request"])
                    {
                        
                        [ctl selectedtCOntrollerIndex:0];
                    }
                    else if ([pageName  isEqual: @"message"])
                    {
                        [ctl selectedtCOntrollerIndex:2];
                    }
                    else if ([pageName  isEqual: @"community"])
                    {
                        [ctl selectedtCOntrollerIndex:1];
                    }
                });
            }
            else
            {
                isAlreadyTabbar = FALSE;
                UIViewController *ctl = (UIViewController *)AppdelegateObject.window.rootViewController;
                CustomTabbarLooper *ct = (CustomTabbarLooper *)ctl;
                [self removeSubViews];
                
                if ([vc isKindOfClass:[TripDetailHistory class]])
                {
                    TripDetailHistory *dVc = (TripDetailHistory *)vc;
                    [dVc viewDidLoad];
                }
                else
                {
                    for (int i = 0; i < ct.viewControllers.count ;  i++)
                    {
                        UINavigationController *NAV = [ct.viewControllers objectAtIndex:i];
                        [NAV popToRootViewControllerAnimated:true];
                    }
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                           [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
                        if ([pageName  isEqual: @"new_trip_request"])
                        {
                            [ct selectedtCOntrollerIndex:0];
                        }
                        else if ([pageName  isEqual: @"payment_receive"] || [pageName  isEqual: @"change_request"])
                        {
                            [ct selectedtCOntrollerIndex:0];
                        }
                        else if ([pageName  isEqual: @"message"])
                        {
                            [ct selectedtCOntrollerIndex:2];
                        }
                        else if ([pageName  isEqual: @"community"])
                        {
                            [ct selectedtCOntrollerIndex:1];
                        }
                        
                    });
                }
            }
        }
        else
        {
            if ([vc isKindOfClass:[UITabBarController class]])
            {
                isAlreadyTabbar = true;
                CustomTabbar *ctl = (CustomTabbar *)vc;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
                    if ([pageName  isEqual: @"looper_change_request"])
                    {
                        [ctl selectedtCOntrollerIndex:1];
                    }
                    else if ([pageName  isEqual: @"message"])
                    {
                        [ctl selectedtCOntrollerIndex:3];
                    }
                });
                
            }
            else
            {
                isAlreadyTabbar = FALSE;
                UIViewController *ctl = (UIViewController *)AppdelegateObject.window.rootViewController;
                CustomTabbar *ct = (CustomTabbar *)ctl;
                [self removeSubViews];
                for (int i = 0; i < ct.viewControllers.count ;  i++)
                {
                    UINavigationController *NAV = [ct.viewControllers objectAtIndex:i];
                    [NAV popToRootViewControllerAnimated:true];
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
                    if ([pageName  isEqual: @"looper_change_request"])
                    {
                        [ct selectedtCOntrollerIndex:1];
                    }
                    else if ([pageName  isEqual: @"message"])
                    {
                        [ct selectedtCOntrollerIndex:3];
                    }
                });

            }
        }

    }
    
}

-(void)authenticateUser
{
    [[LooperUtility sharedInstance] getRecentChat];
    /*
    UserModel *userObject = [LooperUtility getCurrentUser];
    
    [FBManagerSharedInstance authenticateFirebaseUser:@{@"uEmail":userObject.vEmail} successBlock:^(FIRUser *response) {
        //        NSString *uName = [[userEmail componentsSeparatedByString:@"@"] objectAtIndex:0];
        UserModel *userObject = [LooperUtility getCurrentUser];
        
        if (userObject != nil)
        {
            
        NSDictionary *userDictionary = @{@"uEmail":userObject.vEmail,@"uid":response.uid,@"uName":userObject.vFullName,@"profilePic":userObject.vProfilePic};
        [DatabaseSharedInstance setCurrentUser:userDictionary];
        [FBManagerSharedInstance setPersistanceOfUser:userObject.vEmail status:@"1"];
        [FBManagerSharedInstance initialObservers];
        
        FIRUser *user1 = [FIRAuth auth].currentUser;
        
        FIRUserProfileChangeRequest *changeRequest = [user1 profileChangeRequest];
        changeRequest.displayName = userObject.vFullName;
        changeRequest.photoURL = [NSURL URLWithString:userObject.vProfilePic];
        [changeRequest commitChangesWithCompletion:^(NSError *_Nullable error) {
            if (error) {
                // An error happened.
            } else {
                // Profile updated.
                
            }
        }];
        
        }
    } errorBlock:^(NSError *error)
     {
         
     }];
     */
}

-(void)removeSubViews
{
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    
    for (UIView *v in window.subviews) {
        
        if ([v isKindOfClass:[BookLooperView class]])
        {
            [v removeFromSuperview];
        }
        else if ([v isKindOfClass:[GeneralAboutView class]])
        {
            [v removeFromSuperview];
        }
    }
}

@end

