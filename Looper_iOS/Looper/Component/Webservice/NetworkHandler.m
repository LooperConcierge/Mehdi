 //
//  NetworkHandler.m
//  Chumm
//
//  Created by Bhuvan on 8/22/15.
//  Copyright (c) 2015 OpenXcell Studio. All rights reserved.
//

#import "NetworkHandler.h"
#import "AFNetworking.h"
#import "Reachability.h"
#import "LooperUtility.h"
#import "AJNotificationView.h"
#import "LoaderView.h"
#import "AppDelegate.h"

static NSString *const APIKEYDEFAULT = @"6d9f729b765aae27f45e5ef9150fa073f8a61b94";

@interface NetworkHandler() {
    AFHTTPSessionManager *networkHandler;
}

@end

@implementation NetworkHandler

- (instancetype)initWithBaseUrl:(NSURL *)url {
    self = [super init];
    if (self) {
        networkHandler = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
        networkHandler.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
//        networkHandler.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        
        
    }
    return self;
}

- (void)dealloc {
    [networkHandler.operationQueue cancelAllOperations];
    networkHandler = nil;
}

- (void)GET:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(id))success
    failure:(void (^)(NSError *))failure {
    if([self isNetworkAvailable]) {
        [self setHTTPHeader];
        [networkHandler GET:URLString
                 parameters:parameters
                   progress:nil
                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        NSLog(@"GET responseObject is %@",responseObject);
                        success(responseObject);
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        [self handleErrorCode:[(NSHTTPURLResponse *)task.response statusCode]];
                        failure(error);
                    }];
    }
}

- (void)POST:(NSString *)URLString
  parameters:(id)parameters
     success:(void (^)(id))success
     failure:(void (^)(NSError *))failure {
    
    if(parameters)
        NSLog(@"%@", parameters);
    
    if([self isNetworkAvailable]) {
        [self setHTTPHeader];
        [networkHandler POST:URLString
                  parameters:parameters
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         NSLog(@"responseObject is %@",responseObject);
                         success(responseObject);
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         if([(NSHTTPURLResponse *)task.response statusCode] == -1005){
                             [networkHandler POST:URLString
                                       parameters:parameters
                                         progress:nil
                                          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                              NSLog(@"responseObject is %@",responseObject);
                                              success(responseObject);
                                          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                              [self handleErrorCode:[(NSHTTPURLResponse *)task.response statusCode]];
                                              failure(error);
                                          }];
                         } else {
                             [self handleErrorCode:[(NSHTTPURLResponse *)task.response statusCode]];
                             failure(error);
                         }
                     }];
    }
}

- (void)PUT:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(id))success
    failure:(void (^)(NSError *))failure {
    if([self isNetworkAvailable]) {
        [self setHTTPHeader];
        [networkHandler PUT:URLString
                 parameters:parameters
                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        success(responseObject);
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        [self handleErrorCode:[(NSHTTPURLResponse *)task.response statusCode]];
                        failure(error);
                    }];
    }
}

- (void)POST:(NSString *)URLString
  parameters:(id)parameters
imageDictionary:(NSDictionary *)imageDict
     success:(void (^)(id))success
     failure:(void (^)(NSError *))failure {
    if([self isNetworkAvailable]) {
        [self setHTTPHeader];
        [networkHandler POST:URLString
                  parameters:parameters
   constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
       for (NSString *key in imageDict.allKeys) {
           
           [formData appendPartWithFileData:UIImageJPEGRepresentation([imageDict valueForKey:key], 0.5)
                                       name:key
                                   fileName:[NSString stringWithFormat:@"%@.jpg",key]
                                   mimeType:@"image/jpg"];
       }
   }
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         success(responseObject);
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         if([(NSHTTPURLResponse *)task.response statusCode] == -1005) {
                             [networkHandler POST:URLString
                                       parameters:parameters
                        constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                            for (NSString *key in imageDict.allKeys) {
                                [formData appendPartWithFileData:UIImageJPEGRepresentation([imageDict valueForKey:key], 0.5)
                                                            name:key
                                                        fileName:[NSString stringWithFormat:@"%@.jpg",key]
                                                        mimeType:@"image/jpg"];
                            }
                        }
                                         progress:nil
                                          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                              success(responseObject);
                                          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                              [self handleErrorCode:[(NSHTTPURLResponse *)task.response statusCode]];
                                              failure(error);
                                          }];
                             
                         } else {
                             [self handleErrorCode:[(NSHTTPURLResponse *)task.response statusCode]];
                             failure(error);
                         }
                     }];
    }
}

- (void)POST:(NSString *)URLString
  parameters:(id)parameters
