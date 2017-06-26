//
//  TextFieldUtility.m
//  Looper
//
//  Created by hardik on 2/1/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "TextFieldUtility.h"
#import "UIFont+CustomFont.h"
#import "LooperUtility.h"


@implementation TextFieldUtility

-(void)drawRect:(CGRect)rect
{
//    CGRect myFrame = self.bounds;
    
    //set border width and color
//    CALayer *border = [CALayer layer];
//    CGFloat borderWidth = _borderWidth;
//    border.borderColor = _borderColor.CGColor;
//    border.frame = CGRectMake(0, self.frame.size.height - borderWidth, self.frame.size.width, self.frame.size.height);
//    border.borderWidth = borderWidth;
//    
//    [self.layer addSublayer:border];
//    self.layer.masksToBounds = YES;
//    
//    self.clipsToBounds = YES;
//
//    //Placeholder
//    if (_placeHolderColor != nil)
//    {
//        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName: _placeHolderColor}];
//    }
    [self render];
}
/*
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self render];
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    [self render];
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
 
    [self render];
}
 */
//
-(void)render
{
    //    CGRect myFrame = self.bounds;
//    [self layoutIfNeeded];
//    [self setNeedsDisplay];
//        //set border width and color
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = _borderWidth;
    border.borderColor = _borderColor.CGColor;
    border.frame = CGRectMake(0, self.frame.size.height - borderWidth, self.frame.size.width, self.frame.size.height);
    border.borderWidth = borderWidth;

    [self.layer addSublayer:border];
    self.layer.masksToBounds = YES;
    
    self.clipsToBounds = YES;
    if (_textStringColor == nil)
    {
        self.textColor = [UIColor whiteColor];
    }
    else
    {
        self.textColor = _textStringColor;
    }
    
//    self.keepBaseline = YES;
//    self.floatingLabelTextColor = [UIColor redColor];
        //Placeholder
    if (_placeHolderColor != nil && self.placeholder != nil)
    {
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName: _placeHolderColor,NSFontAttributeName : [UIFont fontAvenirNextCondensedMediumWithSize:FONT_MEDIUM_SIZE]}];
    }
//    self.floatingLabelFont = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_SMALL_SIZE];
    self.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_MEDIUM_SIZE];
}
/*
-(void)prepareForInterfaceBuilder
{
    [super prepareForInterfaceBuilder];
    
    [self render];
}
 */
@end


@implementation RoundedView

-(void)drawRect:(CGRect)rect
{
    self.layer.cornerRadius = _cornerRadius;
    self.layer.borderColor = _color.CGColor;
    self.layer.masksToBounds = YES;
    self.clipsToBounds = YES;
}

@end


@implementation RoundedButton

-(void)drawRect:(CGRect)rect
{
    self.layer.borderWidth = _lineWidth;
    self.layer.borderColor = _color.CGColor;
    self.layer.cornerRadius = _cornerRadius;
    self.layer.masksToBounds = TRUE;
//    self.clipsToBounds = TRUE;
}

@end

//@implementation ImageHelper
//
//-(UIImage *)circleMaskImage
//{
//    CGSize square = CGSizeMake(MIN(self.size.width, self.size.height), MIN(self.size.width, self.size.height));
//    CGRect rect = CGRectMake(0, 0, square.height, square.height);
//
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
//    imageView.image = self;
//    imageView.layer.cornerRadius = square.width/2;
//    imageView.layer.masksToBounds = YES;
//    imageView.contentMode = UIViewContentModeScaleAspectFill;
//    
//    UIGraphicsBeginImageContext(imageView.bounds.size);
//    [imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *circleImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    return circleImage;
//    
//    
//}
//
//@end


@interface UIPlaceHolderTextView ()

@property (nonatomic, retain) UILabel *placeHolderLabel;

@end

@implementation UIPlaceHolderTextView

CGFloat const UI_PLACEHOLDER_TEXT_CHANGED_ANIMATION_DURATION = 0.25;

- (void)dealloc
{
  
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Use Interface Builder User Defined Runtime Attributes to set
    // placeholder and placeholderColor in Interface Builder.
}

- (id)initWithFrame:(CGRect)frame
{
    if( (self = [super initWithFrame:frame]) )
    {
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if (_borderColor != nil)
    {
        self.layer.borderColor = _borderColor.CGColor;
        self.layer.borderWidth = _borderWidth;
        self.layer.cornerRadius = _cornerRadius;
        self.layer.masksToBounds = YES;
    }
    self.floatingLabelFont = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_SMALL_SIZE];
    self.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_MEDIUM_SIZE];
    self.floatingLabel.hidden = TRUE;
    [super drawRect:rect];
}

@end

@implementation lableUtility


-(void)drawRect:(CGRect)rect
{
    self.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_HEADER_SIZE];
    [super drawRect:rect];
}

@end

