//
//  ForgotPasswordVC.m
//  Looper
//
//  Created by hardik on 2/1/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "ForgotPasswordVC.h"

@interface ForgotPasswordVC ()
@property (strong, nonatomic) IBOutlet UIButton *btnResetPassword;
@property (strong, nonatomic) IBOutlet UILabel *lblResetText;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;

@end

@implementation ForgotPasswordVC
@synthesize btnResetPassword;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareView];
    // Do any additional setup after loading the view.
}

-(void)prepareView
{
    self.lblResetText.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_MEDIUM_SIZE];
    btnResetPassword.titleLabel.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_MEDIUM_SIZE];
//    [btnResetPassword setTitle:[[LooperUtility sharedInstance].localization localizedStringForKey:keySubmit] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (IBAction)btnResetPressed:(id)sender
{
    NSString *messageStr = [self validation];
    
    if (messageStr.length > 0)
    {
        [AJNotificationView showNoticeInView:AppdelegateObject.window type:AJNotificationTypeRed title:messageStr linedBackground:AJLinedBackgroundTypeDisabled hideAfter:2.5];
        
        return;
    }
    
    [[ServiceHandler sharedInstance].webService processForgotPassword:[_txtEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] successBlock:^(NSDictionary *response)
    {
        _txtEmail.text = @"";
        [self.view endEditing:YES];
        [AJNotificationView showNoticeInView:AppdelegateObject.window type:AJNotificationTypeRed title:response[message] linedBackground:AJLinedBackgroundTypeDisabled hideAfter:3.0];
        
    } errorBlock:^(NSError *error)
    {
        
    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


-(NSString *)validation
{
    NSString *message = @"";
    
    if (![_txtEmail.text isValidString])
    {
        [_txtEmail becomeFirstResponder];
        message = @"Please enter email address";
    }
    else if (![_txtEmail.text isValidEmailAddress])
    {
        [_txtEmail becomeFirstResponder];
        message = @"Please enter a valid email address";
    }
    
    return message;
}
@end
