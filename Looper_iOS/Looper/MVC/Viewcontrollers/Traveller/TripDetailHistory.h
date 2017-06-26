//
//  TripDetailHistory.h
//  Looper
//
//  Created by hardik on 3/22/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "BaseNavVC.h"
#import "TripRequestListModel.h"

@interface TripDetailHistory : BaseNavVC

@property(nonatomic,strong)NSString *navTitle;

@property(nonatomic,strong)TripRequestListModel *tripModel;

@property(nonatomic,assign)BOOL isUpcomignTrip;

@end
