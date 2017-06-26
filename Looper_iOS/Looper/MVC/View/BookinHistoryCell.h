//
//  BookinHistoryCell.h
//  Looper
//
//  Created by hardik on 3/16/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TripRequestListModel.h"

@interface BookinHistoryCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *viewBackground;
@property (strong, nonatomic) IBOutlet UILabel *lblTripName;
@property (strong, nonatomic) IBOutlet UILabel *lblBookingDate;
@property (strong, nonatomic) IBOutlet UILabel *lblArrivalDate;
@property (strong, nonatomic) IBOutlet UILabel *lblDepartDate;
@property (strong, nonatomic) IBOutlet UIImageView *imgRightArrow;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalMember;
@property (strong, nonatomic) TripRequestListModel *modelObj;

@end
