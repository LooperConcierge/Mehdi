//
//  AppManager.m
//  Looper
//
//  Created by Meera Dave on 06/04/16.
//  Copyright © 2016 looper. All rights reserved.
//

#define APP_DATE_FORMATTE @"MMMM,dd yyyy"

#import "AppManager.h"

@implementation AppManager

+ (AppManager *)sharedInstance {
    static AppManager *appManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appManager = [[AppManager alloc] init];
    });
    return appManager;
}
-(NSString *)convertStringIntoDateString:(NSString *)newDateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString: newDateString];
    NSString *convertedString = [[self currentDateFormatter] stringFromDate:date]; //here convert date in NSString
    NSLog(@"Converted String : %@",convertedString);
    return newDateString;
}
-(NSDateFormatter *)currentDateFormatter {
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:APP_DATE_FORMATTE];
    return dateformatter;
}
@end
