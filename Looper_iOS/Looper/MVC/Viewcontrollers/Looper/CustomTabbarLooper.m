//
//  CustomTabbarLooper.m
//  Looper
//
//  Created by hardik on 2/16/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "CustomTabbarLooper.h"
#import "AppDelegate.h"
#import "LooperUtility.h"
#import <Looper-Swift.h>
#import "TravellerListingViewController.h"

@interface CustomTabbarLooper ()<UITabBarControllerDelegate,UITabBarDelegate>

@end

@implementation CustomTabbarLooper
@synthesize isFromSignup;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prepareView];
}

-(void)prepareView
{

    if ([LooperUtility getCurrentUser] != nil)
    {
        [self firebaseSetup];
        [[ServiceHandler sharedInstance].looperWebService processLooperProfileWithSuccessBlock:^(NSDictionary *response)
         {
             NSDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:response[profile]];
             [dict setValue:response[@"languages"] forKey:@"languages"];
             [dict setValue:response[@"expertises"] forKey:@"expertises"];
             
             NSError *error;
             LooperModel *looperProfile = [[LooperModel alloc] initWithDictionary:dict error:&error];
             [LooperUtility settingLooperProfile:looperProfile];
             
         } errorBlock:^(NSError *error)
         {
             
         }];
    }
    self.delegate = self;
    
//    UIImage *iconCalendarActive = [UIImage imageNamed:@"tab_calendar_activ"];
//    UIImage *iconCalendarInActive = [UIImage imageNamed:@"tab_calendar_inactive"];
    UIImage *iconCurrentTripActive = [UIImage imageNamed:@"tab_currenttrip_active"];
    UIImage *iconCurrentTripInActive = [UIImage imageNamed:@"tab_currenttrip_inactive"];
    UIImage *iconEmailActive = [UIImage imageNamed:@"tab_email_active"];
    UIImage *iconEmailInActive = [UIImage imageNamed:@"tab_email_inactive"];
    UIImage *iconSettingActive = [UIImage imageNamed:@"tab_profile_active"];
    UIImage *iconSettingInActive = [UIImage imageNamed:@"tab_profile_inactive"];
    UIImage *iconNewsRoomActive = [UIImage imageNamed:@"tab_activity_active"];
    UIImage *iconNewsRoomInActive = [UIImage imageNamed:@"tab_activity_inactive"];
    
    
    UITabBar *tabBar = self.tabBar;
    tabBar.barTintColor = [UIColor clearColor];
    UITabBarItem *item0 = [tabBar.items objectAtIndex:0];
//    UITabBarItem *item1 = [tabBar.items objectAtIndex:1];
    UITabBarItem *item2 = [tabBar.items objectAtIndex:1];
    UITabBarItem *item3 = [tabBar.items objectAtIndex:2];
    UITabBarItem *item4 = [tabBar.items objectAtIndex:3];
    
    item0.image = [iconCurrentTripInActive imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item0.selectedImage = [iconCurrentTripActive imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    item1.image = [iconCalendarInActive imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    item1.selectedImage = [iconCalendarActive imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.image = [iconNewsRoomInActive imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.selectedImage = [iconNewsRoomActive imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item3.image = [iconEmailInActive imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item3.selectedImage = [iconEmailActive imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item4.image = [iconSettingInActive imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item4.selectedImage = [iconSettingActive imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationController.hidesBarsOnSwipe = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectedtCOntrollerIndex:(NSUInteger)index
{
    self.selectedIndex = index;
    [self.tabBar setHidden:FALSE];
    
    if (AppdelegateObject.apnsDictionary != nil)
    {
        NSArray *pageNameArr = [[NSArray alloc] initWithArray:AppdelegateObject.apnsDictionary[@"USER_DATA"]];
        NSDictionary *pageDict = [pageNameArr lastObject];
        NSString *pageName = [pageDict valueForKey:@"page_name"];
        if ([pageName  isEqual: @"new_trip_request"])
        {
            UINavigationController *nav = [self.viewControllers objectAtIndex:0];
            TravellerListingViewController *tvl = (TravellerListingViewController *)[nav.viewControllers objectAtIndex:0];
            [tvl viewWillAppear:true];
            
        }
        else if ([pageName  isEqual: @"payment_receive"] || [pageName  isEqual: @"change_request"])
        {
            UINavigationController *nav = [self.viewControllers objectAtIndex:0];
            TravellerListingViewController *tvl = (TravellerListingViewController *)[nav.viewControllers objectAtIndex:0];
            [tvl viewWillAppear:true];
        }    
    }
    
    
}

//MARK: - Firebase setup

-(void)firebaseSetup
{
    
    //    let userClass = UserClass()
    //
    //    userClass.urlProfile = NSURL(string: UserDefault.getProfilePic()!)
    //    userClass.strName = UserDefault.getUserName()!
    //    userClass.strUserId = UserDefault.getUserId()!
    //    userClass.isProfileGroupEnable = AppUtility.shared.isGroupChatEnableFromServer() ? "1" : "0"
    //    userClass.fcmToken = AppUtility.shared.getFCMToken()
    //    FirebaseChatManager.sharedInstance.addOrUpdateSelfUserInFireBase(userDetail: userClass)
    UserModel *user = [LooperUtility getCurrentUser];
    
    if (user != nil)
    {
        [[FirebaseChatManager sharedInstance] addObserveForRecentChatNewUserWithStrUserId:[NSString stringWithFormat:@"%d",user.iUserID] completionHandler:^(BOOL success, NSDictionary *response)
         {
             [AppdelegateObject authenticateUser];
         }];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
