//
//  AppManager.h
//  Looper
//
//  Created by Meera Dave on 06/04/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppManager : NSObject

+ (AppManager *)sharedInstance;
-(NSString *)convertStringIntoDateString:(NSString *)newDateString;
@end
