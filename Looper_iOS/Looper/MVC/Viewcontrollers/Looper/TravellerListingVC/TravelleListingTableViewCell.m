//
//  TravelleListingTableViewCell.m
//  Looper
//
//  Created by Meera Dave on 03/02/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "TravelleListingTableViewCell.h"
#import "UIFont+CustomFont.h"
#import "LooperUtility.h"
#import "UIImageView+AFNetworking.h"

@implementation TravelleListingTableViewCell
@synthesize imgTravellerPic,lblTravellerAddress,lblTravellerInterest,lblTravellerName,viewImgBg,dictCurrentTrip;

- (void)awakeFromNib {
    // Initialization code
    [self SetUI];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)SetUI {
   // lblTravellerInterest.numberOfLines = 0;
   // [lblTravellerInterest sizeToFit];
    [LooperUtility roundUIImageView:imgTravellerPic];
    [LooperUtility roundUIViewWithTransparentBackground:viewImgBg];
    
    lblTravellerName.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_HEADER_SIZE];
    lblTravellerAddress.font = [UIFont fontAvenirWithSize:FONT_SMALL_SIZE];
    lblTravellerInterest.font = [UIFont fontAvenirWithSize:FONT_SMALL_SIZE];
}

-(void)setDictCurrentTrip:(NSDictionary *)dictCurrentTrip1
{
    dictCurrentTrip = dictCurrentTrip1;
    LooperModel *looperObj = [LooperUtility getLooperProfile];
    lblTravellerName.text = dictCurrentTrip[@"vFullName"];
    lblTravellerAddress.text = [NSString stringWithFormat:@"%@,%@",looperObj.vCity,looperObj.vState];
    lblTravellerInterest.text = (![dictCurrentTrip1[@"vAbout"] isEqualToString:@""]? dictCurrentTrip1[@"vAbout"] : @"User not set about yet");
    [imgTravellerPic setImageWithURL:[NSURL URLWithString:dictCurrentTrip[@"vProfilePic"]]];
}

- (CGFloat)heightOfCellWithIngredientLine:(NSString *)ingredientLine
                       withSuperviewWidth:(CGFloat)superviewWidth
{
    CGFloat labelWidth                  = superviewWidth - 30.0f;
    //    use the known label width with a maximum height of 100 points
    CGSize labelContraints              = CGSizeMake(labelWidth, 100.0f);
    
    NSStringDrawingContext *context     = [[NSStringDrawingContext alloc] init];
    
    CGRect labelRect                    = [ingredientLine boundingRectWithSize:labelContraints
                                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                                    attributes:nil
                                                                       context:context];
    
    //    return the calculated required height of the cell considering the label
    return labelRect.size.height;
}
@end
