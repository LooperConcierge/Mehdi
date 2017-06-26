//
//  NSString+Validations.m
//  TipQuik
//
//  Created by Bharat Nakum on 10/21/15.
//  Copyright © 2015 OpenXCell Technolabs Pvt. Ltd. All rights reserved.
//

#import "NSString+Validations.h"

#define MINIMUM_PASSWORD_LENGTH 6

@implementation NSString (Validations)

- (BOOL)isValidString {
    NSString *strToCheck = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (strToCheck.length > 0) {
        return YES;
    }
    return NO;
}

- (BOOL)isValidProfileName {
    NSString *strProfileName = @"^[A-Za-z0-9_ -]{3,15}$";
    NSPredicate *testProfileName = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",strProfileName];
    return [testProfileName evaluateWithObject:[self stringByTrimmingLeadingAndTrailingWhitespaces]];
}

- (NSString *)stringByTrimmingLeadingAndTrailingWhitespaces {
    NSString *strTrimPattern = @"(?:^\\s+)|(?:\\s+$)";
    NSRegularExpression *theExp = [NSRegularExpression regularExpressionWithPattern:strTrimPattern options:NSRegularExpressionCaseInsensitive error:nil];
    if (theExp) {
        NSRange theRange = NSMakeRange(0, self.length);
        NSString *strTrimmed = [theExp stringByReplacingMatchesInString:self options:NSMatchingReportProgress range:theRange withTemplate:@"$1"];
        return strTrimmed;
    } else {
        return self;
    }
    return self;
}

- (BOOL)isValidUserName {
    NSString *strUserName = @"^[A-Za-z0-9_-]{3,15}$";
    NSPredicate *testUsername = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",strUserName];
    return [testUsername evaluateWithObject:self];
}

- (BOOL)isValidEmailAddress {
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = (stricterFilter ? stricterFilterString : laxString);
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)isValidPassword {
    if (self.length >= MINIMUM_PASSWORD_LENGTH) {
        BOOL hasLowerCaseLetter = NO;
        BOOL hasUpperCaseLetter = NO;
        BOOL hasDigit = NO;
        BOOL hasSpecialSymbol = YES;
        
        for (int i = 0; i < self.length; i++) {
            unichar c = [self characterAtIndex:i];
            if (!hasLowerCaseLetter) {
                hasLowerCaseLetter = [[NSCharacterSet lowercaseLetterCharacterSet] characterIsMember:c];
            }
            if (!hasUpperCaseLetter) {
                hasUpperCaseLetter = [[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:c];
            }
            if (!hasDigit) {
                hasDigit = [[NSCharacterSet decimalDigitCharacterSet] characterIsMember:c];
            }
            if (!hasSpecialSymbol) {
                hasSpecialSymbol = [[NSCharacterSet symbolCharacterSet] characterIsMember:c];
            }
        }
        
        if (hasLowerCaseLetter && hasUpperCaseLetter && hasDigit && hasSpecialSymbol) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
    return NO;
}
- (BOOL)isValidAge:(NSDateFormatter*)dateformatter {
   NSDate *dateOfBirh =[dateformatter dateFromString:self];
    NSDate* now = [NSDate date];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSCalendarUnitYear
                                       fromDate:dateOfBirh
                                       toDate:now
                                       options:0];
    NSInteger age = [ageComponents year];
    if (age<18) {
        return NO;
    }
    return YES;

}
- (BOOL)isValidPhoneNumber {
    NSString *phoneRegex = @"^[0-9]{6,14}$";//@"^((\\+)|(00))[0-9]{6,14}$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)isValidRoutingNumber {
    NSString *routingRegex = @"^[0-9]{9}$";//@"^((\\+)|(00))[0-9]{6,14}$";
    NSPredicate *routingTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", routingRegex];
    return [routingTest evaluateWithObject:self];
}

+ (NSString *)setValueForString:(NSString *)strToSet {
    if ([strToSet isKindOfClass:[NSNull class]] || strToSet == nil || strToSet == NULL) {
        return @"";
    } else if ([strToSet isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%@",strToSet];
    } else {
        return strToSet;
    }
}

- (NSString *)makeStringCompatibleForUsername {
    NSString *strUsername = self;
    if (strUsername.length > 0) {
        if ([strUsername characterAtIndex:0] == '@') {
            strUsername = [strUsername substringFromIndex:1];
        }
    }
    return strUsername;
}

@end
