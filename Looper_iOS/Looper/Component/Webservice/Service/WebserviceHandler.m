//
//  WebserviceHandler.m
//  Looper
//
//  Created by hardik on 1/30/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "WebserviceHandler.h"
#import "LooperUtility.h"
#import "AppDelegate.h"
#import "LoaderView.h"
#import "AJNotificationView.h"

NSString const * data = @"DATA";
NSString const * success = @"SUCCESS";
NSString const * error = @"error";
NSString const * message = @"MESSAGE";

static NSString * const generateKey = @"key";
static NSString * const travelerSignUp = @"admin/travellerSignUp";
static NSString * const looperSignUp = @"admin/looperSignUp";
static NSString * const login = @"admin/login";
static NSString * const getCity = @"admin/getCities";
static NSString * const checkEmail = @"admin/checkEmail";
static NSString * const forgotPassword = @"admin/forgot_pass";
static NSString * const getLanguages = @"admin/getLanguages";
static NSString * const logout = @"admin/logout";
static NSString * const getPage = @"admin/getPage";

static NSString * const helpRequest = @"user/helpRequest";
static NSString * const changePassword = @"user/change_pass";

static NSString * const passionList = @"admin/passionList";


@implementation WebserviceHandler

/**
 *  This method is use for get api key
 *
 *  @param jsonObject   is the parameter required for register
 *  @param successBlock successfull login response
 *  @param errorBlock   get error if any
 */

- (void)getAPIKey:(NSDictionary *)jsonObject
     successBlock:(void (^)(NSDictionary *response))successBlock
       errorBlock:(void (^)(NSError *error))errorBlock
{
    
    [networkHandler POST:generateKey parameters:jsonObject success:^(id responseObject)
     {
         if ([self isStatusSuccess:responseObject]) {
             successBlock(responseObject[@"DATA"]);
         }
     } failure:^(NSError *error)
     {
         errorBlock(error);
     }];
    
}


-(void)processTravelerSignUp:(NSDictionary *)jsonObject imageData:(NSDictionary *)imageDictionary successBlock:(void (^)(NSDictionary *))successBlock errorBlock:(void (^)(NSError *))errorBlock
{
    [LoaderView showLoader];
    [networkHandler POST:travelerSignUp parameters:jsonObject imageDictionary:imageDictionary success:^(id responseObject) {
        
        [LoaderView hideLoader];
        if ([self isStatusSuccess:responseObject])
        {
            successBlock(responseObject[@"DATA"]);
        }
        else
        {
            [AJNotificationView showNoticeInView:AppdelegateObject.window type:AJNotificationTypeRed title:responseObject[message] linedBackground:AJLinedBackgroundTypeDisabled hideAfter:1.5];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:AppdelegateObject.window animated:YES];
        errorBlock(error);
    }];
    
}

-(void)processTravelerLogin:(NSDictionary *)jsonObject successBlock:(void (^)(NSDictionary *))successBlock errorBlock:(void (^)(NSError *))errorBlock
{
    [LoaderView showLoader];
    [networkHandler POST:login parameters:jsonObject success:^(id responseObject)
     {
         [LoaderView hideLoader];
         if ([self isStatusSuccess:responseObject])
         {
             successBlock(responseObject[@"DATA"]);
         }
         else
         {
             [AJNotificationView showNoticeInView:AppdelegateObject.window type:AJNotificationTypeRed title:responseObject[message] linedBackground:AJLinedBackgroundTypeDisabled hideAfter:1.5];
         }
         
     } failure:^(NSError *error)
     {
         [LoaderView hideLoader];
         errorBlock(error);
     }];
    
}


-(void)processGetCity:(NSDictionary *)jsonObject successBlock:(void (^)(NSDictionary *))successBlock errorBlock:(void (^)(NSError *))errorBlock
{
    [LoaderView showLoader];
    [networkHandler GET:getCity parameters:nil success:^(id responseObject)
     {
         [LoaderView hideLoader];
         if ([self isStatusSuccess:responseObject])
         {
             successBlock(responseObject[@"DATA"]);
         }
         else
         {
             successBlock(responseObject);
         }
     } failure:^(NSError *error)
     {
         [LoaderView hideLoader];
         errorBlock(error);
     }];
    
}

