//
//  TravellerCalendarCell.m
//  Looper
//
//  Created by hardik on 2/24/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "TravellerCalendarCell.h"
#import "UIColor+CustomColor.h"
#import "LooperUtility.h"
#import "UIFont+CustomFont.h"

@implementation TravellerCalendarCell
@synthesize lblLeftPlaceDescription,lblLeftPlaceName,viewLeft,viewLeftRate,btnSession,btnCheckBox,isEdit,dictTrip,delegate;

- (void)awakeFromNib {
    // Initialization code
}

-(void)setDictTrip:(NSDictionary *)dictTrip1
{
    dictTrip = dictTrip1;
    
    viewLeft.hidden = FALSE;
    lblLeftPlaceDescription.text = dictTrip[@"tDescription"];
    lblLeftPlaceName.text = dictTrip[@"vPlaceName"];
    
    lblLeftPlaceDescription.font = [UIFont fontAvenirWithSize:FONT_NORMAL_SIZE];
    lblLeftPlaceName.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_MEDIUM_SIZE];
    
    
    if ([dictTrip[@"iScheduleZone"] intValue] == 1)
    {
        [btnSession setImage:[UIImage imageNamed:@"day_morning_pink"] forState:UIControlStateNormal];
    }
    else if ([dictTrip[@"iScheduleZone"] intValue] == 2)
    {
        [btnSession setImage:[UIImage imageNamed:@"day_afternoon_pink"] forState:UIControlStateNormal];
    }
    else if ([dictTrip[@"iScheduleZone"] intValue] == 3)
    {
        [btnSession setImage:[UIImage imageNamed:@"day_evening_pink"] forState:UIControlStateNormal];
    }
    
    [self setRating];
    viewLeft.backgroundColor = [UIColor darkGrayBackgroundColor];
    
    if (isEdit)
    {
        btnCheckBox.hidden = FALSE;
        btnSession.hidden = TRUE;
        
    }
    else
    {
        btnCheckBox.hidden = TRUE;
        btnSession.hidden = FALSE;
    }
}
//-(void)setdictTrip:(NSDictionary *)modelTrip1
//{
//    dictTrip = modelTrip1;
//    
//    viewLeft.hidden = FALSE;
//    lblLeftPlaceDescription.text = dictTrip[@"tDescription"];
//    lblLeftPlaceName.text = dictTrip[@"vPlaceName"];
//    
//    lblLeftPlaceDescription.font = [UIFont fontAvenirWithSize:FONT_NORMAL_SIZE];
//    lblLeftPlaceName.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_MEDIUM_SIZE];
//    
//    
//    if ([dictTrip[@"iScheduleZone"] intValue] == 1)
//    {
//        [btnSession setImage:[UIImage imageNamed:@"day_morning_pink"] forState:UIControlStateNormal];
//    }
//    else if ([dictTrip[@"iScheduleZone"] intValue] == 2)
//    {
//        [btnSession setImage:[UIImage imageNamed:@"day_afternoon_pink"] forState:UIControlStateNormal];
//    }
//    else if ([dictTrip[@"iScheduleZone"] intValue] == 3)
//    {
//        [btnSession setImage:[UIImage imageNamed:@"day_evening_pink"] forState:UIControlStateNormal];
//    }
//
//    [self setRating];
//    viewLeft.backgroundColor = [UIColor darkGrayBackgroundColor];
//
//    if (isEdit)
//    {
//        btnCheckBox.hidden = FALSE;
//        btnSession.hidden = TRUE;
//        
//    }
//    else
//    {
//        btnCheckBox.hidden = TRUE;
//        btnSession.hidden = FALSE;
//    }
//}

-(void)setRating
{

        viewLeftRate.emptySelectedImage = [UIImage imageNamed:@"star_inactive"];
        viewLeftRate.fullSelectedImage = [UIImage imageNamed:@"star_active"];
        viewLeftRate.contentMode = UIViewContentModeScaleAspectFill;
        viewLeftRate.maxRating = 5;
        viewLeftRate.minRating = 1;
        viewLeftRate.rating = [dictTrip[@"iRating"] floatValue];
        viewLeftRate.editable = NO;
        viewLeftRate.halfRatings = YES;
        viewLeftRate.floatRatings = NO;
   
}

-(void)setCornerRadius
{
    CAShapeLayer * maskLayer = [CAShapeLayer layer];
    
    [self layoutSubviews];
    
//========================================================================================================================                    THIS NEED TO BE CALL FOR GETTING THE NEW BOUNDS AND FRAME OF THE VIEW ==================================================================================================================================
        [viewLeft layoutSubviews];
        [viewLeft setNeedsLayout];
        [viewLeft layoutIfNeeded];
// ===================================== END =====================================================
        
        maskLayer.path = [UIBezierPath bezierPathWithRoundedRect: viewLeft.bounds byRoundingCorners: (UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii: CGSizeMake(5.0, 5.0)].CGPath;

        viewLeft.layer.mask = maskLayer;
        viewLeft.layer.masksToBounds = YES;
}

//- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
//    if ([self.delegate isPseudoEditing]) {
//        self.pseudoEdit = editing;
//        [self beginEditMode];
//    } else {
//        [super setEditing:editing animated:animated];
//    }
//}
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//    
//    self.customEditControl.selected = selected;
//}
//
//// Animate view to show/hide custom edit control/button
//- (void)beginEditMode {
//    self.leadingSpaceMainViewConstraint.constant = self.editing && !self.isDeleting ? 0 : -kCustomEditControlWidth;
//    
//    [UIView animateWithDuration:0.3 animations:^{
//        [self.viewLeft.superview layoutIfNeeded];
//    }];
//}

- (IBAction)btnCheckBoxPressed:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    [delegate setCheckBoxWithDict:dictTrip];
    if (btn.selected)
    {
        btn.selected = FALSE;
    }
    else
    {
        btn.selected = TRUE;
    }
}
@end
