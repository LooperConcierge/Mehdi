//
//  GPSLocationListner.h
//  iMall
//
//  Created by Mac HDD on 9/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import <Foundation/Foundation.h>

typedef enum {
	GPS_WAITINING = 0,
	GPS_ACCESS_DENIED,
	GPS_TIMEOUT,
	GPS_AVAILABLE
} GPSState;

@interface GPSLocationListner : NSObject<CLLocationManagerDelegate> {
	CLLocationManager *locationManager;
	
	float latitude;
	float longitude;
	
	BOOL isGPSAcessDenied;	
	GPSState currentGPSState;

}

@property(assign)float latitude;
@property(assign)float longitude;
@property(assign)BOOL isGPSAcessDenied;	
@property(assign)GPSState currentGPSState;

-(id)init;
-(void)changeLocationUpdationStatus:(BOOL)value;

@end

@protocol GPSLocationDelegate
@required
-(void)newLocationUpdate:(NSString *)text;
-(void)newError:(NSString *)text;
@end
