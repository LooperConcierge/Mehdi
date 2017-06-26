//
//  FacebookHandler.m
//

#import "FacebookHandler.h"
#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "LoaderView.h"

@implementation FacebookHandler

#pragma mark -
#pragma mark Login Methods
+ (void)loginFromViewController: (UIViewController *)viewController completion: (FBLoginCompletion)completion {
    [self logout];
    if ([FBSDKAccessToken currentAccessToken]) {
        [self doLoginWithCompletion:^(NSError *error, id response) {
            completion(error, response);
        }];
        return;
    }

    
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    loginManager.loginBehavior = FBSDKLoginBehaviorBrowser;
    
    [loginManager logInWithReadPermissions:@[@"public_profile",@"email",@"user_birthday", @"user_location"] fromViewController:viewController handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        {
            if (error) {
                completion(nil, error);
                NSLog(@"Facebook login failed. Error: %@", [error localizedDescription]);
            } else if (result.isCancelled) {
                NSError *error1 = [[NSError alloc] initWithDomain:@"Facebook login got cancelled" code:-1 userInfo:[NSDictionary dictionaryWithObject:@"Facebook login got cancelled" forKey:NSLocalizedDescriptionKey]];
                completion(error1, nil);
                NSLog(@"Facebook login got cancelled.");
            } else {
                //                                            NSString *accessToken = [[FBSDKAccessToken currentAccessToken] tokenString];
                
                
//                AppdelegateObject.hud = [MBProgressHUD showHUDAddedTo:AppdelegateObject.window animated:YES];
//                AppdelegateObject.hud.mode = MBProgressHUDModeIndeterminate;
                [LoaderView showLoader];
                if ([FBSDKAccessToken currentAccessToken]) {
                    [self doLoginWithCompletion:^(NSError *error, id response) {
                        completion(error, response);
                    }];
                }
            }
        }
    }];
}

+ (void)doLoginWithCompletion: (FBLoginCompletion)completion {
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields" : @"id,name,email,first_name,last_name,birthday,location"}] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        
//        [MBProgressHUD hideHUDForView:AppdelegateObject.window animated:YES];
        [LoaderView hideLoader];
        if (error) {
            NSLog(@"Facebook login failed. Error: %@",error);
            completion(error, nil);
        } else {
            completion(nil, result);
        }
    }];
}

#pragma mark -
#pragma mark Logout Methods
+ (void)logout {
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    [loginManager logOut];
    [FBSDKAccessToken setCurrentAccessToken:nil];
}

@end
