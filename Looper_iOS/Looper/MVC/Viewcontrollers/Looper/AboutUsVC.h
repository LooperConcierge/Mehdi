//
//  AboutUsVC.h
//  Looper
//
//  Created by hardik on 5/3/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "BaseNavVC.h"

typedef enum : NSUInteger {
    TERMS_AND_CONDION = 1,
    ABOUT_US,
} OpenPage;

@interface AboutUsVC : BaseNavVC

@property(nonatomic,assign) OpenPage openPageIndex;

@end
