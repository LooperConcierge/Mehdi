//
//  CustomTabbarLooper.h
//  Looper
//
//  Created by hardik on 2/16/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTabbarLooper : UITabBarController

@property(assign,nonatomic)BOOL isFromSignup;
-(void)selectedtCOntrollerIndex:(NSUInteger)index;
@end
