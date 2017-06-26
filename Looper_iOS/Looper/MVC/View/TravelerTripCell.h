//
//  TravelerTripCell.h
//  Looper
//
//  Created by hardik on 2/15/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPFloatRatingView.h"

@protocol TravelerTripCellDelegate <NSObject>

-(void)checkBoxIsChecked:(BOOL)isChecked dictData:(NSDictionary *)dictData;

@end

@interface TravelerTripCell : UITableViewCell<TPFloatRatingViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *viewBackground;
@property (strong, nonatomic) IBOutlet UILabel *lblPlaceName;
@property (strong, nonatomic) IBOutlet UILabel *lblDescription;
@property (strong, nonatomic) IBOutlet UILabel *lblSession;
@property (strong, nonatomic) IBOutlet TPFloatRatingView *viewRate;
@property (strong, nonatomic) IBOutlet UIImageView *imgSession;
@property (strong, nonatomic) IBOutlet UILabel *lblSeperator;

@property (strong, nonatomic) IBOutlet UIButton *btnCheckxox;
@property (strong, nonatomic) NSDictionary *dictData;

@property (weak, nonatomic) id <TravelerTripCellDelegate> delegate;

-(void)setupUI:(BOOL)edit;

@end
