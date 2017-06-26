//
//  TravelerWSHandler.m
//  Looper
//
//  Created by hardik on 5/4/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "TravelerWSHandler.h"
#import "LooperUtility.h"
#import "AppDelegate.h"
#import "LoaderView.h"

const NSString *profile = @"profile";

static NSString * const getLooperDetail = @"traveller/getLoopersDetail";
static NSString * const getTravelerProfile = @"user/getMyProfileTraveller";
static NSString *const editProfile = @"user/editProfileTraveller";
static NSString *const getLooperList = @"traveller/getLoopers";
static NSString *const getLooperListBySearch = @"traveller/search";
static NSString *const addTrip = @"traveller/addTrip";
static NSString *const tripHistory = @"traveller/tripHistory";
static NSString *const tripDetail = @"traveller/tripDetail";
static NSString *const payNowLooperDetail = @"looper/looperDetail";
static NSString *const requestToChange    = @"traveller/requestToChange";
static NSString *const scheduleTrip       = @"traveller/scheduleTrip";
static NSString *const payNow       = @"payment/pay";
static NSString *const travellerRating       = @"traveller/rating";
static NSString *const editImage             = @"user/editProfileImage";
static NSString *const readMessage             = @"looper/readNotification";


@implementation TravelerWSHandler

-(void)processTravelerProfileWithSuccessBlock:(void (^)(NSDictionary *))successBlock errorBlock:(void (^)(NSError *))errorBlock
{
    [LoaderView showLoader];
    [networkHandler GET:getTravelerProfile parameters:nil  success:^(id responseObject) {
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


-(void)processTravelerEditProfileWithParameters:(NSDictionary *)jsonObject
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


-(void)processGetLooperListWithParameter:(NSDictionary *)jsonObject
                            SuccessBlock:(void (^)(NSDictionary *))successBlock
                                     errorBlock:(void (^)(NSError *))errorBlock
{
    [LoaderView showLoader];
    
    [networkHandler POST:getLooperList parameters:jsonObject success:^(id responseObject) {
        [LoaderView hideLoader];
        if ([self isStatusSuccess:responseObject])
        {
            successBlock(responseObject[data]);
        }
        else
        {
            successBlock(responseObject);
        }
    } failure:^(NSError *error) {
        [LoaderView hideLoader];
        errorBlock(error);
    }];
    
}


-(void)processGetLooperListBySearchWithParameter:(NSDictionary *)jsonObject
                                successBlock:(void (^)(NSDictionary *))successBlock
                                 errorBlock:(void (^)(NSError *))errorBlock
{
    [LoaderView showLoader];
    
    [networkHandler POST:getLooperListBySearch parameters:jsonObject success:^(id responseObject) {
        [LoaderView hideLoader];
        if ([self isStatusSuccess:responseObject])
        {
            successBlock(responseObject[data]);
        }
        else
        {
            successBlock(responseObject);
        }
    } failure:^(NSError *error) {
        [LoaderView hideLoader];
        errorBlock(error);
    }];
    
}

-(void)processAddTripWithParameter:(NSDictionary *)jsonObject
                                    successBlock:(void (^)(NSDictionary *))successBlock
                                      errorBlock:(void (^)(NSError *))errorBlock
{
    [LoaderView showLoader];
    
    [networkHandler POST:addTrip parameters:jsonObject success:^(id responseObject) {
        
        [LoaderView hideLoader];
        successBlock(responseObject);
    
    } failure:^(NSError *error) {
        [LoaderView hideLoader];
        errorBlock(error);
    }];
    
}

-(void)processTripHistoryWithSuccessBlock:(void (^)(NSDictionary *))successBlock
                        errorBlock:(void (^)(NSError *))errorBlock
{
    [LoaderView showLoader];
    
    [networkHandler POST:tripHistory parameters:nil success:^(id responseObject) {
        
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

-(void)processTripDetailWithParameter:(NSDictionary *)jsonObject
                      successBlock:(void (^)(NSDictionary *))successBlock
                        errorBlock:(void (^)(NSError *))errorBlock
{
    [LoaderView showLoader];
    
    [networkHandler POST:tripDetail parameters:jsonObject success:^(id responseObject) {
        
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

-(void)processPayNowTripDetailWithParameter:(NSString *)looperID
                                     tripID:(NSString *)tripID
                         successBlock:(void (^)(NSDictionary *))successBlock
                           errorBlock:(void (^)(NSError *))errorBlock
{
    [LoaderView showLoader];
    NSDictionary *param = @{@"iTripID" : tripID ,
                            @"iLooperID" : looperID
                            };
    [networkHandler POST:payNowLooperDetail parameters:param success:^(id responseObject)
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

-(void)processRequestToChangeWithTripID:(NSString *)iTravellerTripID
                               successBlock:(void (^)(NSDictionary *))successBlock
                                 errorBlock:(void (^)(NSError *))errorBlock
{
    [LoaderView showLoader];
    NSDictionary *param = @{@"iTravellerTripID" : iTravellerTripID ,
                            };
    
    [networkHandler POST:requestToChange parameters:param success:^(id responseObject)
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

-(void)processScheduleTripSuccessBlock:(void (^)(NSDictionary *))successBlock
                             errorBlock:(void (^)(NSError *))errorBlock
{
    [LoaderView showLoader];
    
    [networkHandler POST:scheduleTrip parameters:nil success:^(id responseObject)
     {
         
         [LoaderView hideLoader];
         if ([self isStatusSuccess:responseObject])
         {
             successBlock(responseObject);
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


-(void)processPaymentTripWithParam:(NSDictionary *)param SuccessBlock:(void (^)(NSDictionary *))successBlock
                            errorBlock:(void (^)(NSError *))errorBlock
{
    [LoaderView showLoader];
    
    [networkHandler POST:payNow parameters:param success:^(id responseObject)
     {
         
         [LoaderView hideLoader];
         if ([self isStatusSuccess:responseObject])
         {
             successBlock(responseObject);
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


-(void)processRateLooper:(NSDictionary *)param SuccessBlock:(void (^)(NSDictionary *))successBlock
                        errorBlock:(void (^)(NSError *))errorBlock
{
    [LoaderView showLoader];
    
    [networkHandler POST:travellerRating parameters:param success:^(id responseObject)
     {
         
         [LoaderView hideLoader];
         successBlock(responseObject);
         
     } failure:^(NSError *error)
     {
         [LoaderView hideLoader];
         errorBlock(error);
     }];
    
}

-(void)processEditImage:(NSDictionary *)param SuccessBlock:(void (^)(NSDictionary *))successBlock
              errorBlock:(void (^)(NSError *))errorBlock
{
    [LoaderView showLoader];

    [networkHandler POST:editImage parameters:nil imageDictionary:param success:^(id responseObject) {
        
        [LoaderView hideLoader];
        if ([self isStatusSuccess:responseObject])
        {
            successBlock(responseObject);
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

-(void)processGetLooperDetailWithID:(NSString *)iLooperID SuccessBlock:(void (^)(NSDictionary *))successBlock errorBlock:(void (^)(NSError *))errorBlock
{
    [LoaderView showLoader];
    
    [networkHandler POST:getLooperDetail parameters:@{@"iLooperID" : iLooperID} success:^(id responseObject)
     {
         
         [LoaderView hideLoader];
         if ([self isStatusSuccess:responseObject])
         {
             successBlock(responseObject);
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

-(void)processNotificationRead:(NSString *)notificationID SuccessBlock:(void (^)(NSDictionary *))successBlock errorBlock:(void (^)(NSError *))errorBlock
{
    [LoaderView showLoader];
    
    [networkHandler POST:readMessage parameters:@{@"iNotificationID" : notificationID} success:^(id responseObject)
     {
         
         [LoaderView hideLoader];
         if ([self isStatusSuccess:responseObject])
         {
             successBlock(responseObject);
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



@end
