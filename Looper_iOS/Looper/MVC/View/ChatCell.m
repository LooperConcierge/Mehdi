//
//  ChatCell.m
//  Looper
//
//  Created by hardik on 3/22/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "ChatCell.h"
#import "UIFont+CustomFont.h"

@implementation ChatCell
@synthesize lblDescription,lblRightDescription,lblRightTime,lblTime;

- (void)awakeFromNib {
    // Initialization code
    lblTime.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_SMALL_SIZE];
    lblDescription.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_MEDIUM_SIZE];
    lblRightTime.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_SMALL_SIZE];
    lblRightDescription.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_MEDIUM_SIZE];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
