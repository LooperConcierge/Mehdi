//
//  UIColor+CustomColor.m
//  Looper
//
//  Created by Meera Dave on 01/02/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "UIColor+CustomColor.h"

@implementation UIColor (CustomColor)
+ (UIColor *)darkGrayBackgroundColor {
    return [UIColor colorWithRed:22.0f/255.0f green:22.0f/255.0f blue:22.0f/255.0f alpha:1.0f];
}

+ (UIColor *)lightGrayBackgroundColor {
    return [UIColor colorWithRed:49.0f/255.0f green:49.0f/255.0f blue:49.0f/255.0f alpha:1.0f];
}

+ (UIColor *)darkShadeGrayBackgroundColor {
    return [UIColor colorWithRed:28.0f/255.0f green:28.0f/255.0f blue:28.0f/255.0f alpha:1.0f];
}

+ (UIColor *)lightRedBackgroundColor {
    return [UIColor colorWithRed:255.0f/255.0f green:85.0f/255.0f blue:95.0f/255.0f alpha:1.0f];
}


@end
