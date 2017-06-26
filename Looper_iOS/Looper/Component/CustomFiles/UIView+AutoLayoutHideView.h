//
//  UIView+AutoLayoutHideView.h
//  CCR
//
//  Created by Harsh Vinchhi on 29/09/15.
//  Copyright (c) 2015 Openxcell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (AutoLayoutHideView)

- (void)hideViewByHeight:(BOOL)isHidden;
- (void)hideViewByWidth:(BOOL)isHidden;
- (void)hideView:(BOOL)isHidden withConstrainAttribute:(NSLayoutAttribute)attribute;
- (void)addBorderToView;
- (void)addOnlyBorder;
- (void)addDropShadow;

@end
