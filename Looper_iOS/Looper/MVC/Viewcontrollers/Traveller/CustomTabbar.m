//
//  CustomTabbar.m
//  Looper
//
//  Created by hardik on 2/16/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "CustomTabbar.h"
#import "LooperUtility.h"
#import "LoopersListVC.h"
#import <Looper-Swift.h>

@interface CustomTabbar ()<UITabBarControllerDelegate,UITabBarDelegate>

@end

@implementation CustomTabbar

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareView];
    // Do any additional setup after loading the view.
}
//- (id) init {
//    self = [super init];
//    if (self != nil) {
//        navBarColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
//        locationManager = [[GPSLocationListner alloc] init];
//        [locationManager changeLocationUpdationStatus:TRUE];
//    }
//    return self;
//}

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(void)prepareView
{
    
    if ([LooperUtility getCurrentUser] != nil)
    {
        [self firebaseSetup];
        [[ServiceHandler sharedInstance].travelerWebService processTravelerProfileWithSuccessBlock:^(NSDictionary *response)
        {
            NSDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:response[profile]];
            [dict setValue:response[profile][@"languages"] forKey:@"languages"];
            
            NSError *error;
            TravelerModel *looperProfile = [[TravelerModel alloc] initWithDictionary:dict error:&error];
            [LooperUtility settingTravelerProfile:looperProfile];
        
        } errorBlock:^(NSError *error)
        {
            
        }];
        
        
        
//                                                              processLooperProfileWithSuccessBlock:^(NSDictionary *response)
//         {
//             NSDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:response[profile]];
//             [dict setValue:response[@"languages"] forKey:@"languages"];
//             [dict setValue:response[@"expertises"] forKey:@"expertises"];
//             
//             NSError *error;
//             LooperModel *looperProfile = [[LooperModel alloc] initWithDictionary:dict error:&error];
//             [LooperUtility settingLooperProfile:looperProfile];
//             
//         } errorBlock:^(NSError *error)
//         {
//             
//         }];
    }
    self.delegate = self;
    
    UIImage *iconSearchActive = [UIImage imageNamed:@"tab_search_active"];
    UIImage *iconSearchInActive = [UIImage imageNamed:@"tab_search_inactive"];
    UIImage *iconCalendarActive = [UIImage imageNamed:@"tab_currenttrip_active"];
    UIImage *iconCalendarInActive = [UIImage imageNamed:@"tab_currenttrip_inactive"];
    UIImage *iconCurrentCalendarActive = [UIImage imageNamed:@"tab_calendar_activ"];
    UIImage *iconCurrentCalendarInActive = [UIImage imageNamed:@"tab_calendar_inactive"];
    UIImage *iconEmailActive = [UIImage imageNamed:@"tab_email_active"];
    UIImage *iconEmailInActive = [UIImage imageNamed:@"tab_email_inactive"];
    UIImage *iconSettingActive = [UIImage imageNamed:@"tab_profile_active"];
    UIImage *iconSettingInActive = [UIImage imageNamed:@"tab_profile_inactive"];
    
    UITabBar *tabBar = self.tabBar;
    tabBar.barTintColor = [UIColor clearColor];
    UITabBarItem *item0 = [tabBar.items objectAtIndex:0];
    UITabBarItem *item1 = [tabBar.items objectAtIndex:1];
    UITabBarItem *item2 = [tabBar.items objectAtIndex:2];
    UITabBarItem *item3 = [tabBar.items objectAtIndex:3];
    UITabBarItem *item4 = [tabBar.items objectAtIndex:4];
    
    for(UITabBarItem * tabBarItem in self.tabBar.items)
    {
        tabBarItem.title = @"";
        tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    }// for setting the image in center of the tabbar
    
    
    item0.image = [iconCalendarInActive imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item0.selectedImage = [iconCalendarActive imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item1.image = [iconCurrentCalendarInActive imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item1.selectedImage = [iconCurrentCalendarActive imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.image = [iconSearchInActive imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.selectedImage = [iconSearchActive imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item3.image = [iconEmailInActive imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item3.selectedImage = [iconEmailActive imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item4.image = [iconSettingInActive imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item4.selectedImage = [iconSettingActive imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    
//    self.selectedIndex = 2;// for setting up the view controller searching (Looperlist)
    self.selectedIndex = 0;
    
    if (_dictSearchParam != nil)
    {
        self.selectedIndex = 2;
//        UINavigationController *nav = [self.viewControllers objectAtIndex:self.selectedIndex];
        UINavigationController *nav = [self.viewControllers objectAtIndex:self.selectedIndex];
        LoopersListVC *listObj = [nav.viewControllers firstObject];
        listObj.dictSearchParam = [[NSMutableDictionary alloc] initWithDictionary:_dictSearchParam];
    }
    
//    self.selectedViewController = [self.viewControllers objectAtIndex:1]; both are same - for setting up the view controller searching (Looperlist)
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationController.hidesBarsOnSwipe = NO;
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    UserModel *user = [LooperUtility getCurrentUser];
    if (user == nil)
    {
        UINavigationController *nav = [self.viewControllers objectAtIndex:2];
//        LoopersListVC *listObj = [nav.viewControllers firstObject];
        [self setSelectedViewController:nav];
        
        [LooperUtility createAlertWithTitle:@"LOOPER" message:keyLoginFirst style:UIAlertControllerStyleAlert controller:self actionHandler:^(UIAlertAction *action) {
//            [LooperUtility navigateToLoginScreen:nav];
             [LooperUtility openLoginScreen];
            
        }];
        return;

    }
}


- (IBAction)btnNotificationPressed:(id)sender
{
    [self performSegueWithIdentifier:@"segueNotification" sender:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)viewWillLayoutSubviews
//{
//    CGRect tabFrame = self.tabBar.frame; //self.TabBar is IBOutlet of your TabBar
//    tabFrame.size.height = 80;
//    tabFrame.origin.y = self.view.frame.size.height - 80;
//    self.tabBar.frame = tabFrame;
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


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

-(void)setNavigationBarTitle:(NSString *)title
{
    [self setTitle:title];
//    [self setTitle:@"Title"];
}

-(void)selectedtCOntrollerIndex:(NSUInteger)index
{
    self.selectedIndex = index;
    [self.tabBar setHidden:FALSE];
    
}

@end


