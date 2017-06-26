//
//  UIFont+CustomFont.h
//  Looper
//
//  Created by Meera Dave on 30/01/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import <UIKit/UIKit.h>

#define FONT_HEADER_LARGE_SIZE 20.0f
#define FONT_HEADER_SIZE 17.0f
#define FONT_MEDIUM_SIZE 16.0f
#define FONT_NORMAL_SIZE 14.0f
#define FONT_SMALL_SIZE 12.0f
#define FONT_SMALL_SIZE_10 10.0f



@interface UIFont (CustomFont)

+ (UIFont *)fontAvenirWithSize:(CGFloat)pointSize;
+ (UIFont *)fontAvenirHeavyWithSize:(CGFloat)pointSize;
+ (UIFont *)fontAvenirObliqueWithSize:(CGFloat)pointSize;
+ (UIFont *)fontAvenirBlackWithSize:(CGFloat)pointSize;
+ (UIFont *)fontAvenirBookWithSize:(CGFloat)pointSize;
+ (UIFont *)fontAvenirBlackObliqueWithSize:(CGFloat)pointSize;
+ (UIFont *)fontAvenirHeavyObliqueWithSize:(CGFloat)pointSize;
+ (UIFont *)fontAvenirLightWithSize:(CGFloat)pointSize;
+ (UIFont *)fontAvenirMediumObliqueWithSize:(CGFloat)pointSize;
+ (UIFont *)fontAvenirMediumWithSize:(CGFloat)pointSize;
+ (UIFont *)fontAvenirLightObliqueWithSize:(CGFloat)pointSize;
+ (UIFont *)fontAvenirRomanWithSize:(CGFloat)pointSize;
+ (UIFont *)fontAvenirBookObliqueWithSize:(CGFloat)pointSize;

//NExt condensed

+ (UIFont *)fontAvenirNextCondensedRegularWithSize:(CGFloat)pointSize;
+ (UIFont *)fontAvenirNextCondensedMediumItalicWithSize:(CGFloat)pointSize;

+ (UIFont *)fontAvenirNextCondensedUltraLightItalicWithSize:(CGFloat)pointSize;
+ (UIFont *)fontAvenirNextCondensedUltraLightWithSize:(CGFloat)pointSize;
+ (UIFont *)fontAvenirNextCondensedBoldItalicWithSize:(CGFloat)pointSize;
+ (UIFont *)fontAvenirNextCondensedItalicWithSize:(CGFloat)pointSize;
+ (UIFont *)fontAvenirNextCondensedMediumWithSize:(CGFloat)pointSize;

+ (UIFont *)fontAvenirNextCondensedHeavyItalicWithSize:(CGFloat)pointSize;

+ (UIFont *)fontAvenirNextCondensedHeavyWithSize:(CGFloat)pointSize;
+ (UIFont *)fontAvenirNextCondensedDemiBoldItalicWithSize:(CGFloat)pointSize;
+ (UIFont *)fontAvenirNextCondensedDemiBoldWithSize:(CGFloat)pointSize;

+ (UIFont *)fontAvenirNextCondensedBoldWithSize:(CGFloat)pointSize;
@end
