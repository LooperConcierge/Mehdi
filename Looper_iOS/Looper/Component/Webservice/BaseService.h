//
//  BaseService.h
//


//Development URL
//#define kBaseURL        @"http://192.168.1.96/looper/ws"
//#define kBaseURL        @"http://stylekart.net/2016/looper/ws"
#define kBaseURL        @"http://52.8.213.201/ws"


#import <Foundation/Foundation.h>
#import "NetworkHandler.h"


@class ServiceHandler;

@interface BaseService : NSObject {
    NetworkHandler *networkHandler;
    ServiceHandler *servicehandler;
}


- (instancetype)initWithServiceHandler:(ServiceHandler *)handler;
- (BOOL)isStatusSuccess:(id)responseObject;
@end
