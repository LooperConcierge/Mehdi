//
//  TravellerCalendarHeaderView.h
//  Looper
//
//  Created by hardik on 2/24/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TravellerCalendarHeaderView : UITableViewCell
@property (nonatomic,strong)NSDictionary *dictHeader;
@property (strong, nonatomic) IBOutlet UIView *viewLeft;
@property (strong, nonatomic) IBOutlet UIView *viewRight;
@property (strong, nonatomic) IBOutlet UILabel *lblLeftTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblRightTitle;

@property (strong, nonatomic) IBOutlet UIButton *btnCheckMark;

/**
 *  This method is called in will displayHeader method to update the UI of the table header view
 */
-(void)setHeaderCornerRadius;

@end
