//
//  ServiceHandler.m
//  Chumm
//
//  Created by Bhuvan on 8/22/15.
//  Copyright (c) 2015 OpenXcell Studio. All rights reserved.
//

#import "ServiceHandler.h"

@implementation ServiceHandler


+ (instancetype)sharedInstance {
    
    // structure used to test whether the block has completed or not
    static dispatch_once_t p = 0;
    
    // initialize sharedObject as nil (first call only)
    __strong static id _sharedObject = nil;
    
    // executes a block object once and only once for the lifetime of an application
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    
    // returns the same object each time
    return _sharedObject;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.webService   = [[WebserviceHandler alloc] initWithServiceHandler:self];
        self.travelerWebService   = [[TravelerWSHandler alloc] initWithServiceHandler:self];
        self.looperWebService   = [[LooperWSHandler alloc] initWithServiceHandler:self];
    }
    return self;
}
@end
