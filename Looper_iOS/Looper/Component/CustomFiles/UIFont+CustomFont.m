//
//  UIFont+CustomFont.m
//  Looper
//
//  Created by Meera Dave on 30/01/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "UIFont+CustomFont.h"

@implementation UIFont (CustomFont)

/* Avenir Font */
+ (UIFont *)fontAvenirWithSize:(CGFloat)pointSize {
    return [UIFont fontWithName:@"Avenir" size:[self pointSizeRelatedToDevice:pointSize]];
}
+ (UIFont *)fontAvenirHeavyWithSize:(CGFloat)pointSize {
    return [UIFont fontWithName:@"Avenir-Heavy" size:[self pointSizeRelatedToDevice:pointSize]];
}
+ (UIFont *)fontAvenirObliqueWithSize:(CGFloat)pointSize {
    return [UIFont fontWithName:@"Avenir-Oblique" size:[self pointSizeRelatedToDevice:pointSize]];
}
+ (UIFont *)fontAvenirBlackWithSize:(CGFloat)pointSize {
    return [UIFont fontWithName:@"Avenir-Black" size:[self pointSizeRelatedToDevice:pointSize]];
}
+ (UIFont *)fontAvenirBookWithSize:(CGFloat)pointSize {
    return [UIFont fontWithName:@"Avenir-Book" size:[self pointSizeRelatedToDevice:pointSize]];
}
+ (UIFont *)fontAvenirBlackObliqueWithSize:(CGFloat)pointSize {
    return [UIFont fontWithName:@"Avenir-BlackOblique" size:[self pointSizeRelatedToDevice:pointSize]];
}
+ (UIFont *)fontAvenirHeavyObliqueWithSize:(CGFloat)pointSize {
    return [UIFont fontWithName:@"Avenir-HeavyOblique" size:[self pointSizeRelatedToDevice:pointSize]];
}
+ (UIFont *)fontAvenirLightWithSize:(CGFloat)pointSize {
    return [UIFont fontWithName:@"Avenir-Light" size:[self pointSizeRelatedToDevice:pointSize]];
}
+ (UIFont *)fontAvenirMediumObliqueWithSize:(CGFloat)pointSize {
    return [UIFont fontWithName:@"Avenir-MediumOblique" size:[self pointSizeRelatedToDevice:pointSize]];
}
+ (UIFont *)fontAvenirMediumWithSize:(CGFloat)pointSize {
    return [UIFont fontWithName:@"Avenir-Medium" size:[self pointSizeRelatedToDevice:pointSize]];
}
+ (UIFont *)fontAvenirLightObliqueWithSize:(CGFloat)pointSize {
    return [UIFont fontWithName:@"Avenir-LightOblique" size:[self pointSizeRelatedToDevice:pointSize]];
}
+ (UIFont *)fontAvenirRomanWithSize:(CGFloat)pointSize {
    return [UIFont fontWithName:@"Avenir-Roman" size:[self pointSizeRelatedToDevice:pointSize]];
}
+ (UIFont *)fontAvenirBookObliqueWithSize:(CGFloat)pointSize {
    return [UIFont fontWithName:@"Avenir-BookOblique" size:[self pointSizeRelatedToDevice:pointSize]];
}

//Avenir condensed

+ (UIFont *)fontAvenirNextCondensedRegularWithSize:(CGFloat)pointSize {
    return [UIFont fontWithName:@"AvenirNextCondensed-Regular" size:[self pointSizeRelatedToDevice:pointSize]];
}

+ (UIFont *)fontAvenirNextCondensedMediumItalicWithSize:(CGFloat)pointSize {
    return [UIFont fontWithName:@"AvenirNextCondensed-MediumItalic" size:[self pointSizeRelatedToDevice:pointSize]];
}

+ (UIFont *)fontAvenirNextCondensedUltraLightItalicWithSize:(CGFloat)pointSize {
    return [UIFont fontWithName:@"AvenirNextCondensed-UltraLightItalic" size:[self pointSizeRelatedToDevice:pointSize]];
}

+ (UIFont *)fontAvenirNextCondensedUltraLightWithSize:(CGFloat)pointSize {
    return [UIFont fontWithName:@"AvenirNextCondensed-UltraLight" size:[self pointSizeRelatedToDevice:pointSize]];
}

+ (UIFont *)fontAvenirNextCondensedBoldItalicWithSize:(CGFloat)pointSize {
    return [UIFont fontWithName:@"AvenirNextCondensed-BoldItalic" size:[self pointSizeRelatedToDevice:pointSize]];
}

+ (UIFont *)fontAvenirNextCondensedItalicWithSize:(CGFloat)pointSize {
    return [UIFont fontWithName:@"AvenirNextCondensed-Italic" size:[self pointSizeRelatedToDevice:pointSize]];
}

+ (UIFont *)fontAvenirNextCondensedMediumWithSize:(CGFloat)pointSize {
    return [UIFont fontWithName:@"AvenirNextCondensed-Medium" size:[self pointSizeRelatedToDevice:pointSize]];
}

+ (UIFont *)fontAvenirNextCondensedHeavyItalicWithSize:(CGFloat)pointSize {
    return [UIFont fontWithName:@"AvenirNextCondensed-HeavyItalic" size:[self pointSizeRelatedToDevice:pointSize]];
}

+ (UIFont *)fontAvenirNextCondensedHeavyWithSize:(CGFloat)pointSize {
    return [UIFont fontWithName:@"AvenirNextCondensed-Heavy" size:[self pointSizeRelatedToDevice:pointSize]];
}

+ (UIFont *)fontAvenirNextCondensedDemiBoldItalicWithSize:(CGFloat)pointSize {
    return [UIFont fontWithName:@"AvenirNextCondensed-DemiBoldItalic" size:[self pointSizeRelatedToDevice:pointSize]];
}

+ (UIFont *)fontAvenirNextCondensedDemiBoldWithSize:(CGFloat)pointSize {
    return [UIFont fontWithName:@"AvenirNextCondensed-DemiBold" size:[self pointSizeRelatedToDevice:pointSize]];
}

+ (UIFont *)fontAvenirNextCondensedBoldWithSize:(CGFloat)pointSize {
    return [UIFont fontWithName:@"AvenirNextCondensed-Bold" size:[self pointSizeRelatedToDevice:pointSize]];
}

+ (CGFloat) pointSizeRelatedToDevice:(CGFloat)pointSize {
    if ([UIScreen mainScreen].bounds.size.width == 375) {
        return (pointSize + 1.0f);
    } else if ([UIScreen mainScreen].bounds.size.width == 414) {
        return (pointSize + 2.0f);
    } else {
        return pointSize;
    }
}

@end
