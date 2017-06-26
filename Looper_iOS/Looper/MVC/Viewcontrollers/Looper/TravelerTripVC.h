//
//  TravelerTripVC.h
//  Looper
//
//  Created by hardik on 2/15/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "BaseNavVC.h"
#import "TripRequestListModel.h"

@interface TravelerTripVC : BaseNavVC

@property(nonatomic,strong)TripRequestListModel *requestModel;
@property(nonatomic,assign)BOOL isUpcomingTrip;

@end
