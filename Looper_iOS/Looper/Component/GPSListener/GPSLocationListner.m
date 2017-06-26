//
//  GPSLocationListner.m
//  iMall
//
//  Created by Mac HDD on 9/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GPSLocationListner.h"

@implementation GPSLocationListner

@synthesize latitude;
@synthesize longitude;
@synthesize currentGPSState;
@synthesize isGPSAcessDenied;


- (id) init {
    self = [super init];
    if (self != nil) {
        locationManager = [[CLLocationManager alloc] init];
        [locationManager setDelegate:self];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        //        [self changeLocationUpdationStatus:TRUE];
    }
    return self;
}

-(void)changeLocationUpdationStatus:(BOOL)value {
    if(value) {
        latitude = 255.0;
        longitude = 255.0;
        
        //        [locationManager requestAlwaysAuthorization];
        [locationManager requestWhenInUseAuthorization];
        [locationManager startUpdatingLocation];
        
    } else {
        [locationManager stopUpdatingLocation];
    }
}

// Called when the location is updated
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    
    currentGPSState = GPS_AVAILABLE;
    latitude = newLocation.coordinate.latitude;
    longitude = newLocation.coordinate.longitude;
}

// Called when there is an error getting the location
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    NSMutableString *errorString = [[NSMutableString alloc] init];
    
    if ([error domain] == kCLErrorDomain) {
        
        // We handle CoreLocation-related errors here
        
        switch ([error code]) {
                // This error code is usually returned whenever user taps "Don't Allow" in response to
                // being told your app wants to access the current location. Once this happens, you cannot
                // attempt to get the location again until the app has quit and relaunched.
                //
                // "Don't Allow" on two successive app launches is the same as saying "never allow". The user
                // can reset this for all apps by going to Settings > General > Reset > Reset Location Warnings.
                //
            case kCLErrorDenied:
                [locationManager stopUpdatingLocation];
                locationManager.delegate = nil;
                [errorString appendFormat:@"%@\n", NSLocalizedString(@"LocationDenied", nil)];
                isGPSAcessDenied = YES;
                currentGPSState = GPS_ACCESS_DENIED;
                latitude = 255;
                longitude = 255;
                break;
                
                // This error code is usually returned whenever the device has no data or WiFi connectivity,
                // or when the location cannot be determined for some other reason.
                //
                // CoreLocation will keep trying, so you can keep waiting, or prompt the user.
                //
            case kCLErrorLocationUnknown:
                currentGPSState = GPS_TIMEOUT;
                [errorString appendFormat:@"%@\n", NSLocalizedString(@"LocationUnknown", nil)];
                break;
                
                // We shouldn't ever get an unknown error code, but just in case...
                //
            default:
                [errorString appendFormat:@"%@ %d\n", NSLocalizedString(@"GenericLocationError", nil), [error code]];
                break;
        }
    } else {
        // We handle all non-CoreLocation errors here
        // (we depend on localizedDescription for localization)
        [errorString appendFormat:@"Error domain: \"%@\"  Error code: %d\n", [error domain], [error code]];
        [errorString appendFormat:@"Description: \"%@\"\n", [error localizedDescription]];
    }
}

- (void)dealloc {
    [locationManager setDelegate:nil];
    [locationManager stopUpdatingLocation];
}

@end