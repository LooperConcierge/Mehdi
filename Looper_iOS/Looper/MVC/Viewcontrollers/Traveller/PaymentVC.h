//
//  PaymentVC.h
//  Looper
//
//  Created by rakesh on 2/9/17.
//  Copyright © 2017 rakesh. All rights reserved.
//

#import "BaseNavVC.h"
#import "TripRequestListModel.h"

@interface PaymentVC : BaseNavVC

@property(nonatomic,strong)TripRequestListModel *reqObj;
@property(nonatomic,strong)NSDictionary *looperDict;
@property float serviceCharge;
@property float tripCharge;
@end
