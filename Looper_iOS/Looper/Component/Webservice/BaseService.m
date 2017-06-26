//
//  BaseService.m
//  Chumm
//
//  Created by Bhuvan on 8/22/15.
//  Copyright (c) 2015 OpenXcell Studio. All rights reserved.
//

#import "BaseService.h"
#import <UIKit/UIKit.h>
#import "ServiceHandler.h"
#import "MBProgressHUD.h"
#import "AJNotificationView.h"


@implementation BaseService

- (instancetype)initWithServiceHandler:(ServiceHandler *)handler {
    self = [super init];
    if (self) {
        servicehandler = handler;
        networkHandler = [[NetworkHandler alloc] initWithBaseUrl:[NSURL URLWithString:kBaseURL]];
    }
    return self;
}

- (BOOL)isStatusSuccess:(id)responseObject {
    NSString *status = responseObject[success];
    
    if ([status integerValue] == 1) {
        return YES;
    } else {
        [MBProgressHUD hideAllHUDsForView:[[[UIApplication sharedApplication] delegate] window] animated:YES];
//        [AJNotificationView showNoticeInView:[[[UIApplication sharedApplication] delegate] window] type:AJNotificationTypeRed title:responseObject[message] linedBackground:AJLinedBackgroundTypeDisabled hideAfter:2.5];
        return NO;
    }
}
@end
