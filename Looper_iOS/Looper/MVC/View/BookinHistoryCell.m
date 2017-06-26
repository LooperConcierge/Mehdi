//
//  BookinHistoryCell.m
//  Looper
//
//  Created by hardik on 3/16/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "BookinHistoryCell.h"
#import "UIFont+CustomFont.h"
#import "LooperUtility.h"
@implementation BookinHistoryCell
@synthesize lblArrivalDate,lblBookingDate,lblDepartDate,lblTripName,imgRightArrow,lblTotalMember,modelObj;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    lblTripName.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_MEDIUM_SIZE];
    lblBookingDate.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_NORMAL_SIZE];
    lblDepartDate.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_NORMAL_SIZE];
    lblArrivalDate.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_NORMAL_SIZE];
    imgRightArrow.image = [imgRightArrow.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [imgRightArrow setTintColor:[UIColor darkGrayColor]];
    lblTotalMember.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_NORMAL_SIZE];
    lblTotalMember.textColor = [UIColor darkGrayColor];
    lblBookingDate.textColor = [UIColor darkGrayColor];
    lblDepartDate.textColor = [UIColor darkGrayColor];
    lblArrivalDate.textColor = [UIColor darkGrayColor];
}

-(void)setModelObj:(TripRequestListModel *)modelObj1
{
    modelObj = modelObj1;
    if (modelObj.vCity != nil)
        lblTripName.text = [NSString stringWithFormat:@"%@ Trip", modelObj.vCity];
    else
        lblTripName.text = modelObj.vFullName;
    
//    lblArrivalDate.text = [NSString stringWithFormat:@"Arrival Date : %@",[LooperUtility convertServerDateToAppString:modelObj.dArrivalDate]];
//    lblDepartDate.text = [NSString stringWithFormat:@"Departure Date : %@",[LooperUtility convertServerDateToAppString:modelObj.dDepartureDate]];
    lblArrivalDate.text = [NSString stringWithFormat:@"Start Date : %@",[LooperUtility convertServerDateToAppString:modelObj.dDepartureDate]];
    lblDepartDate.text = [NSString stringWithFormat:@"End Date : %@",[LooperUtility convertServerDateToAppString:modelObj.dArrivalDate]];
                                                                            
    lblBookingDate.text = [NSString stringWithFormat:@"Booking Date : %@",[LooperUtility convertServerDateToAppString:modelObj.dBookingDate]];
    lblTotalMember.text = [NSString stringWithFormat:@"Total Member : %d",modelObj.iMember];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
