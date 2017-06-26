//
//  TravellerCalendarHeaderView.m
//  Looper
//
//  Created by hardik on 2/24/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "TravellerCalendarHeaderView.h"
#import "UIFont+CustomFont.h"

@implementation TravellerCalendarHeaderView
@synthesize dictHeader,lblLeftTitle,lblRightTitle,viewLeft,viewRight;

- (void)awakeFromNib {
    // Initialization code
//    CAShapeLayer * maskLayer = [CAShapeLayer layer];
//    
//    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect: self.bounds byRoundingCorners: UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii: (CGSize){5.0, 5.0}].CGPath;
//    
//    viewLeft.layer.mask = maskLayer;
//    viewRight.layer.mask = maskLayer;
    lblLeftTitle.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_HEADER_SIZE];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setDictHeader:(NSDictionary *)dictHeader1
{
    dictHeader = dictHeader1;
    
    viewLeft.hidden = FALSE;
    viewRight.hidden = TRUE;
    lblLeftTitle.text = dictHeader[@"dTravellingDate"];
}

- (IBAction)btnCheckMarkPressed:(id)sender
{

}

-(void)setHeaderCornerRadius
{
    CAShapeLayer * maskLayer = [CAShapeLayer layer];
    
    [_btnCheckMark layoutSubviews];
    [_btnCheckMark setNeedsLayout];
    [_btnCheckMark layoutIfNeeded];
    
    [self layoutSubviews];
    [viewLeft layoutSubviews];
    [viewLeft setNeedsLayout];
    [viewLeft layoutIfNeeded];
    
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect: viewLeft.bounds byRoundingCorners: UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii: (CGSize){5.0, 5.0}].CGPath;
    viewLeft.layer.mask = maskLayer;
    viewLeft.layer.masksToBounds = YES;
    
    _btnCheckMark.layer.cornerRadius = CGRectGetWidth(_btnCheckMark.frame)/2;
}

@end
