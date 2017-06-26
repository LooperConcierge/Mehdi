//
//  BaseViewController.m
//  Looper
//
//  Created by Meera Dave on 30/01/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "BaseViewController.h"
NSString *strControllerTitle = nil;
@interface BaseViewController () {
    UIBarButtonItem *rightDeleteBarButtonItem;
    UIBarButtonItem *rightShareBarButtonItem;
}
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - UI Methods
- (void)setLeftItems {
    UIButton *btnMenu = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnMenu setFrame:CGRectMake(0, 0, 30, 30)];
    [btnMenu setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btnMenu setImage:[UIImage imageNamed:@"btnMenu"] forState:UIControlStateNormal];
    [btnMenu addTarget:self action:@selector(onBtnMenu) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnControllerName = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnControllerName setFrame:CGRectMake(0, 0, 50, 30)];
    [btnControllerName setTitle:strControllerTitle forState:UIControlStateNormal];
    [btnControllerName setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btnControllerName setTitleEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
    [btnControllerName setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnControllerName sizeToFit];
    [btnControllerName.titleLabel setFont:[UIFont fontAvenirWithSize:15.0f]];
    
    UIBarButtonItem *leftMenuButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnMenu];
    UIBarButtonItem *leftTitleButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnControllerName];
    
    self.navigationItem.leftBarButtonItems = @[leftMenuButtonItem,leftTitleButtonItem];
}

- (void)setBackItems {
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setFrame:CGRectMake(0, 0, 15, 25)];
    [btnBack setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btnBack setImage:[UIImage imageNamed:@"btnBack"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(onBtnBack) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftMenuButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    
    if (strControllerTitle.length > 0) {
        UIButton *btnControllerName = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnControllerName setFrame:CGRectMake(0, 0, 50, 30)];
        [btnControllerName setTitle:strControllerTitle forState:UIControlStateNormal];
        [btnControllerName setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [btnControllerName setTitleEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
        [btnControllerName setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnControllerName sizeToFit];
        [btnControllerName.titleLabel setFont:[UIFont fontAvenirWithSize:15.0f]];
        
        UIBarButtonItem *leftTitleButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnControllerName];
        
        self.navigationItem.leftBarButtonItems = @[leftMenuButtonItem,leftTitleButtonItem];
    } else {
        self.navigationItem.leftBarButtonItems = @[leftMenuButtonItem];
    }
    
    // [self.menuContainerViewController setPanMode:MFSideMenuPanModeNone];
}
-(void)hideNavItem {
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)setRightItems {
    
    UIView *rightButtonContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    rightButtonContainer.backgroundColor = [UIColor clearColor];
    
    UIButton *btnNotifications = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnNotifications setFrame:CGRectMake(0, 5, 20, 20)];
    [btnNotifications setImage:[UIImage imageNamed:@"btnNotification"] forState:UIControlStateNormal];
    [btnNotifications addTarget:self action:@selector(onBtnNotifications) forControlEvents:UIControlEventTouchUpInside];
    [rightButtonContainer addSubview:btnNotifications];
    
    //    int unreadCount = [[HGFirebaseManager sharedInstance] unreadTips];
    //    if (unreadCount > 0) {
    //        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 16, 16)];
    //        label.layer.cornerRadius = 8;
    //        label.clipsToBounds = true;
    //        label.textColor = [UIColor whiteColor];
    //        label.font = [UIFont systemFontOfSize:12.0];
    //        label.backgroundColor = [UIColor orangeColor];
    //        label.textAlignment = NSTextAlignmentCenter;
    //        label.text= [NSString stringWithFormat:@"%d", unreadCount];
    //        [rightButtonContainer addSubview:label];
    //    }
    //    else
    //    {
    //        [btnNotifications setFrame:CGRectMake(7, 5, 20, 20)];
    //    }
    
    //    UIBarButtonItem *rightNotificationsButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButtonContainer];
    //
    //    if ([self isKindOfClass:[GalleryViewController class]] ||
    //        [self isKindOfClass:[HistoryViewController class]]) {
    //        UIButton *btnShare = [UIButton buttonWithType:UIButtonTypeCustom];
    //        [btnShare setFrame:CGRectMake(0, 0, 30, 30)];
    //        [btnShare setImage:[UIImage imageNamed:@"btnShare"] forState:UIControlStateNormal];
    //        [btnShare addTarget:self action:@selector(onBtnShare) forControlEvents:UIControlEventTouchUpInside];
    //        rightShareBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnShare];
    //    }
    //
    //    if ([self isKindOfClass:[GalleryViewController class]]) {
    //        UIButton *btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
    //        [btnDelete setFrame:CGRectMake(0, 0, 30, 30)];
    //        [btnDelete setImage:[UIImage imageNamed:@"BtnDeleteBar"] forState:UIControlStateNormal]
    //        ;
    //        [btnDelete addTarget:self action:@selector(onBtnDelete) forControlEvents:UIControlEventTouchUpInside];
    //        rightDeleteBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnDelete];
    //    }
    
    //self.navigationItem.rightBarButtonItems = @[rightNotificationsButtonItem];
}

- (void)setTitleView:(NSString*)title{
    self.title=title;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont fontAvenirWithSize:20.0f]}];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    }

- (NSInteger)currentConstraintsAccordingToDevice {
    NSInteger currentConstraint = 0;
    
    if (self.view.frame.size.height == HEIGHT_IPHONE_4) {
        currentConstraint = DEFAULT_CONSTRAINT_IPHONE_4;
    } else if (self.view.frame.size.height == HEIGHT_IPHONE_6) {
        currentConstraint = DEFAULT_CONSTRAINT_IPHONE_6;
    }  else if (self.view.frame.size.height == HEIGHT_IPHONE_6P) {
        currentConstraint = DEFAULT_CONSTRAINT_IPHONE_6P;
    }
    
    return currentConstraint;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onBtnImageIcon
{
    
}

- (void)onBtnBack
{
   // [self.menuContainerViewController setPanMode:MFSideMenuPanModeDefault];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)SetRootViewController:(UIViewController *)controller
{

}
@end
