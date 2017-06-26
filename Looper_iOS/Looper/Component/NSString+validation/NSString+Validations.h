//
//  NSString+Validations.h
//  TipQuik
//
//  Created by Bharat Nakum on 10/21/15.
//  Copyright © 2015 OpenXCell Technolabs Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Validations)

- (BOOL)isValidString;
- (BOOL)isValidUserName;
- (BOOL)isValidEmailAddress;
- (BOOL)isValidPassword;
- (BOOL)isValidPhoneNumber;
- (BOOL)isValidRoutingNumber;
- (BOOL)isValidProfileName;
- (BOOL)isValidAge:(NSDateFormatter*)dateformatter;
+ (NSString *)setValueForString:(NSString *)strToSet;
- (NSString *)makeStringCompatibleForUsername;

@end
