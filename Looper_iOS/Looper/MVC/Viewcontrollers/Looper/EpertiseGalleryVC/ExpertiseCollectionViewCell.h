//
//  ExpertiseCollectionViewCell.h
//  Looper
//
//  Created by Meera Dave on 01/02/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassionModel.h"

@interface ExpertiseCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *VwImage;

@property (weak, nonatomic) IBOutlet UIImageView *imgExpertise;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIButton *btnCellTap;
@property (assign, nonatomic) BOOL isSingleTouch;
-(void)setValueOfCell:(PassionModel *)dic SetSingleTouch:(BOOL)value;
-(IBAction)onTapCell:(id)sender;

@end
