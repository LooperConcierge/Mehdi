//
//  TripRequestListModel.h
//  Looper
//
//  Created by hardik on 5/26/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface TripRequestListModel : JSONModel

@property (strong, nonatomic) id <Optional> iRequestID;
@property (assign, nonatomic) int iTripID;
@property (strong, nonatomic) id <Optional> iTravellerID;
@property (strong, nonatomic) NSString <Optional>* vFullName;
@property (strong, nonatomic) NSString <Optional>* vEmail;
@property (strong, nonatomic) id <Optional> iLooperID;
@property (assign, nonatomic) int iMember;
@property (strong, nonatomic) NSString <Optional> * vAbout;
@property (strong, nonatomic) NSString <Optional> * vProfilePic;
@property (strong, nonatomic) id <Optional>  iRate;
@property (strong, nonatomic) NSString<Optional> *vCity;
@property (strong, nonatomic) NSString *dBookingDate;
@property (strong, nonatomic) NSString *dDepartureDate;
@property (strong, nonatomic) NSString *dArrivalDate;
@property (strong, nonatomic) NSString <Optional>*eStatus;
@property (strong, nonatomic) NSString<Optional>* tripStatus;
@property (strong, nonatomic) NSString<Optional>* isEdit;
@property (strong, nonatomic) NSString<Optional>* iRating;


@end
