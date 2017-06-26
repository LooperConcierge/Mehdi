//
//  TripDetailModelList.h
//  Looper
//
//  Created by hardik on 5/26/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import <JSONModel/JSONModel.h>
//#import "ExpertiseModel.h"
#import "PassionModel.h"

@interface TripDetailModelList : JSONModel

@property (assign, nonatomic) int iTripID;
@property (assign, nonatomic) int iTravellerID;
@property (assign, nonatomic) int iLooperID;
@property (strong, nonatomic) NSArray * iExpertiseIDs;
@property (assign, nonatomic) int iMember;
@property (assign, nonatomic) NSString *vCurrencyType;
@property (assign, nonatomic) float iTripCharge;
@property (assign, nonatomic) NSString * vCity;
@property (assign, nonatomic) NSString * vState;
@property (assign, nonatomic) NSString *dBookingDate;
@property (assign, nonatomic) NSString *dDepartureDate;
@property (assign, nonatomic) NSString *dArrivalDate;
@property (assign, nonatomic) NSString <Optional>*vTimeZone;
@property (assign, nonatomic) NSString *eStatus;
@property (assign, nonatomic) NSString *eTripStatus;
@property (assign, nonatomic) NSString *vFullName;
@property (assign, nonatomic) NSString *vProfilePic;
@property (strong, nonatomic) NSArray * date_list;



@end
