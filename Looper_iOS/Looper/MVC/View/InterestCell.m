//
//  InterestCell.m
//  Looper
//
//  Created by hardik on 2/2/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "InterestCell.h"
#import "UIColor+CustomColor.h"
#import "UIFont+CustomFont.h"
#import "UIImageView+AFNetworking.h"

@implementation InterestCell
@synthesize lblInterestName,imgInterest,interestDictionary,viewBackGround;

-(void)awakeFromNib
{
    lblInterestName.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_SMALL_SIZE];
    [super awakeFromNib];
}

-(void)setInterestDictionary:(PassionModel *)interestDictionary1
{
    interestDictionary = interestDictionary1;
    lblInterestName.text = interestDictionary.vName;
    [imgInterest setImageWithURL:[NSURL URLWithString:interestDictionary.image] placeholderImage:nil];
    self.imgInterest.layer.borderColor=[UIColor whiteColor].CGColor;
    self.imgInterest.layer.masksToBounds=YES;
    
    self.viewBackGround.layer.borderColor=[UIColor whiteColor].CGColor;
    self.viewBackGround.layer.masksToBounds=YES;
    [self.viewBackGround setBackgroundColor:[UIColor darkGrayBackgroundColor]];
    
//    if ([interestDictionary[@"selected"] boolValue] == TRUE)
//    {
//        self.viewBackGround.layer.borderWidth = 2.0f;
//        [self.viewBackGround setBackgroundColor:[UIColor lightGrayBackgroundColor]];
//    }
//    else
//    {
//        self.viewBackGround.layer.borderWidth = 0.0f;
//        [self.viewBackGround setBackgroundColor:[UIColor darkGrayBackgroundColor]];
//    }
}


-(void)setSelected:(BOOL)selected {
    
    if (selected)
    {
        self.viewBackGround.layer.borderWidth=2.0f;
        [self.viewBackGround setBackgroundColor:[UIColor lightGrayBackgroundColor]];
    } else
    {
        self.viewBackGround.layer.borderWidth=0.0f;
        [self.viewBackGround setBackgroundColor:[UIColor darkGrayBackgroundColor]];
    }
}
@end
