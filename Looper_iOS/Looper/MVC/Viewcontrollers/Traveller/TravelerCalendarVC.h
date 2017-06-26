//
//  BookLooperVC.h
//  Looper
//
//  Created by hardik on 2/4/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "BaseNavVC.h"
#import "GIBadgeView.h"




@interface TravelerCalendarVC : BaseNavVC

@property(nonatomic,strong) UIImage *imageBackGround;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constTopButtonSearch;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constLeadingButtonSearch;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constWidthButtonSearch;

@end
