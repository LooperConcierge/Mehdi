//
//  TripDetailModel.h
//  Looper
//
//  Created by hardik on 2/17/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TripDetailModel : NSObject

typedef enum DaySession
{
    SESSION_MORNING,
    SESSION_AFTERNOON,
    SESSION_EVENING
}DaySession;

@property DaySession session;

@property (nonatomic, assign) int intRating;

@property (nonatomic, strong) NSString *strTitle;
@property (nonatomic, strong) NSString *strDescription;
@property (nonatomic, assign) BOOL isRequestToChange;

@end
