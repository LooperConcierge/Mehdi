//
//  LooperCell.h
//  Looper
//
//  Created by hardik on 2/2/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPFloatRatingView.h"
#import "LooperListModel.h"


@interface LooperCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblLooperName;
@property (strong, nonatomic) IBOutlet UILabel *lblLooperCity;
@property (strong, nonatomic) IBOutlet UILabel *lblLooperExpertise;
@property (strong, nonatomic) IBOutlet UILabel *lblLooperRate;
@property (strong, nonatomic) IBOutlet UIImageView *imgLooperImage;
@property (strong, nonatomic) IBOutlet UIView *viewBackGround;
@property (strong, nonatomic) IBOutlet TPFloatRatingView *viewRating;
@property (strong, nonatomic) IBOutlet UILabel *lblDaily;
@property (strong, nonatomic) LooperObjModel *modelLooper;
//@property (strong, nonatomic) LooperAllListModel *modelLooperAll;

@end
