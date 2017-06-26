//
//  InterestCell.h
//  Looper
//
//  Created by hardik on 2/2/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassionModel.h"

@interface InterestCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgInterest;
@property (strong, nonatomic) IBOutlet UILabel *lblInterestName;

@property (strong, nonatomic) PassionModel *interestDictionary;
@property (strong, nonatomic) IBOutlet UIView *viewBackGround;

@end
