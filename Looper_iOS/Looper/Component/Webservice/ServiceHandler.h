//
//  ServiceHandler.h
//  Chumm
//
//  Created by Bhuvan on 8/22/15.
//  Copyright (c) 2015 OpenXcell Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WebserviceHandler.h"
#import "TravelerWSHandler.h"
#import "LooperWSHandler.h"

@interface ServiceHandler : NSObject

@property(nonatomic, strong) WebserviceHandler  *webService;
@property(nonatomic, strong) TravelerWSHandler  *travelerWebService;
@property(nonatomic, strong) LooperWSHandler  *looperWebService;

+ (instancetype)sharedInstance;
- (instancetype)init;

@end
