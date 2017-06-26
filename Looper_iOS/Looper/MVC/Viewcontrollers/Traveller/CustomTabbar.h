//
//  CustomTabbar.h
//  Looper
//
//  Created by hardik on 2/16/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTabbar : UITabBarController

-(void)setNavigationBarTitle:(NSString *)title;
+ (instancetype)sharedInstance;
@property(nonatomic,strong) NSDictionary *dictSearchParam;

-(void)selectedtCOntrollerIndex:(NSUInteger)index;

@end

