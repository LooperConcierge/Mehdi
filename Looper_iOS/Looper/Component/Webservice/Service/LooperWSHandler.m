//
//  LooperWSHandler.m
//  Looper
//
//  Created by hardik on 5/5/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "LooperWSHandler.h"
#import "LooperUtility.h"
#import "AppDelegate.h"
#import "LoaderView.h"

static NSString * const getLooperProfile = @"user/getMyProfileLooper";
static NSString *const updateAccountInfo = @"payment/updateAccount";
static NSString *const getAccountInfo = @"payment/accountInfo";
static NSString *const savepayment = @"payment/saveAccount";
static NSString *const editProfile = @"user/editProfileLooper";
static NSString *const tripRequestList = @"looper/requestList";
static NSString *const tripRequestAction = @"looper/requestAction";
static NSString *const tripTravelerDetail = @"looper/travellerDetail";
static NSString *const tripLooperHistory = @"looper/tripHistory";
static NSString *const addTrip = @"looper/addTrip";
static NSString *const addQuestionToCommunity = @"community/addQuestion";
static NSString *const communityList = @"community/questionList";
static NSString *const communityAddQuestion = @"community/addQuestion";
static NSString *const commentList = @"community/commentList";
static NSString *const communityAddComment = @"community/addComment";
static NSString *const travellerDetail = @"traveller/tripDetail";
static NSString *const deleteTripDetail = @"looper/deleteDayTrip";
static NSString *const looperCurrentTrip = @"looper/currentTrip";
static NSString *const notificationList  = @"looper/notificationList";
static NSString *const messagePush       = @"looper/tripMessage";
static NSString *const updateAvailability    = @"looper/updateAva";


@implementation LooperWSHandler

-(void)processLooperProfileWithSuccessBlock:(void (^)(NSDictionary *))successBlock errorBlock:(void (^)(NSError *))errorBlock
{
    [LoaderView showLoader];
    [networkHandler POST:getLooperProfile parameters:nil  success:^(id responseObject) {
        [LoaderView hideLoader];
        if ([self isStatusSuccess:responseObject])
        {
            successBlock(responseObject[data]);
        }
    } failure:^(NSError *error) {
        [LoaderView hideLoader];
        errorBlock(error);
    }];
}


-(void)processLooperEditProfileWithParameters:(NSDictionary *)jsonObject
                                     profilePic:(NSDictionary *)profileDict
                                   SuccessBlock:(void (^)(NSDictionary *))successBlock
                                     errorBlock:(void (^)(NSError *))errorBlock
{
    [LoaderView showLoader];
    
    [networkHandler POST:editProfile parameters:jsonObject imageDictionary:profileDict success:^(id responseObject) {
        [LoaderView hideLoader];
        if ([self isStatusSuccess:responseObject])
        {
            successBlock(responseObject[data]);
        }
    } failure:^(NSError *error) {
        [LoaderView hideLoader];
        errorBlock(error);
    }];
    
}