-(void)processCheckEmail:(NSString *)email successBlock:(void (^)(NSDictionary *))successBlock errorBlock:(void (^)(NSError *))errorBlock
{
    [LoaderView showLoader];
    
    NSDictionary *param = @{@"vEmail" : email};
    
    [networkHandler POST:checkEmail parameters:param success:^(id responseObject)
     {
         [LoaderView hideLoader];
         if ([self isStatusSuccess:responseObject]) {
             successBlock(responseObject[@"DATA"]);
         }
         else
         {
             [AJNotificationView showNoticeInView:AppdelegateObject.window type:AJNotificationTypeRed title:responseObject[message] linedBackground:AJLinedBackgroundTypeDisabled hideAfter:1.5];
         }
         
     } failure:^(NSError *error)
     {
         [LoaderView hideLoader];
         errorBlock(error);
     }];
    
}

-(void)processLooperSignUp:(NSDictionary *)jsonObject imageData:(NSDictionary *)imageDictionary
              successBlock:(void (^)(NSDictionary *))successBlock
                errorBlock:(void (^)(NSError *))errorBlock;
{
    [LoaderView showLoader];
    [networkHandler POST:looperSignUp parameters:jsonObject imageDictionary:imageDictionary success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:AppdelegateObject.window animated:YES];
        if ([self isStatusSuccess:responseObject])
        {
            successBlock(responseObject[@"DATA"]);
        }
        else
        {
            [AJNotificationView showNoticeInView:AppdelegateObject.window type:AJNotificationTypeRed title:responseObject[message] linedBackground:AJLinedBackgroundTypeDisabled hideAfter:1.5];
        }
    } failure:^(NSError *error) {
        [LoaderView hideLoader];
        errorBlock(error);
    }];
    
}

-(void)processForgotPassword:(NSString *)emailID successBlock:(void (^)(NSDictionary *))successBlock errorBlock:(void (^)(NSError *))errorBlock
{
    NSDictionary *param = @{@"vEmail" : emailID};
    [LoaderView showLoader];
    [networkHandler POST:forgotPassword parameters:param  success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:AppdelegateObject.window animated:YES];
        if ([self isStatusSuccess:responseObject])
        {
            successBlock(responseObject[@"DATA"]);
        }
        else
        {
            [AJNotificationView showNoticeInView:AppdelegateObject.window type:AJNotificationTypeRed title:responseObject[message] linedBackground:AJLinedBackgroundTypeDisabled hideAfter:1.5];
        }
    } failure:^(NSError *error) {
        [LoaderView hideLoader];
        errorBlock(error);
    }];
}

-(void)processChangePassword:(NSString *)newPassword oldPassword:(NSString *)oldPassword successBlock:(void (^)(NSDictionary *))successBlock errorBlock:(void (^)(NSError *))errorBlock
{
    NSDictionary *param = @{@"vOldPassword" : oldPassword.md5,
                            @"vNewPassword" : newPassword.md5};
    [LoaderView showLoader];
    [networkHandler POST:changePassword parameters:param  success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:AppdelegateObject.window animated:YES];
        if ([self isStatusSuccess:responseObject])
        {
            successBlock(responseObject[@"DATA"]);
        }
        else
        {
            [AJNotificationView showNoticeInView:AppdelegateObject.window type:AJNotificationTypeRed title:responseObject[message] linedBackground:AJLinedBackgroundTypeDisabled hideAfter:1.5];
        }
    } failure:^(NSError *error) {
        [LoaderView hideLoader];
        errorBlock(error);
    }];
}

