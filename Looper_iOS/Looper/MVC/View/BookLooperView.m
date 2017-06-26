//
//  BookLooperView.m
//  Looper
//
//  Created by hardik on 2/4/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "BookLooperView.h"
#import "LooperUtility.h"
#import "Constants.h"
#import "UIImageView+AFNetworking.h"
#import "AJNotificationView.h"

@implementation BookLooperView

#pragma MARK - view submit party

@synthesize btnNumberOfPerson,btnSubmit,viewSubmitParty,dictLooperBooking;

#pragma MARK - view confirmation

@synthesize imgLooeprProfile,viewConfirmation,viewProfileLayer,viewLooperSchedule,lblDate,lblEvening,lblMorning,lblPartyOf,lblAfternoon,lblDollarPerDay,viewTextBG;

@synthesize userTyp,delegate,imgDayEvening,imgDayMorning,imgDayAfternoon;

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    isSubmitClicked = FALSE;
    self.frame = rect;
    self.imgBackground.image = self.image;
    viewTextBG.layer.masksToBounds = true;
    viewTextBG.layer.cornerRadius = 2;
    viewTextBG.layer.borderColor = [UIColor lightGrayColor].CGColor;
    viewTextBG.layer.borderWidth = 0.5;
    
    if (userTyp == LOOPER_DETAIL)
    {
        viewConfirmation.hidden = TRUE;
        viewSubmitParty.hidden = TRUE;
        viewLooperSchedule.hidden =FALSE;
        [self.imgBackground setImageToBlur:self.image blurRadius:8 completionBlock:^{
        
        }];
        _transparencyView.alpha = 0.35;
    }
    else
    {
        viewSubmitParty.hidden = FALSE;
        viewConfirmation.hidden = TRUE;
        viewLooperSchedule.hidden =TRUE;
        [self.imgBackground setImageToBlur:self.image blurRadius:1 completionBlock:^{
        }];
        _transparencyView.alpha = 0.9;
    }
   
    lblDollarPerDay.adjustsFontSizeToFitWidth = YES;
    lblPartyOf.adjustsFontSizeToFitWidth = YES;
    lblDate.adjustsFontSizeToFitWidth = YES;
    [LooperUtility roundUIImageView:imgLooeprProfile];
    [LooperUtility roundUIViewWithTransparentBackground:viewProfileLayer];
    
    if (_looperModel != nil)
    {
        [imgLooeprProfile setImageWithURL:[NSURL URLWithString:_looperModel.vProfilePic] placeholderImage:imgLooeprProfile.image];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MMM dd, yyyy"];
        lblDate.text = [df stringFromDate:[NSDate date]];
        lblDollarPerDay.text = [NSString stringWithFormat:@"$%.0f/DAY",_looperModel.iRates];
    }
//    else
//    {
//        [imgLooeprProfile setImageWithURL:[NSURL URLWithString:_looperAllModel.vProfilePic] placeholderImage:imgLooeprProfile.image];
//        NSDateFormatter *df = [[NSDateFormatter alloc] init];
//        [df setDateFormat:@"MMM dd, yyyy"];
//        lblDate.text = [df stringFromDate:[NSDate date]];
//        lblDollarPerDay.text = [NSString stringWithFormat:@"$%.2f/DAY",_looperAllModel.iRates];
//    }
}


#pragma MARK - submit party view

- (IBAction)btnSubmitPressed:(id)sender
{
    NSDateFormatter  *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"HH:mm"];
    NSString *dt = [df stringFromDate:[NSDate date]];
    NSDictionary *param = @{@"iLooperID" : [NSString stringWithFormat:@"%d",_looperModel.iUserID],
                            @"dDepartureDate": dictLooperBooking[@"dDepartureDate"],
                            @"dArrivalDate" : dictLooperBooking[@"dArrivalDate"],
                            @"iExpertiseID" : dictLooperBooking[@"iExpertiseID"],
                            @"iMember" : btnNumberOfPerson.titleLabel.text,
                            @"iTripCharge" : [NSString stringWithFormat:@"%f",_looperModel.iRates],
                            @"iCityID": dictLooperBooking[@"iCityID"],
                            @"dCurrentTime" : dt
                            };
    
    lblPartyOf.text = [NSString stringWithFormat:@"PARTY OF %@",btnNumberOfPerson.titleLabel.text];
    
    [[ServiceHandler sharedInstance].travelerWebService processAddTripWithParameter:param successBlock:^(NSDictionary *response)
     {
         if ([response[success] intValue] == 1)
         {
             viewConfirmation.hidden = FALSE;
             viewSubmitParty.hidden = TRUE;
             [dictLooperBooking setObject:btnNumberOfPerson.titleLabel.text forKey:@"iMember"];
             lblPartyOf.text = [NSString stringWithFormat:@"PARTY OF %@",btnNumberOfPerson.titleLabel.text];
             isSubmitClicked = TRUE;
         }
         else
         {
             [AJNotificationView showNoticeInView:[[[UIApplication sharedApplication] delegate] window]
                                             type:AJNotificationTypeRed
                                            title:response[message]
                                  linedBackground:AJLinedBackgroundTypeDisabled
                                        hideAfter:2.5f];
         }
         
         
    } errorBlock:^(NSError *error)
    {
        
    }];

}