-(void)processLooperTripRequestListWithSuccessBlock:(void (^)(id response))successBlock
                                         errorBlock:(void (^)(NSError *))errorBlock
{

    [LoaderView showLoader];
    
    [networkHandler POST:tripRequestList parameters:nil success:^(id responseObject)
    {
        [LoaderView hideLoader];
        if ([self isStatusSuccess:responseObject])
        {
            successBlock(responseObject[data]);
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

-(void)processLooperCurrentTripDataSuccessBlock:(void (^)(id response))successBlock
                                         errorBlock:(void (^)(NSError *))errorBlock
{
    
    [LoaderView showLoader];
    
    [networkHandler POST:looperCurrentTrip parameters:nil success:^(id responseObject)
     {
         [LoaderView hideLoader];
         if ([self isStatusSuccess:responseObject])
         {
             successBlock(responseObject[data]);
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

-(void)processLooperTripRequestActionWithRequestID:(NSString *)iRequestID
                                           eStatus:(NSString *)eStatus
                                      SuccessBlock:(void (^)(NSDictionary *))successBlock
                                        errorBlock:(void (^)(NSError *))errorBlock
{
 
    [LoaderView showLoader];
    
    NSDictionary *dict = @{@"iRequestID" : iRequestID,
                           @"eStatus": eStatus};
    
    [networkHandler POST:tripRequestAction parameters:dict success:^(id responseObject)
     {
         [LoaderView hideLoader];
         if ([self isStatusSuccess:responseObject])
         {
             successBlock(responseObject[data]);
         }
         
     } failure:^(NSError *error)
     {
         [LoaderView hideLoader];
         errorBlock(error);
     }];
    
}

-(void)processLooperTripHistoryWithSuccessBlock:(void (^)(NSDictionary *))successBlock
                                        errorBlock:(void (^)(NSError *))errorBlock
{
    
    [LoaderView showLoader];
    
    [networkHandler POST:tripLooperHistory parameters:nil success:^(id responseObject)
     {
         [LoaderView hideLoader];
         
        successBlock(responseObject[data]);
         
     } failure:^(NSError *error)
     {
         [LoaderView hideLoader];
         errorBlock(error);
     }];
    
}

-(void)processLooperTripDetailWithTripID:(NSString*)iTripID
                            SuccessBlock:(void (^)(NSDictionary *))successBlock
                                     errorBlock:(void (^)(NSError *))errorBlock
{
    
    [LoaderView showLoader];
    
    NSDictionary *dict = @{@"iTripID": iTripID};
    
    [networkHandler POST:tripTravelerDetail parameters:dict success:^(id responseObject)
     {
         [LoaderView hideLoader];
         if ([self isStatusSuccess:responseObject])
         {
             successBlock(responseObject[data]);
         }
         
     } failure:^(NSError *error)
     {
         [LoaderView hideLoader];
         errorBlock(error);
     }];
    
}

-(void)processLooperAddTripWith:(NSDictionary *)jsonObject
                            SuccessBlock:(void (^)(NSDictionary *))successBlock
                              errorBlock:(void (^)(NSError *))errorBlock
{
    
    [LoaderView showLoader];
    
    [networkHandler POST:addTrip parameters:jsonObject success:^(id responseObject)
     {
         [LoaderView hideLoader];
         if ([self isStatusSuccess:responseObject])
         {
             successBlock(responseObject[data]);
         }
         
     } failure:^(NSError *error)
     {
         [LoaderView hideLoader];
         errorBlock(error);
     }];
    
}

-(void)processLooperAddQustionToCommunity:(NSDictionary *)jsonObject
                   SuccessBlock:(void (^)(NSDictionary *))successBlock
                     errorBlock:(void (^)(NSError *))errorBlock
{
    
    [LoaderView showLoader];
    
    LooperModel *model = [LooperUtility getLooperProfile];
    
    NSDictionary *param  = @{@"vCity" : model.vCity,
                             @"vState" : model.vState,
                             @"vQuestion" : jsonObject[@"vQuestion"]
                             };
    
    [networkHandler POST:addQuestionToCommunity parameters:param success:^(id responseObject)
     {
         [LoaderView hideLoader];
         if ([self isStatusSuccess:responseObject])
         {
             successBlock(responseObject[data]);
         }
         
     } failure:^(NSError *error)
     {	
         [LoaderView hideLoader];
         errorBlock(error);
     }];
    
}

-(void)processLooperCommunityList:(NSDictionary *)jsonObject
                             SuccessBlock:(void (^)(NSDictionary *))successBlock
                               errorBlock:(void (^)(NSError *))errorBlock
{
    
    [LoaderView showLoader];
    LooperModel *model = [LooperUtility getLooperProfile];
    
    NSDictionary *param  = @{@"vCity" : model.vCity,
                             @"pageid" : jsonObject[@"pageid"],
                             @"vQuestion" : jsonObject[@"vQuestion"]
                            };
    
    [networkHandler POST:communityList parameters:param success:^(id responseObject)
     {
         [LoaderView hideLoader];
         
             successBlock(responseObject);
         
         
     } failure:^(NSError *error)
     {
         [LoaderView hideLoader];
         errorBlock(error);
     }];
    
}

-(void)processAddCommentToCommunityWithID:(NSString *)communityID
                               strComment:(NSString *)strComment
                     SuccessBlock:(void (^)(NSDictionary *))successBlock
                       errorBlock:(void (^)(NSError *))errorBlock
{
    
    [LoaderView showLoader];
    
    NSDictionary *param  = @{@"iCommunityID" : @([communityID intValue]),
                             @"tComments" : strComment
                             };
    
    [networkHandler POST:communityAddComment parameters:param success:^(id responseObject)
     {
         [LoaderView hideLoader];
         if ([self isStatusSuccess:responseObject])
         {
             successBlock(responseObject[data]);
         }
         
     } failure:^(NSError *error)
     {
         [LoaderView hideLoader];
         errorBlock(error);
     }];
    
}

-(void)processCommentListWithCommunityID:(NSString *)communityID
                                  pageID:(int)pageid
                             SuccessBlock:(void (^)(NSDictionary *))successBlock
                               errorBlock:(void (^)(NSError *))errorBlock
{
    
    [LoaderView showLoader];
    
    NSDictionary *param  = @{@"iCommunityID" : @([communityID intValue]),
                             @"pageid" : @(pageid)
                             };
    
    [networkHandler POST:commentList parameters:param success:^(id responseObject)
     {
         [LoaderView hideLoader];
         if ([self isStatusSuccess:responseObject])
         {
             successBlock(responseObject[data]);
         }
         
     } failure:^(NSError *error)
     {
         [LoaderView hideLoader];
         errorBlock(error);
     }];
    
}


-(void)processTravellerDetailWithTripID:(NSString *)tripID
                           iTravellerID:(NSString *)travelerID
                        dTravellingDate:(NSString *)travelingDate
                           dArrivalDate:(NSString *)dArrivalDate
                         dDepartureDate:(NSString *)dDepartureDate
                            SuccessBlock:(void (^)(NSDictionary *))successBlock
                              errorBlock:(void (^)(NSError *))errorBlock
{
    
    [LoaderView showLoader];
    
    NSDictionary *param  = @{@"dDepartureDate" : dDepartureDate,
                             @"dArrivalDate" : dArrivalDate,
                             @"dDepartureDate" : dDepartureDate,
                             @"iTravellerID" : travelerID,
                             @"dTravellingDate" : travelingDate,
                             @"iTripID" : tripID
                             };
    
    [networkHandler POST:travellerDetail parameters:param success:^(id responseObject)
     {
         [LoaderView hideLoader];
         if ([self isStatusSuccess:responseObject])
         {
             successBlock(responseObject[data]);
         }
         
     } failure:^(NSError *error)
     {
         [LoaderView hideLoader];
         errorBlock(error);
     }];
    
}

-(void)processDeleteTrips:(NSString *)tripIDs
                            SuccessBlock:(void (^)(NSDictionary *))successBlock
                              errorBlock:(void (^)(NSError *))errorBlock
{
    
    [LoaderView showLoader];
    
    NSDictionary *param  = @{@"iTravellerTripID" : tripIDs
                             };
    
    [networkHandler POST:deleteTripDetail parameters:param success:^(id responseObject)
     {
         [LoaderView hideLoader];
         if ([self isStatusSuccess:responseObject])
         {
             successBlock(responseObject[data]);
         }
         
     } failure:^(NSError *error)
     {
         [LoaderView hideLoader];
         errorBlock(error);
     }];
    
}


-(void)processGetNotificationList:(NSString *)pageID
             SuccessBlock:(void (^)(NSDictionary *))successBlock
               errorBlock:(void (^)(NSError *))errorBlock
{
    
    [LoaderView showLoader];
    
    NSDictionary *param  = @{@"pageid" : pageID
                             };
    
    [networkHandler POST:notificationList parameters:param success:^(id responseObject)
     {
         [LoaderView hideLoader];
         
        successBlock(responseObject);
         
         
     } failure:^(NSError *error)
     {
         [LoaderView hideLoader];
         errorBlock(error);
     }];
    
}

-(void)processSendMessagePush:(NSString *)isLooper
                      emailID:(NSString *)emailID
                      message:(NSString *)message
                     SuccessBlock:(void (^)(NSDictionary *))successBlock
                       errorBlock:(void (^)(NSError *))errorBlock
{
    
    
    NSDictionary *param  = @{
                             @"eIsLooper" : isLooper,
                             @"vMessage" : message,
                             @"iReceiverID" : emailID
                             };
    
    [networkHandler POST:messagePush parameters:param success:^(id responseObject)
     {
         [LoaderView hideLoader];
         
         
     } failure:^(NSError *error)
     {
         [LoaderView hideLoader];
         
     }];
    
}



-(void)processSaveAccountInfo:(NSDictionary *)param
                    imageDict:(NSDictionary *)imgDict
                 SuccessBlock:(void (^)(NSDictionary *))successBlock
                   errorBlock:(void (^)(NSError *))errorBlock
{
    
        [LoaderView showLoader];
    
    [networkHandler POST:savepayment parameters:param imageDictionary:imgDict success:^(id responseObject)
    {
         [LoaderView hideLoader];
        successBlock(responseObject);
        
    } failure:^(NSError *error)
    {
         [LoaderView hideLoader];
         errorBlock(error);
    }];
}


-(void)processGetAccountInfoSuccessBlock:(void (^)(NSDictionary *))successBlock
                   errorBlock:(void (^)(NSError *))errorBlock
{
    
    [LoaderView showLoader];
    
    [networkHandler POST:getAccountInfo parameters:nil success:^(id responseObject) {
        [LoaderView hideLoader];
        successBlock(responseObject[data]);
        
    } failure:^(NSError *error)
    {
        [LoaderView hideLoader];
        errorBlock(error);
    }];
    
}


-(void)processUpdateAccountInfoParam:(NSDictionary *)param
                         SuccessBlock:(void (^)(NSDictionary *))successBlock
                              errorBlock:(void (^)(NSError *))errorBlock
{
    
    [LoaderView showLoader];
    
    [networkHandler POST:updateAccountInfo parameters:param success:^(id responseObject) {
        [LoaderView hideLoader];
        successBlock(responseObject);
        
    } failure:^(NSError *error)
     {
         [LoaderView hideLoader];
         errorBlock(error);
     }];
    
}

-(void)processUpdateAvailability:(NSDictionary *)param
                        SuccessBlock:(void (^)(NSDictionary *))successBlock
                          errorBlock:(void (^)(NSError *))errorBlock
{
    
    [LoaderView showLoader];
    
    [networkHandler POST:updateAvailability parameters:param success:^(id responseObject) {
        [LoaderView hideLoader];
        successBlock(responseObject);
        
    } failure:^(NSError *error)
     {
         [LoaderView hideLoader];
         errorBlock(error);
     }];
    
}

@end
