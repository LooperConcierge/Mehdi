//
//  AboutUsVC.m
//  Looper
//
//  Created by hardik on 5/3/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "AboutUsVC.h"
#import "LoaderView.h"
#import "Looper-Swift.h"

@interface AboutUsVC ()

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation AboutUsVC
@synthesize openPageIndex,webView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareView];
    // Do any additional setup after loading the view.
}

-(void)prepareView
{
    [[ServiceHandler sharedInstance].webService processGetPagesWithID:openPageIndex successBlock:^(NSDictionary *response)
     {
         self.title = response[@"vPageTitle"];
         [self.webView loadHTMLString:response[@"tContent"] baseURL:nil];
     } errorBlock:^(NSError *error)
     {
         
     }];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[FirebaseChatManager sharedInstance] clearCooky];
}
- (void)didReceiveMemoryWarning {
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

@end
