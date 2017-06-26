//
//  TextFieldUtility.h
//  Looper
//
//  Created by hardik on 2/1/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JVFloatLabeledTextField.h"
#import "JVFloatLabeledTextView.h"

IB_DESIGNABLE

@interface TextFieldUtility : UITextField

@property (nonatomic) IBInspectable UIColor *placeHolderColor;
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable UIColor *textStringColor;

@end


IB_DESIGNABLE
@interface RoundedView : UIView

@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic) IBInspectable UIColor *color;

@end

IB_DESIGNABLE
@interface RoundedButton : UIButton

@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic) IBInspectable UIColor *color;
@property (nonatomic) IBInspectable CGFloat lineWidth;

@end

IB_DESIGNABLE
@interface UIPlaceHolderTextView : JVFloatLabeledTextView

//@property (nonatomic, retain) IBInspectable NSString *placeholder;
@property (nonatomic, retain) IBInspectable UIColor *placeholderColor;
@property (nonatomic) IBInspectable NSInteger cornerRadius;
@property (nonatomic) IBInspectable float borderWidth;
@property (nonatomic, retain) IBInspectable UIColor *borderColor;
//@property (nonatomic) IBInspectable NSInteger placeHolderTextAlignment;//0 left // 1 center


@end

IB_DESIGNABLE
@interface lableUtility : UILabel

@end
