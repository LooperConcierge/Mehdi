//
//  TripCalendarModel.m
//  Looper
//
//  Created by hardik on 2/17/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "TripCalendarModel.h"

@implementation TripCalendarModel
@synthesize strHeaderTitle;
@synthesize arrData;

-(id)init {
    TripCalendarModel *shareObj = [super init];
    
    arrData = [[NSMutableArray alloc] init];
    
    return shareObj;
}

@end
