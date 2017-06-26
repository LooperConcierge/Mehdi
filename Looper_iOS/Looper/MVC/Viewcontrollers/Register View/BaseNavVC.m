//
//  BaseNavVC.m
//  Looper
//
//  Created by hardik on 2/1/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "BaseNavVC.h"
#import "LandingVC.h"
//#import "ExpertiseGalleryViewController.h"
#import "TravellerListingViewController.h"
#import "LoopersListVC.h"
#import "NewsroomVC.h"
#import "TravellerDetailViewController.h"
#import "LoopersListVC.h"
#import "TravelerCalendarVC.h"
#import "BookingHistoryVC.h"
#import "MessageVC.h"
#import "SettingVC.h"
#import "LooperBookingVC.h"
#import "NewsroomVC.h"
#import "TravelerNotification.h"
#import "LooperProfileVC.h"
#import "LooperRegisterVC.h"
#import "NewsroomVC.h"
#import "LooperBookingVC.h"

@interface BaseNavVC ()
{
    UIButton *btnPush;
}
@end

@implementation BaseNavVC

+ (id)sharedBadgeView { //[GIBadgeView new]
    static GIBadgeView *badgeView1 = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        badgeView1 = [GIBadgeView new];
    });
    return badgeView1;
}

- (void)viewDidLoad {

    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBadgerValue) name:@"kObserverSetBadge" object:nil];
    
    if (![self isKindOfClass:[LandingVC class]])
    {
        
        //        if ([self isKindOfClass:[ExpertiseGalleryViewController class]])
        //        {
        //            self.navigationController.navigationBarHidden = FALSE;
        //            self.navigationItem.hidesBackButton = TRUE;
        //        }
        if ([self isKindOfClass:[TravellerListingViewController class]])
        {
            self.navigationController.navigationBarHidden = NO;
            [self addPushNavigationButton];
            self.navigationItem.hidesBackButton = TRUE;
        }
        else if ([self isKindOfClass:[BookingHistoryVC class]])
        {
            self.navigationController.navigationBarHidden = FALSE;
            [self addPushNavigationButton];
            self.navigationItem.hidesBackButton = TRUE;
        }
        else if ([self isKindOfClass:[LooperBookingVC class]])
        {
            self.navigationController.navigationBarHidden = FALSE;
            [self addPushNavigationButton];
            self.navigationItem.hidesBackButton = TRUE;
        }
        else if ([self isKindOfClass:[NewsroomVC class]])
        {
            self.navigationController.navigationBarHidden = FALSE;
            [self addPushNavigationButton];
            self.navigationItem.hidesBackButton = TRUE;
        }
        else if ([self isKindOfClass:[LoopersListVC class]])
        {
            self.navigationItem.hidesBackButton = TRUE;
            [self addPushNavigationButton];
        }
        else if ([self isKindOfClass:[TravelerCalendarVC class]])
        {
            self.navigationItem.hidesBackButton = TRUE;
            [self addPushNavigationButton];
            //            self.navigationController.navigationBarHidden = YES;
        }
        else if ([self isKindOfClass:[MessageVC class]])
        {
            [self addPushNavigationButton];
            self.navigationItem.hidesBackButton = TRUE;
            //            self.navigationController.navigationBarHidden = YES;
        }
        else if ([self isKindOfClass:[SettingVC class]])
        {
            [self addPushNavigationButton];
            self.navigationItem.hidesBackButton = TRUE;
            //            self.navigationController.navigationBarHidden = YES;
        }
        else if ([self isKindOfClass:[LooperBookingVC class]])
        {
            self.navigationItem.hidesBackButton = TRUE;
        }
        else if ([self isKindOfClass:[NewsroomVC class]])
        {
            self.navigationItem.hidesBackButton = TRUE;
        }
        else
        {
            self.navigationController.navigationBarHidden = FALSE;
            [self addBackButton];
        }
    }
//    if (_badgeView == nil)
//    {
//        _badgeView = [GIBadgeView new];
//    }
//    self.badgeView = [BaseNavVC sharedBadgeView];
//    self.badgeView.textColor = [UIColor whiteColor];
//    self.badgeView.font = [UIFont fontAvenirLightWithSize:11];
//    self.badgeView.backgroundColor = [UIColor redColor];
//     [self.badgeView setBadgeValue:[UIApplication sharedApplication].applicationIconBadgeNumber];

    // Do any additional setup after loading the view.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

//Not needed
//-(void)prepareView
//{
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [[LooperUtility sharedInstance].badgeView removeFromSuperview];
    [[LooperUtility sharedInstance] setbadgeViewCount];
    
    // Put all badges to the screen
    