- (IBAction)btnPlusOrMinusPressed:(id)sender {
    NSInteger count = [btnNumberOfPerson.titleLabel.text integerValue];
    if ([self.btnPlus isTouchInside]) {
        if (count<20) {
            count++;
        }
    } else {
        if (count>1) {
            count --;

        }
    }
    [btnNumberOfPerson setTitle:[NSString stringWithFormat:@"%ld",(long)count] forState:UIControlStateNormal];
}



- (IBAction)btnClosePressed:(id)sender {

    if (isSubmitClicked)
        [delegate removeViewAndPopToViewController];
    else
        [delegate removeView:NO];
}

- (IBAction)btnDonePressed:(id)sender {

    NSString *scheduleTimeZone = @"";
    if (_btnMorning.selected)
    {
        scheduleTimeZone = @"1";
    }
    else if (_btnAfternoon.selected)
    {
        scheduleTimeZone = @"2";
    }
    else if (_btnEvening.selected)
    {
        scheduleTimeZone = @"3";
    }
    
    if (scheduleTimeZone.length == 0)
    {
        [AJNotificationView showNoticeInView:[[[UIApplication sharedApplication] delegate] window]
                                        type:AJNotificationTypeRed
                                       title:@"Please select time slot"
                             linedBackground:AJLinedBackgroundTypeDisabled
                                   hideAfter:2.5f];
    }
    NSDictionary *dict = @{@"iTripID" : [NSString stringWithFormat:@"%d",self.tripModel.iTripID],
                           @"iTravellerID" : [NSString stringWithFormat:@"%d",self.tripModel.iTravellerID],
                           @"iLooperID" : [NSString stringWithFormat:@"%d",self.tripModel.iLooperID],
                           @"dTravellingDate" : dictLooperBooking[@"selectedDate"],
                           @"iScheduleZone":scheduleTimeZone,
                           @"iExpertiseID" : dictLooperBooking[@"expertiseID"],
                           @"vPlaceName" : _placeModel.placeName,
                           @"vPlaceAddress" : _placeModel.placeAddress,
                           @"vPlaceState" : _placeModel.placeStateCode,
                           @"vPlaceCountry" : _placeModel.placeCountryCode,
                           @"iRating" : [NSString stringWithFormat:@"%.2f",_placeModel.intRating],
                           @"tDescription" : [_txtViewDescription.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],
                           @"yelpPlaceID" :  _placeModel.placeBusinessID};
    
    
    [[ServiceHandler sharedInstance].looperWebService processLooperAddTripWith:dict SuccessBlock:^(NSDictionary *response)
    {
        [delegate removeView:YES];
    } errorBlock:^(NSError *error)
    {
        
    }];
    
}

- (IBAction)btnMorningPressed:(id)sender
{
//day_morning_pink
    _btnMorning.selected = TRUE;
    _btnEvening.selected = FALSE;
    _btnAfternoon.selected = FALSE;
    [imgDayMorning setImage:[UIImage imageNamed:@"day_morning_pink"]];
    [imgDayAfternoon setImage:[UIImage imageNamed:@"day_afternoon_white"]];
    [imgDayEvening setImage:[UIImage imageNamed:@"day_evening_white"]];
}

- (IBAction)btnAfternoonPressed:(id)sender
{
//day_afternoon_pink
    _btnMorning.selected = FALSE;
    _btnEvening.selected = FALSE;
    _btnAfternoon.selected = TRUE;
    [imgDayMorning setImage:[UIImage imageNamed:@"day_morning_white"]];
    [imgDayAfternoon setImage:[UIImage imageNamed:@"day_afternoon_pink"]];
    [imgDayEvening setImage:[UIImage imageNamed:@"day_evening_white"]];
}

- (IBAction)btnEveningPressed:(id)sender
{
//day_evening_pink
    _btnMorning.selected = FALSE;
    _btnEvening.selected = TRUE;
    _btnAfternoon.selected = FALSE;
    [imgDayMorning setImage:[UIImage imageNamed:@"day_morning_white"]];
    [imgDayAfternoon setImage:[UIImage imageNamed:@"day_afternoon_white"]];
    [imgDayEvening setImage:[UIImage imageNamed:@"day_evening_pink"]];
}

- (IBAction)btnViewTripPressed:(id)sender
{

}

- (IBAction)btnCallPressed:(id)sender
{

}

- (IBAction)btnMessagePressed:(id)sender
{
    [delegate messageBtnPressed];
}

@end
