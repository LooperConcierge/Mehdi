//
//  TravelerTripCell.m
//  Looper
//
//  Created by hardik on 2/15/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "TravelerTripCell.h"
#import "UIColor+CustomColor.h"
#import "UIFont+CustomFont.h"

@implementation TravelerTripCell
@synthesize viewBackground,lblDescription,lblPlaceName,lblSession,viewRate,imgSession,lblSeperator,btnCheckxox,dictData,delegate;

- (void)awakeFromNib {
    // Initialization code
    viewBackground.backgroundColor = [UIColor darkGrayBackgroundColor];
    lblSession.font = [UIFont fontAvenirWithSize:FONT_SMALL_SIZE];
    lblDescription.font = [UIFont fontAvenirWithSize:FONT_NORMAL_SIZE];
    lblPlaceName.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_HEADER_SIZE];
    [self setRatings];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setRatings
{
    viewRate.delegate = self;
    viewRate.emptySelectedImage = [UIImage imageNamed:@"star_inactive"];
    viewRate.fullSelectedImage = [UIImage imageNamed:@"star_active"];
    viewRate.contentMode = UIViewContentModeScaleAspectFill;
    viewRate.maxRating = 5;
    viewRate.minRating = 1;
    viewRate.rating = 2.5;
    viewRate.editable = YES;
    viewRate.halfRatings = YES;
    viewRate.floatRatings = NO;
    
}

-(void)setDictData:(NSDictionary *)dictData1
{
    dictData = dictData1;
    
    lblDescription.text = dictData[@"tDescription"];
    lblPlaceName.text = dictData[@"vPlaceName"];
    viewRate.rating = [dictData[@"iRating"] floatValue];
    
    if ([dictData[@"iScheduleZone"] intValue] == 1)
    {
        imgSession.image = [UIImage imageNamed:@"day_morning_pink"];
        lblSession.text = @"Morning";
    }
    else if ([dictData[@"iScheduleZone"] intValue] == 2)
    {
        imgSession.image = [UIImage imageNamed:@"day_afternoon_pink"];
        lblSession.text = @"Afternoon";
    }
    else if ([dictData[@"iScheduleZone"] intValue] == 3)
    {
        imgSession.image = [UIImage imageNamed:@"day_evening_pink"];
        lblSession.text = @"Evening";
    }
}
-(void)setupUI:(BOOL)edit
{
    if (edit)
    {
        imgSession.hidden = YES;
        lblSession.hidden = YES;
        btnCheckxox.hidden = NO;
    }
    else
    {
        imgSession.hidden = NO;
        lblSession.hidden = NO;
        btnCheckxox.hidden = YES;
    }

    
}

- (IBAction)btnCheckboxPressed:(id)sender
{
    if (self.btnCheckxox.selected)
    {
        self.btnCheckxox.selected = NO;
        [delegate checkBoxIsChecked:NO dictData:dictData];
    }
    else
    {
        self.btnCheckxox.selected = YES;
        [delegate checkBoxIsChecked:YES dictData:dictData];
    }
}
@end
