//
//  TravelleListingTableViewCell.h
//  Looper
//
//  Created by Meera Dave on 03/02/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TravelleListingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgTravellerPic;
@property (weak, nonatomic) IBOutlet UILabel *lblTravellerName;
@property (weak, nonatomic) IBOutlet UILabel *lblTravellerAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblTravellerInterest;
@property (strong, nonatomic) IBOutlet UIView *viewImgBg;
@property (strong, nonatomic) NSDictionary *dictCurrentTrip;

@end
