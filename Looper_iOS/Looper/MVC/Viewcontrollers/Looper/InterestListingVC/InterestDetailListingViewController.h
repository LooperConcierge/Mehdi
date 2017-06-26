//
//  InterestDetailListingViewController.h
//  Looper
//
//  Created by Meera Dave on 04/02/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "BaseNavVC.h"

@interface InterestDetailListingViewController : BaseNavVC

@property(nonatomic,strong)NSDictionary *selectedCategory;
@property(nonatomic,strong)TripDetailModelList *tripModel;

@end
