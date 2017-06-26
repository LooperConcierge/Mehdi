//
//  UIImageView+ExtraFuction.h
//  Looper
//
//  Created by Meera Dave on 03/02/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface UIImageView (ExtraFuction)

-(UIImageView *)convertToBlurImage;
-(UIImageView *)setCornerRadius;
-(UIImageView *)setCornerRadiusWithBorder:(NSInteger)borderSize color:(UIColor *)borderColor;
-(UIImageView *)setBorder:(NSInteger)borderSize color:(UIColor *)borderColor;

@end
