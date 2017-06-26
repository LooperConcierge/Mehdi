//
//  CustomButton.m
//  Looper
//
//  Created by hardik on 2/23/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "CustomButton.h"
#import "UIFont+CustomFont.h"

@implementation CustomButton


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code

    self.titleLabel.font = [UIFont fontAvenirWithSize:15];
    self.backGroundColor = _backGroundColor;
}


@end
