//
//  LoaderView.m
//

#import "LoaderView.h"

@implementation LoaderView

#pragma mark -
#pragma mark Start Loader Methods
+ (void)showLoader {
    [self showLoaderWithOverlay:YES];
}

+ (void)showLoaderWithOverlay: (BOOL)overLay {
    [self showLoaderWithOverlay:overLay message:@""];
}

+ (void)showLoaderWithOverlay: (BOOL)overLay message: (NSString *)message {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication] delegate] window] animated:YES];
    hud.labelText = message;
    if(overLay) {
        hud.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    }
    
    [hud show:YES];
}


+ (void)showLoaderWithUserInteractionEnable: (BOOL)value {
}

#pragma mark -
#pragma mark Stop Loader Methods
+ (void)hideLoader {
    [MBProgressHUD hideAllHUDsForView:[[[UIApplication sharedApplication] delegate] window] animated:YES];
}

+ (void)hideLoaderAfterDelay: (NSTimeInterval)time {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    
    });
}

@end
