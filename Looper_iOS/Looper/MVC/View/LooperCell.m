//
//  LooperCell.m
//  Looper
//
//  Created by hardik on 2/2/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "LooperCell.h"
#import "UIColor+CustomColor.h"
#import "UIFont+CustomFont.h"
#import "LooperUtility.h"
#import "Constants.h"
#import "UIImageView+AFNetworking.h"

@implementation LooperCell
@synthesize imgLooperImage,lblLooperExpertise,lblLooperCity,lblLooperName,lblLooperRate,viewBackGround,viewRating,lblDaily,modelLooper;

- (void)awakeFromNib {
    // Initialization code
    imgLooperImage.layer.cornerRadius = self.imgLooperImage.frame.size.width/2;
    imgLooperImage.layer.masksToBounds = YES;
    viewBackGround.backgroundColor = [UIColor darkGrayBackgroundColor];
    lblLooperCity.font = [UIFont fontAvenirWithSize:FONT_NORMAL_SIZE];
    lblLooperExpertise.font = [UIFont fontAvenirWithSize:FONT_SMALL_SIZE];
    lblLooperName.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_HEADER_LARGE_SIZE];
    lblLooperRate.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_NORMAL_SIZE];
    lblDaily.font = [UIFont fontAvenirWithSize:FONT_SMALL_SIZE];
    lblDaily.text = [[LooperUtility sharedInstance].localization localizedStringForKey:keyDaily];
    ///lblLooperExpertise.textColor=[UIColor lightRedBackgroundColor]
    
    [super awakeFromNib];
}

-(void)setModelLooper:(LooperObjModel *)modelLooper1
{
    modelLooper = modelLooper1;
    
    lblLooperCity.text = modelLooper.vCity;
    lblLooperName.text = modelLooper.vFullName;
    lblLooperRate.text = [NSString stringWithFormat:@"$%.0f",modelLooper.iRates];
//    NSArray *expertiseArray = [LooperUtility expertiseArray:modelLooper.expertises];
//    lblLooperExpertise.text = [[modelLooper.expertises valueForKey:@"vName"] componentsJoinedByString:@", "];
    lblLooperExpertise.text = modelLooper.vMotto;
    [imgLooperImage setImageWithURL:[NSURL URLWithString:modelLooper.vProfilePic] placeholderImage:[UIImage imageNamed:@"TravellerRegister"]];
    
    NSString *strNumber = [NSString stringWithFormat:@"%@",modelLooper.iRating];
    [self setRatings:[strNumber floatValue]];
//    [self setRatings:modelLooper.iRating];

}

//-(void)setModelLooperAll:(LooperAllListModel *)modelLooperAll1
//{
//    modelLooperAll1 = modelLooperAll1;
//    
//    lblLooperCity.text = modelLooperAll1.vCity;
//    lblLooperName.text = modelLooperAll1.vFullName;
//    lblLooperRate.text = [NSString stringWithFormat:@"$%.2f",modelLooperAll1.iRates];
//    NSArray *expertiseArray = [LooperUtility expertiseArray:modelLooperAll1.expertises];
//    lblLooperExpertise.text = [[expertiseArray valueForKey:@"name"] componentsJoinedByString:@","];
//    [imgLooperImage setImageWithURL:[NSURL URLWithString:modelLooperAll1.vProfilePic] placeholderImage:[UIImage imageNamed:@"TravellerRegister"]];
//    //    [self setRatings:modelLooper.iRating];
//    
//}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setRatings:(CGFloat)rate
{
//    viewRating.delegate = self;
    viewRating.emptySelectedImage = [UIImage imageNamed:@"starEmpty"];
    viewRating.fullSelectedImage = [UIImage imageNamed:@"starFull"];
    viewRating.contentMode = UIViewContentModeScaleAspectFill;
    viewRating.maxRating = 5;
    viewRating.minRating = 1;
    viewRating.rating = rate;
    viewRating.editable = NO;
    viewRating.halfRatings = YES;
    viewRating.floatRatings = NO;

}
@end
