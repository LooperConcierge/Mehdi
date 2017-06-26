//
//  GeneralAboutView.m
//  Looper
//
//  Created by rakesh on 1/24/17.
//  Copyright © 2017 rakesh. All rights reserved.
//

#import "GeneralAboutView.h"
#import "LooperModel.h"
#import "LooperUtility.h"
#import "UIImageView+AFNetworking.h"

@implementation GeneralAboutView
@synthesize image,imgProfile,imgBackground,lblDate,lblName,lblRate,lblParty,tripRequestModel,delegate,viewProfileLayer,totalDays;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 // An empty implementation adversely affects performance during animation.
 */

 - (void)drawRect:(CGRect)rect {
 // Drawing code

     self.frame = rect;
     [LooperUtility roundUIImageView:imgProfile];
     [LooperUtility roundUIViewWithTransparentBackground:viewProfileLayer];
 }

-(void)setTripRequestModel:(TripRequestListModel *)tripRequestModel1
{
    tripRequestModel = tripRequestModel1;
    LooperModel *looperProfile = [LooperUtility getLooperProfile];
    [imgProfile setImageWithURL:[NSURL URLWithString:tripRequestModel.vProfilePic] placeholderImage:imgProfile.image];
//    NSDateFormatter *df = [[NSDateFormatter alloc] init];
//    [df setDateFormat:@"MMM dd, yyyy"];
//    lblDate.text = [NSString stringWithFormat:@"%@",[df stringFromDate:[NSDate date]]];
    lblName.text = tripRequestModel.vFullName;
    
    if (looperProfile == nil)
    {
       lblRate.text = [NSString stringWithFormat:@"$%@/Day",tripRequestModel.iRate];
    }
    else
    {
        lblRate.text = [NSString stringWithFormat:@"$%.1f/Day",looperProfile.iRates];
    }
    
    lblParty.text = [NSString stringWithFormat:@"Party of %d",tripRequestModel.iMember];
    
}

- (IBAction)btnViewTripPressed:(id)sender
{
     [delegate removeView:NO];
}

- (IBAction)btnMessagePressed:(id)sender
{
    [delegate messageBtnPressed];
}

- (IBAction)btnClosePressed:(id)sender
{
     [delegate removeView:YES];
}

@end
