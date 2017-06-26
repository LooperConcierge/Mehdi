//
//  LooperDetailCell.m
//  Looper
//
//  Created by hardik on 2/3/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "LooperDetailCell.h"
#import "UIColor+CustomColor.h"
#import "UIFont+CustomFont.h"

@implementation LooperDetailCell
@synthesize lblDescription,viewBackGround;

- (void)awakeFromNib {
    // Initialization code
   // viewBackGround.backgroundColor = [UIColor lightGrayBackgroundColor];
    
    lblDescription.font = [UIFont fontAvenirWithSize:16];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
