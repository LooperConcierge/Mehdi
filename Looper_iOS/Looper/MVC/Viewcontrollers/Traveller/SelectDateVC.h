//
//  SelectDateVC.h
//  Looper
//
//  Created by hardik on 2/2/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "BaseNavVC.h"
#import "SelectInterestVC.h"

typedef enum : NSUInteger {
    FROM_BOOK_LOOPERCONTROLLER,
    FROM_CITY_CONTROLLER,
} FromController1;

@interface SelectDateVC : BaseNavVC

@property(nonatomic,strong)NSMutableDictionary *paramDictionary;
@property (assign, nonatomic) FromController1 fromController;

@end
