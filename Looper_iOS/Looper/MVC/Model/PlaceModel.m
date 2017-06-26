//
//  PlaceModel.m
//  Looper
//
//  Created by hardik on 4/20/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "PlaceModel.h"

@implementation PlaceModel
@synthesize intRating,placeName,placeAddress,placeCategory,placeSubAddress;

const NSString *keyPlaceName = @"name";
const NSString *keyPlaceAddress = @"display_address";
const NSString *keyPlaceSubAddress = @"cross_streets";
const NSString *keyPlaceCategory; 
const NSString *keyIntRating = @"rating";
const NSString *keyCountryCode = @"country";
const NSString *keyStateCode = @"state";
const NSString *keyYelpBusinessID = @"id";

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    PlaceModel *sharedObj = [super init];
    sharedObj.placeName = dictionary[keyPlaceName];
    NSArray *address = dictionary[@"location"][keyPlaceAddress];
    sharedObj.placeAddress = [address componentsJoinedByString:@","];
    sharedObj.placeSubAddress = dictionary[@"location"][keyPlaceSubAddress];
    sharedObj.intRating = [dictionary[keyIntRating] floatValue];
    sharedObj.placeCountryCode = dictionary[@"location"][keyCountryCode];
    sharedObj.placeStateCode = dictionary[@"location"][keyStateCode];
    sharedObj.placeBusinessID = dictionary[keyYelpBusinessID];
    
    return sharedObj;
}

@end
