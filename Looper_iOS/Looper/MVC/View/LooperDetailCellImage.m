//
//  LooperDetailCellImage.m
//  Looper
//
//  Created by hardik on 2/3/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "LooperDetailCellImage.h"
#import "UIFont+CustomFont.h"

@implementation LooperDetailCellImage
@synthesize lblLooperExpertiseName,viewBackground,imgLooperExpertise;

- (void)awakeFromNib {
    // Initialization code
    //viewBackground.backgroundColor = [UIColor lightGrayBackgroundColor];
    lblLooperExpertiseName.font = [UIFont fontAvenirWithSize:16];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
