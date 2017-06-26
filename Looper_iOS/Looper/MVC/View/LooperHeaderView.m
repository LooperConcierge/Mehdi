//
//  LooperHeaderView.m
//  Looper
//
//  Created by hardik on 2/3/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "LooperHeaderView.h"
#import "UIFont+CustomFont.h"

@implementation LooperHeaderView
@synthesize lblHeaderName,viewBackground;

- (void)awakeFromNib
{
    // Initialization code
//    viewBackground.backgroundColor = [UIColor lightGrayBackgroundColor];
    lblHeaderName.font = [UIFont fontAvenirNextCondensedMediumWithSize:16];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