-(void)processGetLanguagesWthSuccessBlock:(void (^)(NSDictionary *))successBlock errorBlock:(void (^)(NSError *))errorBlock
{
    [LoaderView showLoader];
    [networkHandler GET:getLanguages parameters:nil  success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:AppdelegateObject.window animated:YES];
        if ([self isStatusSuccess:responseObject])
        {
            successBlock(responseObject[@"DATA"]);
        }
        else
        {
            [AJNotificationView showNoticeInView:AppdelegateObject.window type:AJNotificationTypeRed title:responseObject[message] linedBackground:AJLinedBackgroundTypeDisabled hideAfter:1.5];
        }
    } failure:^(NSError *error) {
        [LoaderView hideLoader];
        errorBlock(error);
    }];
}

-(void)processLogoutWithSuccessBlock:(void (^)(NSDictionary *))successBlock errorBlock:(void (^)(NSError *))errorBlock
{
    [LoaderView showLoader];
    [networkHandler GET:logout parameters:nil  success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:AppdelegateObject.window animated:YES];
        if ([self isStatusSuccess:responseObject])
        {
            successBlock(responseObject[@"DATA"]);
        }
        else
        {
            [AJNotificationView showNoticeInView:AppdelegateObject.window type:AJNotificationTypeRed title:responseObject[message] linedBackground:AJLinedBackgroundTypeDisabled hideAfter:1.5];
        }
    } failure:^(NSError *error) {
        [LoaderView hideLoader];
        errorBlock(error);
    }];
}


//about us = 2,terms condition = 1
-(void)processGetPagesWithID:(NSUInteger)pageID  successBlock:(void (^)(NSDictionary *))successBlock errorBlock:(void (^)(NSError *))errorBlock
{
    [LoaderView showLoader];
    NSDictionary *param = @{@"iPageID" : [NSString stringWithFormat:@"%lu",(unsigned long)pageID]};
    
    [networkHandler POST:getPage parameters:param  success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:AppdelegateObject.window animated:YES];
        if ([self isStatusSuccess:responseObject])
        {
            successBlock(responseObject[@"DATA"]);
        }
        else
        {
            [AJNotificationView showNoticeInView:AppdelegateObject.window type:AJNotificationTypeRed title:responseObject[message] linedBackground:AJLinedBackgroundTypeDisabled hideAfter:1.5];
        }
    } failure:^(NSError *error) {
        [LoaderView hideLoader];
        errorBlock(error);
    }];
}

-(void)processHelpParameters:(NSDictionary *)jsonObject
                SuccessBlock:(void (^)(NSDictionary *))successBlock
                  errorBlock:(void (^)(NSError *))errorBlock
{
    [LoaderView showLoader];
    
    [networkHandler POST:helpRequest parameters:jsonObject success:^(id responseObject) {
        [LoaderView hideLoader];
        if ([self isStatusSuccess:responseObject])
        {
            successBlock(responseObject[data]);
        }
        else
        {
            [AJNotificationView showNoticeInView:AppdelegateObject.window type:AJNotificationTypeRed title:responseObject[message] linedBackground:AJLinedBackgroundTypeDisabled hideAfter:1.5];
        }
    } failure:^(NSError *error) {
        [LoaderView hideLoader];
        errorBlock(error);
    }];
    
}

-(void)processPassionListParameters:(NSDictionary *)jsonObject
                SuccessBlock:(void (^)(NSDictionary *))successBlock
                  errorBlock:(void (^)(NSError *))errorBlock
{
    [LoaderView showLoader];
    
    [networkHandler POST:passionList parameters:jsonObject success:^(id responseObject)
    {
        [LoaderView hideLoader];
        if ([self isStatusSuccess:responseObject])
        {
            successBlock(responseObject[data]);
        }
        else
        {
            [AJNotificationView showNoticeInView:AppdelegateObject.window type:AJNotificationTypeRed title:responseObject[message] linedBackground:AJLinedBackgroundTypeDisabled hideAfter:1.5];
        }
        
    } failure:^(NSError *error) {
        [LoaderView hideLoader];
        errorBlock(error);
    }];
    
}

-(void)addHudOnWindow
{
    
}
@end