//        CGPoint point = CGPointMake(btnPush.frame.size.width/2-[LooperUtility sharedInstance].badgeView.frame.size.width/2 + 10, -15);
//        CGSize size = CGSizeMake([LooperUtility sharedInstance].badgeView.frame.size.width, [LooperUtility sharedInstance].badgeView.frame.size.height);
//        CGRect rect = CGRectMake(point.x, point.y, size.width, size.height);
//        [[LooperUtility sharedInstance].badgeView setFrame:rect];
    
    CGPoint point = CGPointMake(btnPush.frame.size.width/2-[LooperUtility sharedInstance].badgeView.frame.size.width/2 + 10, -15);
    CGSize size = CGSizeMake([LooperUtility sharedInstance].badgeView.frame.size.width, [LooperUtility sharedInstance].badgeView.frame.size.height);
    CGRect rect = CGRectMake(point.x, point.y, size.width, size.height);
    [[LooperUtility sharedInstance].badgeView setFrame:rect];
    
    [btnPush addSubview:[LooperUtility sharedInstance].badgeView];
    
    [LooperUtility setNavigationBarTransparent:self.navigationController];
    
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName : [UIFont fontAvenirNextCondensedMediumWithSize:FONT_HEADER_LARGE_SIZE]}];
    
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    if (AppdelegateObject.looperGlobalObject.isLooper == true)
    {
        [self looperNavigation];
    }
    else
    {
        [self travellerNavigation];
    }
    
//    [self.badgeView setBadgeValue:10];
    
}

-(void)looperNavigation
{
//    • New trip request from				= new_trip_request
//    • You received a payment from		= payment_receive
//    • has requested to change trip		= change_request
//    • New message from 					= message
//    • New review from					= trip_list(Not Decided)
//    • New message in your community		= community
//    • Congratulations, your account is now active =

    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"notificationClick"])
    {
        NSDictionary *notiDict = [[NSUserDefaults standardUserDefaults] valueForKey:@"notificationClick"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"notificationClick"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if ([notiDict[@"redirect"] isEqualToString:@"new_trip_request"])
        {
            self.tabBarController.selectedIndex = 0;
            UINavigationController *nav = [self.tabBarController.viewControllers objectAtIndex:0];
            TravellerListingViewController *tvl = (TravellerListingViewController *)[nav.viewControllers objectAtIndex:0];
//            tvl.btnRequest.selected = true;
//            tvl.btnTraveller.selected = false;
//            [tvl viewWillAppear:true];
            [tvl onTapBtnRequest:nil];
        }
        else if ([notiDict[@"redirect"] isEqualToString:@"payment_receive"])
        {
            self.tabBarController.selectedIndex = 0;
            UINavigationController *nav = [self.tabBarController.viewControllers objectAtIndex:0];
            TravellerListingViewController *tvl = (TravellerListingViewController *)[nav.viewControllers objectAtIndex:0];
            //            tvl.btnRequest.selected = true;
            //            tvl.btnTraveller.selected = false;
            //            [tvl viewWillAppear:true];
            [tvl onTapBtnFromNotificationTripID:notiDict[@"iTripID"]];
        }
        else if ([notiDict[@"redirect"] isEqualToString:@"change_request"])
        {
            self.tabBarController.selectedIndex = 0;
            UINavigationController *nav = [self.tabBarController.viewControllers objectAtIndex:0];
            TravellerListingViewController *tvl = (TravellerListingViewController *)[nav.viewControllers objectAtIndex:0];
            
            [tvl onTapBtnFromNotificationTripID:notiDict[@"iTripID"]];
        }
        else if ([notiDict[@"redirect"] isEqualToString:@"community"])
        {
            self.tabBarController.selectedIndex = 1;
            UINavigationController *nav = [self.tabBarController.viewControllers objectAtIndex:1];
            NewsroomVC *tvl = (NewsroomVC *)[nav.viewControllers objectAtIndex:0];
            [tvl viewWillAppear:true];
            [tvl onTapBtnFromNotificationOpenCommunityID:notiDict[@"iTripID"]];
        }
        else if ([notiDict[@"redirect"] isEqualToString:@"message"])
        {
            self.tabBarController.selectedIndex = 2;
            
        }

    }
}

-(void)travellerNavigation
{
//    has accepted your trip request 	= accept/decline
//    • has made a change to your trip	= looper_change_request
//    • Time to review your Looper		=
//    • New message from					= message
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"notificationClick"])
    {
        NSDictionary *notiDict = [[NSUserDefaults standardUserDefaults] valueForKey:@"notificationClick"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"notificationClick"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if ([notiDict[@"redirect"] isEqualToString:@"looper_change_request"])
        {
            self.tabBarController.selectedIndex = 1;
            UINavigationController *nav = [self.tabBarController.viewControllers objectAtIndex:1];
            BookingHistoryVC *tvl = (BookingHistoryVC *)[nav.viewControllers objectAtIndex:0];
        
            [tvl onTapBtnUpcomingFromNotificationListingTripID:notiDict[@"iTripID"]];
        }
        else if ([notiDict[@"redirect"] isEqualToString:@"decline"])
        {
        
        }
        else if ([notiDict[@"redirect"] isEqualToString:@"accept"])
        {
            self.tabBarController.selectedIndex = 1;
            UINavigationController *nav = [self.tabBarController.viewControllers objectAtIndex:1];
            BookingHistoryVC *tvl = (BookingHistoryVC *)[nav.viewControllers objectAtIndex:0];
            
            [tvl onTapBtnUpcomingFromNotificationListingTripID:notiDict[@"iTripID"]];
        }
        else if ([notiDict[@"redirect"] isEqualToString:@"message"])
        {
            self.tabBarController.selectedIndex = 3;
            
        }
    }

}

