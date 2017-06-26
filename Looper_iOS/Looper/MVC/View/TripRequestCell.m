//
//  TripRequestCell.m
//  Looper
//
//  Created by hardik on 3/26/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "TripRequestCell.h"
#import "UIFont+CustomFont.h"
#import "LooperUtility.h"

@implementation TripRequestCell
@synthesize lblArrivalDate,lblBookingDate,lblDepartureDate,lblTravelerName,lblTotalMember,requestModel,delegate,imgExclamat;

- (void)awakeFromNib {
    // Initialization code
    lblTravelerName.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_MEDIUM_SIZE];
    lblArrivalDate.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_NORMAL_SIZE];
    lblBookingDate.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_NORMAL_SIZE];
    lblDepartureDate.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_NORMAL_SIZE];
    lblTotalMember.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_NORMAL_SIZE];
    _btnAccept.titleLabel.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_NORMAL_SIZE];
    _btnReject.titleLabel.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_NORMAL_SIZE];
    lblArrivalDate.textColor = [UIColor darkGrayColor];
    lblBookingDate.textColor = [UIColor darkGrayColor];
    lblDepartureDate.textColor = [UIColor darkGrayColor];
    lblTotalMember.textColor = [UIColor darkGrayColor];
    [super awakeFromNib];
}

-(void)setRequestModel:(TripRequestListModel *)requestModel1
{
    requestModel = requestModel1;
    lblTravelerName.text = requestModel.vFullName;
    lblArrivalDate.text = [NSString stringWithFormat:@"End Date : %@",[LooperUtility convertServerDateToAppString:requestModel.dArrivalDate]];
    lblDepartureDate.text = [NSString stringWithFormat:@"Start Date : %@",[LooperUtility convertServerDateToAppString:requestModel.dDepartureDate]];
    lblBookingDate.text = [NSString stringWithFormat:@"Booking Date : %@",[LooperUtility convertServerDateToAppString:requestModel.dBookingDate]];
    lblTotalMember.text = [NSString stringWithFormat:@"Total Member : %d",requestModel.iMember];
    
    imgExclamat.hidden = true;
    if ([requestModel.isEdit intValue] == 1)
    {
        imgExclamat.hidden = false;
    }
}

-(void)setRequestData:(TripRequestListModel *)requestModel1
{
    requestModel = requestModel1;
    lblTravelerName.text = requestModel.vFullName;
    lblArrivalDate.text = [NSString stringWithFormat:@"End Date : %@",[LooperUtility convertServerDateToAppString:requestModel.dArrivalDate]];
    lblDepartureDate.text = [NSString stringWithFormat:@"Start Date : %@",[LooperUtility convertServerDateToAppString:requestModel.dDepartureDate]];
    lblBookingDate.text = [NSString stringWithFormat:@"Booking Date : %@",[LooperUtility convertServerDateToAppString:requestModel.dBookingDate]];
    lblTotalMember.text = [NSString stringWithFormat:@"Total Member : %d",requestModel.iMember];
    imgExclamat.hidden = true;
    if ([requestModel.isEdit intValue] == 1)
    {
        imgExclamat.hidden = false;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnAcceptPressed:(id)sender
{
    [delegate tripAcceptOrDeclinePressedWithStatus:YES tripModel:requestModel];
}

- (IBAction)btnDeclinePressed:(id)sender
{
    [delegate tripAcceptOrDeclinePressedWithStatus:NO tripModel:requestModel];
}
@end
