//
//  TripRequestCell.h
//  Looper
//
//  Created by hardik on 3/26/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TripRequestListModel.h"

@protocol TripRequestCellDelegate <NSObject>

@optional
-(void)tripAcceptOrDeclinePressedWithStatus:(BOOL)eStatus tripModel:(TripRequestListModel *)tripModel;

@end

@interface TripRequestCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgExclamat;
@property (strong, nonatomic) IBOutlet UIView *viewBG;
@property (strong, nonatomic) IBOutlet UILabel *lblTravelerName;
@property (strong, nonatomic) IBOutlet UILabel *lblBookingDate;
@property (strong, nonatomic) IBOutlet UILabel *lblArrivalDate;
@property (strong, nonatomic) IBOutlet UILabel *lblDepartureDate;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalMember;
@property (strong, nonatomic) IBOutlet UIButton *btnAccept;
@property (strong, nonatomic) IBOutlet UIButton *btnReject;
@property (strong, nonatomic) TripRequestListModel *requestModel;
@property (weak, nonatomic) id <TripRequestCellDelegate> delegate;

-(void)setRequestData:(TripRequestListModel *)requestModel1;

@end
