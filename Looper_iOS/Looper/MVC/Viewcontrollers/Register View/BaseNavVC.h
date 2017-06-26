//
//  BaseNavVC.h
//  Looper
//
//  Created by hardik on 2/1/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LooperUtility.h"
#import "Constants.h"
#import "UIImageView+ExtraFuction.h"
#import "UIFont+CustomFont.h"
#import "UIColor+CustomColor.h"
#import "GIBadgeView.h"
#import "AJNotificationView.h"
#import "UIButton+AFNetworking.h"
#import "TripDetailModelList.h"

//For blur image//
#import "UIImageView+LBBlurredImage.h"
#import "UIImage+ImageEffects.h"
#import "NSString+Validations.h"
//end blur image//

@protocol BaseNavDelegate <NSObject>

-(void)btnPushPressed;

@end


@interface BaseNavVC : UIViewController

@property (nonatomic, weak) id<BaseNavDelegate>delegate;

//@property (nonatomic, strong) GIBadgeView *badgeView;

@property (nonatomic, strong) UIButton *btnBack;

-(void)setBackButtonTitle;

-(void)addBackButton;

-(void)resetBadgerValue;

@end
