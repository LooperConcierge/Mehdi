//
//  LoginVC.m
//  Looper
//
//  Created by hardik on 2/1/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "LoginVC.h"
#import "LooperUtility.h"
#import "SelectCityMapVC.h"
#import "IQUIView+IQKeyboardToolbar.h"
#import "FacebookHandler.h"

@interface LoginVC ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *txtEmailAddress;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UIButton *btnLogin;
@property (strong, nonatomic) IBOutlet UIButton *btnForgotPassword;
@property (strong, nonatomic) IBOutlet UIButton *btnFBloginPressed;
@property (strong, nonatomic) IBOutlet UILabel *lblOr;

@end

@implementation LoginVC
@synthesize txtEmailAddress,txtPassword,btnLogin,btnForgotPassword,isNotLogin;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareView
{
    
    self.title = [[LooperUtility sharedInstance].localization localizedStringForKey:keyLandingLogin];
    self.btnFBloginPressed.titleLabel.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_MEDIUM_SIZE];
    btnLogin.titleLabel.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_MEDIUM_SIZE];
    txtEmailAddress.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_MEDIUM_SIZE];
    txtPassword.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_MEDIUM_SIZE];
    self.lblOr.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_MEDIUM_SIZE];

    [btnLogin setTitle:[[LooperUtility sharedInstance].localization localizedStringForKey:keyLandingLogin] forState:UIControlStateNormal];
    [btnLogin setBackgroundColor:[UIColor lightRedBackgroundColor]];
//    NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:[[LooperUtility sharedInstance].localization localizedStringForKey:keyLoginForgotPassword] attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSUnderlineStyleAttributeName : [NSNumber numberWithInt:1]}];
//    
//    [btnForgotPassword setAttributedTitle:titleString forState:UIControlStateNormal];
    [btnForgotPassword.titleLabel setFont:[UIFont fontAvenirNextCondensedMediumWithSize:13]];
    txtEmailAddress.placeholder = [[LooperUtility sharedInstance].localization localizedStringForKey:keyLoginEmailAddress];
    txtPassword.placeholder = [[LooperUtility sharedInstance].localization localizedStringForKey:keyLoginPassword];
    
    
    txtPassword.rightView = btnForgotPassword;
    txtPassword.rightViewMode = UITextFieldViewModeAlways;

        /*
    UIButton *myLoginButton=[UIButton buttonWithType:UIButtonTypeCustom];
    myLoginButton.backgroundColor=[UIColor darkGrayColor];
    myLoginButton.frame=CGRectMake(0,0,180,40);
    myLoginButton.center = self.view.center;
    [myLoginButton setTitle: @"FB LOGIN" forState: UIControlStateNormal];
    
    // Handle clicks on the button
    [myLoginButton
     addTarget:self
     action:@selector(btnFaceBookLoginClicked) forControlEvents:UIControlEventTouchUpInside];
    
    // Add the button to the view
    [self.view addSubview:myLoginButton];
     */
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return true;
}


#pragma Mark - private methods

- (IBAction)btnForgotPasswordPressed:(id)sender
{

    [self performSegueWithIdentifier:@"segueForgotPassword" sender:nil];
}


- (IBAction)btnLoginPressed:(id)sender {
    

    if (![LooperUtility isValidEmail:[txtEmailAddress.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]] && txtEmailAddress.text.length > 0)
    {
        
        [AJNotificationView showNoticeInView:[[[UIApplication sharedApplication] delegate] window]
                                        type:AJNotificationTypeRed
                                       title:@"Please enter a valid email address"
                             linedBackground:AJLinedBackgroundTypeDisabled
                                   hideAfter:2.5f];
        return;

    }
    else if ([LooperUtility isTextFieldEmpty:txtEmailAddress])
    {
        
        [AJNotificationView showNoticeInView:[[[UIApplication sharedApplication] delegate] window]
                                        type:AJNotificationTypeRed
                                       title:@"Please enter email address"
                             linedBackground:AJLinedBackgroundTypeDisabled
                                   hideAfter:2.5f];
        return;
    }
    else if([LooperUtility isTextFieldEmpty:txtPassword])
    {
        [AJNotificationView showNoticeInView:[[[UIApplication sharedApplication] delegate] window]
                                        type:AJNotificationTypeRed
                                       title:@"Please enter the password"
                             linedBackground:AJLinedBackgroundTypeDisabled
                                   hideAfter:2.5f];
        return;
    }
    NSString *userEmail = [txtEmailAddress.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [txtPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSDictionary *dict = @{@"vEmail" : userEmail,
                           @"vPassword" : [password md5],
                           @"ePlatform" : PLATFORM,
                           @"vDeviceToken" : [LooperUtility deviceToken],
                           @"vFBID" : @""};
    
    
    [[ServiceHandler sharedInstance].webService processTravelerLogin:dict successBlock:^(NSDictionary *response)
    {
        NSError *errorUser;
        UserModel *userObject = [[UserModel alloc] initWithDictionary:response error:&errorUser];
        [LooperUtility settingCurrentUser:userObject];
        if (isNotLogin && userObject.eIsLooper == FALSE)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if (userObject.eIsLooper == 1)
        {
            AppdelegateObject.looperGlobalObject.isLooper = TRUE;
            [LooperUtility isAlreadyLoginLooper:false];
        }
        else if (userObject.eIsLooper == 0)
        {
            AppdelegateObject.looperGlobalObject.isLooper = FALSE;
//            [self openSelectCity];
            [LooperUtility isAlreadyLoginTraveler];
        }
        NSLog(@"Current user %@",[LooperUtility getCurrentUser]);
    } errorBlock:^(NSError *error) {
        
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)btnLoginWithFBPressed:(id)sender
{
    [FacebookHandler loginFromViewController:self completion:^(NSError *error, id response)
    {
        if (error == nil)
        {
            NSDictionary *dict = @{@"vEmail" : @"",
                                   @"vPassword" : @"",
                                   @"ePlatform" : PLATFORM,
                                   @"vDeviceToken" : [LooperUtility deviceToken],
                                   @"vFBID" : response[@"id"]};
            
            
            [[ServiceHandler sharedInstance].webService processTravelerLogin:dict successBlock:^(NSDictionary *response)
             {
                 UserModel *userObject = [[UserModel alloc] initWithDictionary:response error:nil];
                 [LooperUtility settingCurrentUser:userObject];
                 if (isNotLogin && userObject.eIsLooper == FALSE)
                 {
                     [self.navigationController popViewControllerAnimated:YES];
                 }
                 else if (userObject.eIsLooper)
                 {
                     AppdelegateObject.looperGlobalObject.isLooper = TRUE;
                     [LooperUtility isAlreadyLoginLooper:false];
                 }
                 else
                 {
                     AppdelegateObject.looperGlobalObject.isLooper = FALSE;
//                     [self openSelectCity];
                     [LooperUtility isAlreadyLoginTraveler];
                 }
                 
             } errorBlock:^(NSError *error) {
                 
             }];

        }
        else
        {
//            [AJNotificationView showNoticeInView:AppdelegateObject.window type:AJNotificationTypeRed title:error.userInfo[NSLocalizedDescriptionKey] linedBackground:AJLinedBackgroundTypeDisabled hideAfter:2.5];
        }
    }];
    
}

-(void)openSelectCity
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Traveler" bundle:nil];
    
    SelectCityMapVC *cityVC = [storyBoard instantiateViewControllerWithIdentifier:@"SelectCityMapVCID"];
    
    [self.navigationController pushViewController:cityVC animated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
