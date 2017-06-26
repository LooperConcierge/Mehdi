//
//  ChangePasswordVC.m
//  Looper
//
//  Created by hardik on 5/3/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "ChangePasswordVC.h"

@interface ChangePasswordVC ()<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *txtCurrentPassword;
@property (strong, nonatomic) IBOutlet UITextField *txtNewPassword;
@property (strong, nonatomic) IBOutlet UITextField *txtConfirmPassword;

@end

@implementation ChangePasswordVC


-(void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareView];
}

-(void)prepareView
{
    self.title = @"CHANGE PASSWORD";
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnUpdatePressed:(id)sender
{
    NSString *messageStr = [self validation];
    
    if (messageStr.length > 0)
    {
        [AJNotificationView showNoticeInView:AppdelegateObject.window type:AJNotificationTypeRed title:messageStr linedBackground:AJLinedBackgroundTypeDisabled hideAfter:2.5];
        return;
    }
    
    [[ServiceHandler sharedInstance].webService processChangePassword:[_txtNewPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] oldPassword:[_txtCurrentPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] successBlock:^(NSDictionary *response)
    {
          [AJNotificationView showNoticeInView:AppdelegateObject.window type:AJNotificationTypeRed title:response[message] linedBackground:AJLinedBackgroundTypeDisabled hideAfter:2.5];
        
        [self.navigationController popViewControllerAnimated:YES];
    } errorBlock:^(NSError *error)
    {
        
    }];
}


-(NSString *)validation
{
    NSString *message = @"";
    
    if (![_txtCurrentPassword.text isValidString])
    {
        [_txtCurrentPassword becomeFirstResponder];
        message = @"Please enter current password";
    }
    else if (![_txtNewPassword.text isValidString])
    {
        [_txtNewPassword becomeFirstResponder];
        message = @"Please enter new password";
    }
    else if (![_txtConfirmPassword.text isValidString])
    {
        [_txtConfirmPassword becomeFirstResponder];
        message = @"Please enter confirm password";
    }
    else if (![[_txtConfirmPassword.text lowercaseString] isEqualToString:[_txtNewPassword.text lowercaseString]])
    {
        [_txtConfirmPassword becomeFirstResponder];
        message = @"New password and confirm password do not match";
    }
    
    return message;
}

#pragma mark - 

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
