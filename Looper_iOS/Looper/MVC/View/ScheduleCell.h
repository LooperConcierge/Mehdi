//
//  ScheduleCell.h
//  LeftRightContententScrollview
//
//  Created by hardik on 1/11/17.
//  Copyright © 2017 rakesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"
#import "TPFloatRatingView.h"


@interface ScheduleCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *viewLeft;
@property (strong, nonatomic) IBOutlet UIView *viewRight;
@property (strong, nonatomic) IBOutlet UIButton *btnLeftBusiness;

@property (strong, nonatomic) IBOutlet UIButton *btnRightBusiness;
@property (strong, nonatomic) IBOutlet UILabel *lblLeftViewTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblLeftDescription;

@property (strong, nonatomic) IBOutlet UILabel *lblRightViewTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblRightViewDescription;

@property (strong, nonatomic) IBOutlet UIButton *btnCheckBox;

@property (strong, nonatomic) DataModel *objData;
@property (strong, nonatomic) IBOutlet UILabel *lblRight;
@property (strong, nonatomic) IBOutlet UILabel *lblLeft;
@property (strong, nonatomic) IBOutlet TPFloatRatingView *viewLeftRating;
@property (strong, nonatomic) IBOutlet TPFloatRatingView *viewRightRate;
@property (strong, nonatomic) IBOutlet UIImageView *imgExelLeft;
@property (strong, nonatomic) IBOutlet UIImageView *imgExelRight;

-(void)removeCornerRadius:(UIView *)assignView;
-(void)createCornerRadius:(UIView *)assignView;
-(void)dottedLine;

-(void)setRatings:(CGFloat)rate;


@end
