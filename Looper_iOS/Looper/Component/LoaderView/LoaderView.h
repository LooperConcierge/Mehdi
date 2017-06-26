//
//  LoaderView.h
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface LoaderView : NSObject

+ (void)showLoader;
+ (void)showLoaderWithOverlay: (BOOL)overLay;
+ (void)showLoaderWithOverlay: (BOOL)overLay message: (NSString *)message;
+ (void)showLoaderWithUserInteractionEnable: (BOOL)value;

+ (void)hideLoader;
+ (void)hideLoaderAfterDelay: (NSTimeInterval)time;

@end
