//
//  SettingVC.m
//  Looper
//
//  Created by hardik on 3/16/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "SettingVC.h"
#import "UIColor+CustomColor.h"
#import "UIFont+CustomFont.h"
#import "AboutUsVC.h"

@interface SettingVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *arrSetting;
}
@property (strong, nonatomic) IBOutlet UITableView *tblSetting;

@end

@implementation SettingVC
@synthesize tblSetting;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.topItem.title = @"SETTINGS";
    self.tblSetting.backgroundColor = [UIColor darkGrayBackgroundColor];
    if (AppdelegateObject.looperGlobalObject.isLooper == true)
    {
        arrSetting = [[NSArray alloc] initWithObjects:@"My Profile",@"Payout info",@"Change Password",@"Contact Us",@"Legal",@"Help",@"Sign Out", nil];
    }
    else
        arrSetting = [[NSArray alloc] initWithObjects:@"My Profile",@"Change Password",@"Contact Us",@"Help",@"Legal",@"Sign Out", nil];

    
    [tblSetting reloadData];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UserModel *userObject = [LooperUtility getCurrentUser];
    if (userObject == nil)
    {
        [LooperUtility createAlertWithTitle:@"LOOPER" message:keyLoginFirst style:UIAlertControllerStyleAlert controller:self actionHandler:^(UIAlertAction *action) {
//            [LooperUtility navigateToLoginScreen:self.navigationController];
             [LooperUtility openLoginScreen];
        }];
        return;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrSetting count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"SettingCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    NSString *cellContent = [arrSetting objectAtIndex:indexPath.row];
    
    UILabel *lbl = [cell.contentView viewWithTag:100];
    lbl.text = cellContent;
    lbl.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_MEDIUM_SIZE];
    UILabel *lbl1 = [cell.contentView viewWithTag:102];
    lbl1.backgroundColor = [UIColor lightGrayBackgroundColor];
    if (arrSetting.count-1 == indexPath.row)
    {
        [lbl1 setHidden:YES];
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegue:indexPath];
}

-(void)performSegue:(NSIndexPath *)indexPath
{
    if (AppdelegateObject.looperGlobalObject.isLooper == true)
    {
        
        if (indexPath.row == 0)
        {
            [self performSegueWithIdentifier:@"segueMyProfile" sender:nil];
        }
        else if (indexPath.row == 1)
        {
            [self performSegueWithIdentifier:@"seguePayoutInfo" sender:nil];
        }
        else if (indexPath.row == 2)
        {
            [self performSegueWithIdentifier:@"segueChangePassword" sender:nil];
        }
        else if (indexPath.row == 3)
        {
            [self performSegueWithIdentifier:@"segueContactUs" sender:@(2)];
        }
        else if (indexPath.row == 4)
        {
             [self performSegueWithIdentifier:@"segueLegal" sender:nil];
        }
        else if (indexPath.row == 5)
        {
//            [self performSegueWithIdentifier:@"segueHelp" sender:nil];
            [self performSegueWithIdentifier:@"segueAboutUs" sender:@(3)];
        }
        else if (arrSetting.count-1 == indexPath.row)
        {
            if ([LooperUtility isInternetAvailable])
            {
                [self logout];
            }
            else
            {
                [AJNotificationView showNoticeInView:AppdelegateObject.window type:AJNotificationTypeRed title:@"No internet available" linedBackground:AJLinedBackgroundTypeDisabled hideAfter:2.5];
            }
        }
    }
    else
    {
        
        if (indexPath.row == 0)
        {
            [self performSegueWithIdentifier:@"segueMyProfile" sender:nil];
        }
        else if (indexPath.row == 1)
        {
            [self performSegueWithIdentifier:@"segueChangePassword" sender:nil];
        }
        else if (indexPath.row == 2)
        {
            [self performSegueWithIdentifier:@"segueContactUs" sender:nil];
        }
        else if (indexPath.row == 3)
        {
//            [self performSegueWithIdentifier:@"segueHelp" sender:nil];
            [self performSegueWithIdentifier:@"segueAboutUs" sender:@(3)];
        }
        else if (indexPath.row == 4)
        {
            [self performSegueWithIdentifier:@"segueLegal" sender:nil];
        }
        else if (arrSetting.count-1 == indexPath.row)
        {
            if ([LooperUtility isInternetAvailable])
            {
                [self logout];
            }
            else
            {
                 [AJNotificationView showNoticeInView:AppdelegateObject.window type:AJNotificationTypeRed title:@"No internet available" linedBackground:AJLinedBackgroundTypeDisabled hideAfter:2.5];
            }
            
        }
    }
}

-(void)logout
{
    [[ServiceHandler sharedInstance].webService processLogoutWithSuccessBlock:^(NSDictionary *response)
     {
         if ([response objectForKey:message])
         {
         [AJNotificationView showNoticeInView:AppdelegateObject.window type:AJNotificationTypeRed title:response[message] linedBackground:AJLinedBackgroundTypeDisabled hideAfter:2.5];    
         }
        
         [LooperUtility logoutCurrentUser];
         UIViewController *ctl = (UIViewController *)AppdelegateObject.window.rootViewController;
         UITabBarController *ct = (UITabBarController *)ctl;
         [AppdelegateObject removeSubViews];
         
         for (int i = 0; i < ct.viewControllers.count ;  i++)
         {
             UINavigationController *NAV = [ct.viewControllers objectAtIndex:i];
             [NAV popToRootViewControllerAnimated:true];
         }
         [AppdelegateObject getApiKey];
         [LooperUtility openLoginScreen];
         
     } errorBlock:^(NSError *error)
     {
         
     }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"segueAboutUs"])
    {
        AboutUsVC *vc = segue.destinationViewController;
        
        int index = [sender intValue];
        
        if (index == 1)
        {
            vc.openPageIndex = TERMS_AND_CONDION;
        }
        else if(index == 3)
        {
            vc.openPageIndex = 3;
        }
        else
        {
            vc.openPageIndex = ABOUT_US;
        }
        
    }
}


@end