-(void)setBadgerValue
{
    [[LooperUtility sharedInstance].badgeView setBadgeValue:[UIApplication sharedApplication].applicationIconBadgeNumber];
//    [[LooperUtility sharedInstance].badgeView setBadgeText:[NSString stringWithFormat:@"%ld",(long)[UIApplication sharedApplication].applicationIconBadgeNumber]];
}

-(void)resetBadgerValue
{
//    [[LooperUtility sharedInstance].badgeView setBadgeText:@""];
    [[LooperUtility sharedInstance].badgeView setBadgeValue:0];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)setNavigationUserInteraction
{
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    
    [self.navigationController.interactivePopGestureRecognizer setEnabled:false];
}

-(void)addPushNavigationButton
{
    btnPush = [LooperUtility createPushButton];
    [btnPush addTarget:self action:@selector(btnPushNotificationPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:btnPush] ;
    self.navigationItem.leftBarButtonItem = backButton;
//    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
//    [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
}

-(void)addBackButton
{
    self.navigationItem.leftBarButtonItem = nil;
    self.btnBack = [LooperUtility createBackButton];
    [self.btnBack addTarget:self action:@selector(btnBackPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:self.btnBack] ;
    self.navigationItem.leftBarButtonItem = backButton;
//    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
//    [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
    
//    if ([self isKindOfClass:[LoopersListVC class]])
//    {
//        //Tabbar controller class we neede to add the button on to topItem of navigation
//        [self addItemsToTopNavigation:backButton];
////        self.navigationController.navigationBar.topItem.leftBarButtonItem = backButton;
////        self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
////        [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
//    }
//    else if ([self isKindOfClass:[NewsroomVC class]])
//    {
//        //Tabbar controller class we neede to add the button on to topItem of navigation
//        [self addItemsToTopNavigation:backButton];
////        self.navigationController.navigationBar.topItem.leftBarButtonItem = backButton;
////        self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
////        [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
//    }
//    else
//    {
//        //Tabbar controller class we neede to add the button on to topItem of navigation
//        
//        self.navigationItem.leftBarButtonItem = backButton;
//        self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
//        [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
//
//    }
    
}


-(void)addCloseButton
{
    UIButton *btnBack = [LooperUtility createCloseButton];
    [btnBack addTarget:self action:@selector(btnBackPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:btnBack] ;
    self.navigationItem.leftBarButtonItem = backButton;
    
}

-(IBAction)btnPushNotificationPressed:(id)sender
{
//    [[LooperUtility sharedInstance].badgeView setBadgeText:@""];
    [[LooperUtility sharedInstance].badgeView setBadgeValue:0];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    UserModel *user = [LooperUtility getCurrentUser];
    if (user == nil)
    {
        [LooperUtility createAlertWithTitle:@"LOOPER" message:keyLoginFirst style:UIAlertControllerStyleAlert controller:self actionHandler:^(UIAlertAction *action) {
            [LooperUtility navigateToLoginScreen:self.navigationController];
            
        }];
        return;
        
    }

    UIStoryboard *st = [UIStoryboard storyboardWithName:@"Traveler" bundle:nil];
    TravelerNotification *nt = [st instantiateViewControllerWithIdentifier:@"TravelerNotificationID"];
    [self.navigationController pushViewController:nt animated:YES];

}

-(IBAction)btnBackPressed:(id)sender
{
    if ([self isKindOfClass:[LooperRegisterVC class]] && [LooperUtility sharedInstance].looperSignupDict != nil)
    {
        [LooperUtility createOkAndCancelAlertWithTitle:@"LOOPER" message:@"All data will be lost, are you sure you want to proceed?" style:UIAlertControllerStyleAlert controller:self actionHandler:^(UIAlertAction *action)
        {
            if ([[action.title lowercaseString] isEqualToString:@"ok"])
            {
                [LooperUtility sharedInstance].looperSignupDict = nil;
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
    else
        DebugLog(@"btn back pressed");
        [self.navigationController popViewControllerAnimated:YES];
   
}

-(IBAction)btnCancelPressed:(id)sender
{
    DebugLog(@"btn back pressed");
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)setBackButtonTitle
{
//    [self.btnBack setTitle:@"CANCEL" forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = nil;
    self.btnBack = [LooperUtility createBackButtonWithTitle];
    [self.btnBack setTitle:@"CANCEL" forState:UIControlStateNormal];
    self.btnBack.titleLabel.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_MEDIUM_SIZE];
    [self.btnBack addTarget:self action:@selector(btnCancelPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:self.btnBack] ;
    self.navigationItem.leftBarButtonItem = backButton;
//    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
//    [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
 
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
