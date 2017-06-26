//
//  UIImageView+ExtraFuction.m
//  Looper
//
//  Created by Meera Dave on 03/02/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "UIImageView+ExtraFuction.h"

@implementation UIImageView (ExtraFuction)

-(UIImageView *)convertToBlurImage{
    CIFilter *gaussianBlurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [gaussianBlurFilter setDefaults];
    CIImage *inputImage = [CIImage imageWithCGImage:[self.image CGImage]];
    [gaussianBlurFilter setValue:inputImage forKey:kCIInputImageKey];
    [gaussianBlurFilter setValue:@2 forKey:kCIInputRadiusKey];
    CIImage *outputImage = [gaussianBlurFilter outputImage];
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[inputImage extent]]; // note, use input image extent if you want it the same size, the output image extent is larger
    self.image=[UIImage imageWithCGImage:cgimg];
    [self setAlpha:0.8f];
    return self;
}

-(UIImageView *)setCornerRadius{
    self.layer.cornerRadius=self.bounds.size.width/2;
    self.layer.masksToBounds=YES;
    return self;
}
-(UIImageView *)setCornerRadiusWithBorder:(NSInteger)borderSize color:(UIColor *)borderColor {
    [self setBorder:borderSize color:borderColor];
    [self setCornerRadius];
    return self;
}
-(UIImageView *)setBorder:(NSInteger)borderSize color:(UIColor *)borderColor {
    self.layer.borderColor=borderColor.CGColor;
    self.layer.borderWidth=borderSize;
    return self;
}


@end
