//
//  ContactUsVC.m
//  Looper
//
//  Created by hardik on 5/3/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "ContactUsVC.h"
#import <MessageUI/MessageUI.h>

@interface ContactUsVC ()<MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *lblEmail;
@end

@implementation ContactUsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareView];
    // Do any additional setup after loading the view.
}

-(void)prepareView
{
    self.title = @"CONTACT US";
    if (AppdelegateObject.looperGlobalObject.isLooper == true)
    {
        _lblEmail.text = @"partners@loopertravel.com";
    }
    else
    {
        _lblEmail.text = @"contact@loopertravel.com";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(IBAction)btnEmailContactUs:(id)sender
{
    // Email Subject
    NSString *emailTitle = @"";
    // Email Content
    NSString *messageBody = @"";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:_lblEmail.text];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
}

-(IBAction)btnCallContactUs:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Contact" message:@"Do you want to call?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alert.tag = 1000;
    [alert show];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 02 && buttonIndex != alertView.cancelButtonIndex) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"teleport://%@",@"+1-1800-200-300"]]];
    }
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
