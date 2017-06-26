//
//  TravellerCalendarCell.h
//  Looper
//
//  Created by hardik on 2/24/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPFloatRatingView.h"

@protocol TravellerCellDelegate

@optional
-(void)setCheckBoxWithDict:(NSDictionary *)dictionary;
//@property (nonatomic, readonly, getter=isPseudoEditing) BOOL pseudoEdit;
//
@end

@interface TravellerCalendarCell : UITableViewCell


@property(strong,nonatomic)NSDictionary *dictTrip;
@property (strong, nonatomic) IBOutlet UIView *viewLeft;
@property (strong, nonatomic) IBOutlet UILabel *lblLeftPlaceName;
@property (strong, nonatomic) IBOutlet TPFloatRatingView *viewLeftRate;
@property (strong, nonatomic) IBOutlet UILabel *lblLeftPlaceDescription;

@property (strong, nonatomic) IBOutlet UILabel *lblLeftSeperator;
@property (strong, nonatomic) IBOutlet UIButton *btnCheckBox;

@property (strong, nonatomic) IBOutlet UIButton *btnSession;

@property BOOL isEdit;

-(void)setCornerRadius;

@property (nonatomic, weak) id<TravellerCellDelegate>delegate;

@end
