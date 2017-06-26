//
//  HelpVC.m
//  Looper
//
//  Created by hardik on 5/3/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "HelpVC.h"

@interface HelpVC ()
@property (strong, nonatomic) IBOutlet UITextField *txtSubject;
@property (strong, nonatomic) IBOutlet UITextView *txtViewMessage;

@end

@implementation HelpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareView];
    // Do any additional setup after loading the view.
}

-(void)prepareView
{
    self.title = @"HELP";
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 

-(IBAction)btnUpdatePressed:(id)sender
{
    if (_txtSubject.text.length > 0)
    {
        
        [AJNotificationView showNoticeInView:[[[UIApplication sharedApplication] delegate] window]
                                        type:AJNotificationTypeRed
                                       title:@"Please insert subject"
                             linedBackground:AJLinedBackgroundTypeDisabled
                                   hideAfter:2.5f];
        return;
        
    }
    else if (_txtViewMessage.text.length > 0)
    {
        
        [AJNotificationView showNoticeInView:[[[UIApplication sharedApplication] delegate] window]
                                        type:AJNotificationTypeRed
                                       title:@"Please fill the message"
                             linedBackground:AJLinedBackgroundTypeDisabled
                                   hideAfter:2.5f];
        return;
    }
    
    NSDictionary *param = @{@"vSubject" : [_txtSubject.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],
                            @"tMessage" : [_txtViewMessage.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]};
    
    [[ServiceHandler sharedInstance].webService processHelpParameters:param SuccessBlock:^(NSDictionary *response)
    {
        [AJNotificationView showNoticeInView:[[[UIApplication sharedApplication] delegate] window]
                                        type:AJNotificationTypeRed
                                       title:@"We have get your request.\nwe will contact you soon"
                             linedBackground:AJLinedBackgroundTypeDisabled
                                   hideAfter:3.5f];
        _txtViewMessage.text = @"";
        _txtSubject.text = @"";
        
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

@end
