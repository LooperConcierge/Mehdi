//
//  ShareDataDetails.h
//  Trip_Edit
//
//  Created by open  on 26/01/16.
//  Copyright © 2016 Openxcell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>

@interface ShareDataDetails : JSONModel


@property (nonatomic, assign) NSString * iTravellerTripID;

@property (nonatomic, assign) NSString * iTripID;
@property (nonatomic, assign) NSString * iTravellerID;
@property (nonatomic, assign) NSString * iLooperID;
@property (nonatomic, assign) NSString * dTravellingDate;
@property (nonatomic, assign) NSString * iScheduleZone;
@property (nonatomic, assign) NSString * iExpertiseID;
@property (nonatomic, assign) NSString * vPlaceName;
@property (nonatomic, assign) NSString * vPlaceAddress;
@property (nonatomic, assign) NSString * vPlaceState;
@property (nonatomic, assign) NSString * vPlaceCountry;
@property (nonatomic, assign) NSString * iRating;
@property (nonatomic, assign) NSString * tDescription;
@property (nonatomic, assign) NSString * vTripStatus;
@property (nonatomic, assign) NSString * eStatus;
@property (nonatomic, assign) NSString * dCreateDate;
@property (nonatomic, assign) NSString * dUpdateDate;
@property (nonatomic, assign) NSString<Optional> * isEdit;
@property (nonatomic, assign) NSString<Optional> * yelpPlaceID;



@end
