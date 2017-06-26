//
//  DateCell.m
//  Looper
//
//  Created by hardik on 3/28/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "DateCell.h"
#import "UIColor+CustomColor.h"
#import "UIFont+CustomFont.h"

@implementation DateCell
@synthesize lblDate,viewBG;

-(void)awakeFromNib
{
    lblDate.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_NORMAL_SIZE];
    lblDate.textColor = [UIColor whiteColor];
    viewBG.layer.borderColor=[UIColor whiteColor].CGColor;
    viewBG.layer.masksToBounds=YES;

}

-(void)setSelected:(BOOL)selected {
    if (selected)
    {
         viewBG.layer.borderWidth=2.0f;
        [viewBG setBackgroundColor:[UIColor lightGrayBackgroundColor]];
    } else
    {
        viewBG.layer.borderWidth=0.0f;
        [viewBG setBackgroundColor:[UIColor darkGrayBackgroundColor]];
    }
}
@end
