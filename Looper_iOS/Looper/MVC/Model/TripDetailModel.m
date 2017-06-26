//
//  TripDetailModel.m
//  Looper
//
//  Created by hardik on 2/17/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "TripDetailModel.h"

@implementation TripDetailModel
@synthesize intRating;
@synthesize strDescription, strTitle,session,isRequestToChange;

- (id)init {
    TripDetailModel *shareObj = [super init];
    return shareObj;
}


@end