imageDictionary:(NSDictionary *)imageDict
    videoURL:(NSDictionary *)dictVideoURL
     success:(void (^)(id))success
     failure:(void (^)(NSError *))failure {
    if([self isNetworkAvailable]) {
        [self setHTTPHeader];
        [networkHandler POST:URLString
                  parameters:parameters
   constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
       for (NSString *key in imageDict.allKeys) {
           [formData appendPartWithFileData:UIImageJPEGRepresentation([imageDict valueForKey:key], 0.5)
                                       name:key
                                   fileName:[NSString stringWithFormat:@"%@.jpg",key]
                                   mimeType:@"image/jpg"];
       }
       
       for (NSString *key in dictVideoURL.allKeys) {
           [formData appendPartWithFileData:[NSData dataWithContentsOfURL:[dictVideoURL valueForKey:key]]
                                       name:key
                                   fileName:[NSString stringWithFormat:@"%@.mov",key]
                                   mimeType:@"video/quicktime"];
       }
   }
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         success(responseObject);
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         if([(NSHTTPURLResponse *)task.response statusCode] == -1005) {
                             [networkHandler POST:URLString
                                       parameters:parameters
                        constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                            for (NSString *key in imageDict.allKeys) {
                                [formData appendPartWithFileData:UIImageJPEGRepresentation([imageDict valueForKey:key], 0.5)
                                                            name:key
                                                        fileName:[NSString stringWithFormat:@"%@.jpg",key]
                                                        mimeType:@"image/jpg"];
                            }
                            
                            for (NSString *key in dictVideoURL.allKeys) {
                                [formData appendPartWithFileData:[NSData dataWithContentsOfURL:[dictVideoURL valueForKey:key]]
                                                            name:key
                                                        fileName:[NSString stringWithFormat:@"%@.mov",key]
                                                        mimeType:@"video/quicktime"];
                            }
                        }
                                         progress:nil
                                          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                              success(responseObject);
                                          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                              [self handleErrorCode:[(NSHTTPURLResponse *)task.response statusCode]];
                                              failure(error);
                                          }];
                             
                         } else {
                             [self handleErrorCode:[(NSHTTPURLResponse *)task.response statusCode]];
                             failure(error);
                         }
                     }];
    }
}

- (void)DELETE:(NSString *)URLString
    parameters:(id)parameters
       success:(void (^)(id))success
       failure:(void (^)(NSError *))failure {
    if([self isNetworkAvailable]) {
        [self setHTTPHeader];
        [networkHandler DELETE:URLString
                    parameters:parameters
                       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                           success(responseObject);
                       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                           [self handleErrorCode:[(NSHTTPURLResponse *)task.response statusCode]];
                           failure(error);
                       }];
    }
}

#pragma mark - Set default key in header

- (void)setHTTPHeader {
    
    // If user has a X-API-Key
    NSString *apiKey = [LooperUtility getApiKeyUserDefaults];
    if (apiKey.length > 0)
    {
        [networkHandler.requestSerializer setValue:apiKey forHTTPHeaderField:@"X-API-KEY"];
        NSLog(@"X-API-KEY: %@",apiKey);
        
    } else { // Use the default X-API-Key
        [networkHandler.requestSerializer setValue:APIKEYDEFAULT forHTTPHeaderField:@"X-API-KEY"];
        NSLog(@"X-API-KEY: %@",APIKEYDEFAULT);
    }
    
    UserModel *modelObject = [LooperUtility getCurrentUser];
    if (modelObject != nil)
    {
        NSLog(@"iUserID %d %@",modelObject.iUserID,modelObject.accesstoken);
        [networkHandler.requestSerializer setValue:modelObject.accesstoken forHTTPHeaderField:@"accesstoken"];
        [networkHandler.requestSerializer setValue:[NSString stringWithFormat:@"%d",modelObject.iUserID] forHTTPHeaderField:@"iUserID"];
    }
}

- (void)handleErrorCode:(NSUInteger)statusCode {
        [LoaderView hideLoader];
    
    switch (statusCode) {
        case 401: {
            //            [_AppDelegate removeUserDataWithLogout];
            [AJNotificationView showNoticeInView:[[[UIApplication sharedApplication] delegate] window] type:AJNotificationTypeRed title:@"Your current session is expired. Please Login again." linedBackground:AJLinedBackgroundTypeDisabled hideAfter:2.5];
            [LooperUtility logoutCurrentUser];
            [LooperUtility openLoginScreen];
            [AppdelegateObject getApiKey];
             break;
        }
           
        case -1005:
            break;
        case 200: {
            [AJNotificationView showNoticeInView:[[[UIApplication sharedApplication] delegate] window] type:AJNotificationTypeRed title:@"Problem connecting to server, please try again later." linedBackground:AJLinedBackgroundTypeDisabled hideAfter:2.5];
            break;
        }
        case 403:
        {
            [AJNotificationView showNoticeInView:[[[UIApplication sharedApplication] delegate] window] type:AJNotificationTypeRed title:@"You have logged in from other device." linedBackground:AJLinedBackgroundTypeDisabled hideAfter:2.5];
            [LooperUtility logoutCurrentUser];
            [LooperUtility openLoginScreen];
            [AppdelegateObject getApiKey];
            break;
        }
        default: {
            //            [appDelegate Hide];
            [LoaderView hideLoader];
//            [AJNotificationView showNoticeInView:[[[UIApplication sharedApplication] delegate] window] type:AJNotificationTypeRed title:@"Something went wrong. Please try again" linedBackground:AJLinedBackgroundTypeDisabled hideAfter:2.5];
            break;
        }
    }
}

#pragma mark - Network availability
- (BOOL)isNetworkAvailable {
    BOOL isConnected;
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    isConnected = !(networkStatus == NotReachable);
    
    if(!isConnected) {
//                [AlertHandler showAlert:MSG_ErrorInternetConnection];
        [AJNotificationView showNoticeInView:[[[UIApplication sharedApplication] delegate] window] type:AJNotificationTypeRed title:@"No Internet connection available" linedBackground:AJLinedBackgroundTypeDisabled hideAfter:2.5];
        
//        [LoaderView hideLoader];
        [self performSelector:@selector(hideProgressHud) withObject:nil afterDelay:2.5];
    }
    
    return isConnected;
}

-(void)hideProgressHud
{
    [LoaderView hideLoader];
}
@end
