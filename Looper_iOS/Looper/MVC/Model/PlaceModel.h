//
//  PlaceModel.h
//  Looper
//
//  Created by hardik on 4/20/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlaceModel : NSObject

extern const NSString *keyPlaceName;
extern const NSString *keyPlaceAddress;
extern const NSString *keyPlaceSubAddress;
extern const NSString *keyPlaceCategory;
extern const NSString *keyIntRating;
extern const NSString *keyCountryCode;
extern const NSString *keyStateCode;
extern const NSString *keyYelpBusinessID;

@property (nonatomic, assign) float intRating;
@property (nonatomic, strong) NSString *placeName;
@property (nonatomic, strong) NSString *placeSubAddress;
@property (nonatomic, strong) NSString *placeAddress;
@property (nonatomic, strong) NSString *placeCategory;
@property (nonatomic, strong) NSString *placeCountryCode;
@property (nonatomic, strong) NSString *placeStateCode;
@property (nonatomic, strong) NSString *placeBusinessID;

-(id)initWithDictionary:(NSDictionary *)dictionary;

@end
