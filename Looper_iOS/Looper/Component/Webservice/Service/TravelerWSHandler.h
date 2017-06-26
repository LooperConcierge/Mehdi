//
//  TravelerWSHandler.h
//  Looper
//
//  Created by hardik on 5/4/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "BaseService.h"

extern const NSString *profile;

@interface TravelerWSHandler : BaseService

-(void)processTravelerProfileWithSuccessBlock:(void (^)(NSDictionary *))successBlock
                                   errorBlock:(void (^)(NSError *))errorBlock;

-(void)processTravelerEditProfileWithParameters:(NSDictionary *)jsonObject
                                     profilePic:(NSDictionary *)profileDict
                                   SuccessBlock:(void (^)(NSDictionary *))successBlock
                                     errorBlock:(void (^)(NSError *))errorBlock;

-(void)processGetLooperListWithParameter:(NSDictionary *)jsonObject
                            SuccessBlock:(void (^)(NSDictionary *))successBlock
                              errorBlock:(void (^)(NSError *))errorBlock;

-(void)processGetLooperListBySearchWithParameter:(NSDictionary *)jsonObject
                                    successBlock:(void (^)(NSDictionary *))successBlock
                                      errorBlock:(void (^)(NSError *))errorBlock;

-(void)processAddTripWithParameter:(NSDictionary *)jsonObject
                      successBlock:(void (^)(NSDictionary *))successBlock
                        errorBlock:(void (^)(NSError *))errorBlock;

-(void)processTripHistoryWithSuccessBlock:(void (^)(NSDictionary *))successBlock
                               errorBlock:(void (^)(NSError *))errorBlock;


-(void)processTripDetailWithParameter:(NSDictionary *)jsonObject
                         successBlock:(void (^)(NSDictionary *))successBlock
                           errorBlock:(void (^)(NSError *))errorBlock;

-(void)processPayNowTripDetailWithParameter:(NSString *)looperID
                                     tripID:(NSString *)tripID
                               successBlock:(void (^)(NSDictionary *))successBlock
                                 errorBlock:(void (^)(NSError *))errorBlock;

-(void)processRequestToChangeWithTripID:(NSString *)iTravellerTripID
                           successBlock:(void (^)(NSDictionary *))successBlock
                             errorBlock:(void (^)(NSError *))errorBlock;

-(void)processScheduleTripSuccessBlock:(void (^)(NSDictionary *))successBlock
                            errorBlock:(void (^)(NSError *))errorBlock;


-(void)processPaymentTripWithParam:(NSDictionary *)param SuccessBlock:(void (^)(NSDictionary *))successBlock
                        errorBlock:(void (^)(NSError *))errorBlock;

-(void)processRateLooper:(NSDictionary *)param SuccessBlock:(void (^)(NSDictionary *))successBlock
              errorBlock:(void (^)(NSError *))errorBlock;

-(void)processEditImage:(NSDictionary *)param SuccessBlock:(void (^)(NSDictionary *))successBlock
             errorBlock:(void (^)(NSError *))errorBlock;

-(void)processGetLooperDetailWithID:(NSString *)iLooperID SuccessBlock:(void (^)(NSDictionary *))successBlock errorBlock:(void (^)(NSError *))errorBlock;

-(void)processNotificationRead:(NSString *)iLooperID SuccessBlock:(void (^)(NSDictionary *))successBlock errorBlock:(void (^)(NSError *))errorBlock;
@end
