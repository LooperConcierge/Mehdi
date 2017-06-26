//
//  AskQuestionVC.m
//  Looper
//
//  Created by hardik on 5/19/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "AskQuestionVC.h"

@interface AskQuestionVC ()

@property (strong, nonatomic) IBOutlet UITextView *txtViewQuestion;
@property (strong, nonatomic) IBOutlet UIButton *btnSubmit;
@end

@implementation AskQuestionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareView];
    // Do any additional setup after loading the view.
}

-(void)prepareView
{
    _btnSubmit.titleLabel.font = [UIFont fontAvenirNextCondensedRegularWithSize:FONT_HEADER_SIZE];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnSubmitPressed:(id)sender
{
    if (![_txtViewQuestion.text isValidString])
    {
        [AJNotificationView showNoticeInView:AppdelegateObject.window type:AJNotificationTypeRed title:@"Please ask question" linedBackground:AJLinedBackgroundTypeDisabled hideAfter:2.5];
        return;
    }
    
    [[ServiceHandler sharedInstance].looperWebService processLooperAddQustionToCommunity:@{@"vQuestion":[_txtViewQuestion.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]} SuccessBlock:^(NSDictionary *response)
    {
        [AJNotificationView showNoticeInView:AppdelegateObject.window type:AJNotificationTypeRed title:@"Question posted successfully" linedBackground:AJLinedBackgroundTypeDisabled hideAfter:2.5];
        [self.navigationController popViewControllerAnimated:YES];
    } errorBlock:^(NSError *error)
    {
        
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
