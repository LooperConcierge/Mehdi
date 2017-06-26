//
//  WebserviceClient.m
//  Looper
//
//  Created by hardik on 1/30/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "WebserviceClient.h"

@implementation WebserviceClient

static NSString * const AFAppDotNetAPIBaseURLString = @"http://192.168.1.41/looper/ws";
static NSString * const keyWebService = @"6d9f729b765aae27f45e5ef9150fa073f8a61b94";
/**
 *  This is base class for webservice
 *
 *  @return returns the url session client object
 */
+(instancetype)WebserviceSharedClient:(NSString *)key
{
    static WebserviceClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[WebserviceClient alloc] initWithBaseURL:[NSURL URLWithString:AFAppDotNetAPIBaseURLString]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
//        _sharedClient.requestSerializer = [AFHTTPRequestSerializer serializer];
//        _sharedClient.responseSerializer = [AFHTTPResponseSerializer serializer];
        if (key == nil)
            [_sharedClient.requestSerializer setValue:keyWebService forHTTPHeaderField:@"X-API-KEY"];
        else
            [_sharedClient.requestSerializer setValue:key forHTTPHeaderField:@"X-API-KEY"];
    });
    
    return _sharedClient;

}

@end
