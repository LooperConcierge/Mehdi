//
//  TravellerListingViewController.h
//  Looper
//
//  Created by Meera Dave on 02/02/16.
//  Copyright © 2016 looper. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "BaseNavVC.h"

@interface TravellerListingViewController : BaseNavVC

@property (strong, nonatomic) IBOutlet UIView *viewnavTitleBar;
@property (strong, nonatomic) IBOutlet UIButton *btnRequest;
@property (strong, nonatomic) IBOutlet UIButton *btnTraveller;

-(IBAction)onTapBtnRequest:(id)sender;

-(void)onTapBtnFromNotificationTripID:(NSString *)tripID;
@end
