//
//  WebserviceHandler.h
//  Looper
//
//  Created by hardik on 1/30/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "WebserviceClient.h"
#import "BaseService.h"
//#define WebserviceSharedClient ((WebserviceClient *)[WebserviceClient WebserviceSharedClient])


//@interface WebserviceHandler : NSObject
@interface WebserviceHandler : BaseService

extern NSString const * data;
extern NSString const * success;
extern NSString const * error;
extern NSString const * message;

- (void)getAPIKey:(NSDictionary *)jsonObject
     successBlock:(void (^)(NSDictionary *response))successBlock
       errorBlock:(void (^)(NSError *error))errorBlock;

-(void)processTravelerSignUp:(NSDictionary *)jsonObject imageData:(NSDictionary *)imageDictionary
                successBlock:(void (^)(NSDictionary *))successBlock
                  errorBlock:(void (^)(NSError *))errorBlock;


-(void)processLooperSignUp:(NSDictionary *)jsonObject imageData:(NSDictionary *)imageDictionary
              successBlock:(void (^)(NSDictionary *))successBlock
                errorBlock:(void (^)(NSError *))errorBlock;


-(void)processTravelerLogin:(NSDictionary *)jsonObject
               successBlock:(void (^)(NSDictionary *))successBlock
                 errorBlock:(void (^)(NSError *))errorBlock;

-(void)processGetCity:(NSDictionary *)jsonObject
         successBlock:(void (^)(NSDictionary *))successBlock
           errorBlock:(void (^)(NSError *))errorBlock;

-(void)processCheckEmail:(NSString *)email
            successBlock:(void (^)(NSDictionary *))successBlock
              errorBlock:(void (^)(NSError *))errorBlock;

-(void)processForgotPassword:(NSString *)emailID
                successBlock:(void (^)(NSDictionary *))successBlock
                  errorBlock:(void (^)(NSError *))errorBlock;

-(void)processChangePassword:(NSString *)newPassword oldPassword:(NSString *)oldPassword
                successBlock:(void (^)(NSDictionary *))successBlock
                  errorBlock:(void (^)(NSError *))errorBlock;

-(void)processGetLanguagesWthSuccessBlock:(void (^)(NSDictionary *))successBlock
                               errorBlock:(void (^)(NSError *))errorBlock;

-(void)processLogoutWithSuccessBlock:(void (^)(NSDictionary *))successBlock
                          errorBlock:(void (^)(NSError *))errorBlock;

-(void)processGetPagesWithID:(NSUInteger)pageID
                successBlock:(void (^)(NSDictionary *))successBlock
                  errorBlock:(void (^)(NSError *))errorBlock;

-(void)processHelpParameters:(NSDictionary *)jsonObject
                SuccessBlock:(void (^)(NSDictionary *))successBlock
                  errorBlock:(void (^)(NSError *))errorBlock;

-(void)processPassionListParameters:(NSDictionary *)jsonObject
                       SuccessBlock:(void (^)(NSDictionary *))successBlock
                         errorBlock:(void (^)(NSError *))errorBlock;
@end
