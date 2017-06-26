//
//  WebserviceClient.h
//  Looper
//
//  Created by hardik on 1/30/16.
//  Copyright © 2016 looper. All rights reserved.
//



#import <AFNetworking/AFNetworking.h>

@interface WebserviceClient : AFHTTPSessionManager

+(instancetype)WebserviceSharedClient:(NSString *)key;

@end
