//
//  DetailListingTableViewCell.m
//  Looper
//
//  Created by Meera Dave on 04/02/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "DetailListingTableViewCell.h"

@implementation DetailListingTableViewCell
@synthesize lblAddress,lblName,lblSubAddress,lblType,btnRadio,vwContain,vwRating,modelObj;

-(void)awakeFromNib
{
 
    [self setUI];
    
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setModelObj:(PlaceModel *)modelObj1
{
    modelObj = modelObj1;
    lblName.text = modelObj.placeName;
    lblAddress.text = modelObj.placeAddress;
    lblSubAddress.text = modelObj.placeSubAddress;
    vwRating.rating = modelObj.intRating;
}

-(void)setUI {
    [self setRatings];
    
//    UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, vwContain.frame.size.height - 2.0f, vwContain.frame.size.width, 2)];
//    bottomBorder.backgroundColor = [UIColor redColor];
//    UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//    bottomBorder.backgroundColor = [UIColor redColor];
    //[vwContain addSubview:bottomBorder];
  //  [vwContain setBackgroundColor:[UIColor greenColor]];

    
}
-(void)setRatings
{
    vwRating.delegate = self;
    vwRating.emptySelectedImage = [UIImage imageNamed:@"starEmpty"];
    vwRating.fullSelectedImage = [UIImage imageNamed:@"starFull"];
    vwRating.contentMode = UIViewContentModeScaleAspectFill;
    vwRating.maxRating = 5;
    vwRating.minRating = 1;
    vwRating.rating = 2.5;
    vwRating.editable = NO;
    vwRating.halfRatings = YES;
    vwRating.floatRatings = NO;
    
}
@end
