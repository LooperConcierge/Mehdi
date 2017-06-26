//
//  BaseViewController.h
//  Looper
//
//  Created by Meera Dave on 30/01/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIFont+CustomFont.h"
#import "UIImageView+AFNetworking.h"
#import "AlertController.h"
extern NSString *strControllerTitle;
#define Appdelegate ((AppDelegate*)[[UIApplication sharedApplication]delegate])

#define HEIGHT_IPHONE_4  480
#define HEIGHT_IPHONE_5  568
#define HEIGHT_IPHONE_6  667
#define HEIGHT_IPHONE_6P 736

#define DEFAULT_CONSTRAINT_IPHONE_4 -3
#define DEFAULT_CONSTRAINT_IPHONE_6  9
#define DEFAULT_CONSTRAINT_IPHONE_6P 13

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)


@interface BaseViewController : UIViewController
{
    UIStoryboard *storyBoardLooper;
    UIStoryboard *storyBoardTraveller;
}
- (void)setTitleView:(NSString*)title;
- (void)setBackItems;
-(void)hideNavItem;
@end
