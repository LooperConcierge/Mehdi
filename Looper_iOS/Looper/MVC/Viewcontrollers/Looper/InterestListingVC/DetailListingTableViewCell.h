//
//  DetailListingTableViewCell.h
//  Looper
//
//  Created by Meera Dave on 04/02/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPFloatRatingView.h"
#import "PlaceModel.h"

@interface DetailListingTableViewCell : UITableViewCell<TPFloatRatingViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnRadio;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblSubAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblType;
@property (weak, nonatomic) IBOutlet TPFloatRatingView *vwRating;
@property (weak, nonatomic) IBOutlet UIView *vwContain;
@property (strong, nonatomic) PlaceModel *modelObj;

@end
