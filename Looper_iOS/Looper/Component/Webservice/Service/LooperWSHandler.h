//
//  LooperWSHandler.h
//  Looper
//
//  Created by hardik on 5/5/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "BaseService.h"

@interface LooperWSHandler : BaseService

-(void)processLooperProfileWithSuccessBlock:(void (^)(NSDictionary *))successBlock
                                   errorBlock:(void (^)(NSError *))errorBlock;

-(void)processLooperEditProfileWithParameters:(NSDictionary *)jsonObject
                                     profilePic:(NSDictionary *)profileDict
                                   SuccessBlock:(void (^)(NSDictionary *))successBlock
                                     errorBlock:(void (^)(NSError *))errorBlock;


-(void)processLooperTripRequestListWithSuccessBlock:(void (^)(id response))successBlock
                                         errorBlock:(void (^)(NSError *))errorBlock;

-(void)processLooperTripRequestActionWithRequestID:(NSString *)iRequestID
                                           eStatus:(NSString *)eStatus
                                      SuccessBlock:(void (^)(NSDictionary *))successBlock
                                         errorBlock:(void (^)(NSError *))errorBlock;


-(void)processLooperTripHistoryWithSuccessBlock:(void (^)(NSDictionary *))successBlock
                                     errorBlock:(void (^)(NSError *))errorBlock;

-(void)processLooperTripDetailWithTripID:(NSString*)iTripID
                            SuccessBlock:(void (^)(NSDictionary *))successBlock
                              errorBlock:(void (^)(NSError *))errorBlock;

-(void)processLooperAddTripWith:(NSDictionary *)jsonObject
                   SuccessBlock:(void (^)(NSDictionary *))successBlock
                     errorBlock:(void (^)(NSError *))errorBlock;

-(void)processLooperAddQustionToCommunity:(NSDictionary *)jsonObject
                             SuccessBlock:(void (^)(NSDictionary *))successBlock
                               errorBlock:(void (^)(NSError *))errorBlock;

-(void)processLooperCommunityList:(NSDictionary *)jsonObject
                     SuccessBlock:(void (^)(NSDictionary *))successBlock
                       errorBlock:(void (^)(NSError *))errorBlock;

-(void)processAddCommentToCommunityWithID:(NSString *)communityID
                               strComment:(NSString *)strComment
                             SuccessBlock:(void (^)(NSDictionary *))successBlock
                               errorBlock:(void (^)(NSError *))errorBlock;

-(void)processCommentListWithCommunityID:(NSString *)communityID
                                  pageID:(int)pageid
                            SuccessBlock:(void (^)(NSDictionary *))successBlock
                              errorBlock:(void (^)(NSError *))errorBlock;

-(void)processTravellerDetailWithTripID:(NSString *)tripID
                           iTravellerID:(NSString *)travelerID
                        dTravellingDate:(NSString *)travelingDate
                           dArrivalDate:(NSString *)dArrivalDate
                         dDepartureDate:(NSString *)dDepartureDate
                           SuccessBlock:(void (^)(NSDictionary *))successBlock
                             errorBlock:(void (^)(NSError *))errorBlock;

-(void)processDeleteTrips:(NSString *)tripIDs
             SuccessBlock:(void (^)(NSDictionary *))successBlock
               errorBlock:(void (^)(NSError *))errorBlock;

-(void)processLooperCurrentTripDataSuccessBlock:(void (^)(id response))successBlock
                                     errorBlock:(void (^)(NSError *))errorBlock;

-(void)processGetNotificationList:(NSString *)pageID
                     SuccessBlock:(void (^)(NSDictionary *))successBlock
                       errorBlock:(void (^)(NSError *))errorBlock;


-(void)processSendMessagePush:(NSString *)isLooper
                      emailID:(NSString *)emailID
                      message:(NSString *)message
                 SuccessBlock:(void (^)(NSDictionary *))successBlock
                   errorBlock:(void (^)(NSError *))errorBlock;


-(void)processSaveAccountInfo:(NSDictionary *)param
                    imageDict:(NSDictionary *)imgDict
                 SuccessBlock:(void (^)(NSDictionary *))successBlock
                   errorBlock:(void (^)(NSError *))errorBlock;

-(void)processGetAccountInfoSuccessBlock:(void (^)(NSDictionary *))successBlock
                              errorBlock:(void (^)(NSError *))errorBlock;

-(void)processUpdateAccountInfoParam:(NSDictionary *)param
                        SuccessBlock:(void (^)(NSDictionary *))successBlock
                          errorBlock:(void (^)(NSError *))errorBlock;

-(void)processUpdateAvailability:(NSDictionary *)param
                    SuccessBlock:(void (^)(NSDictionary *))successBlock
                      errorBlock:(void (^)(NSError *))errorBlock;
@end

