//
//  UIView+AutoLayoutHideView.m
//  CCR
//
//  Created by Harsh Vinchhi on 29/09/15.
//  Copyright (c) 2015 Openxcell. All rights reserved.
//

#import "UIView+AutoLayoutHideView.h"

@implementation UIView (AutoLayoutHideView)

- (void)hideViewByHeight:(BOOL)isHidden {
    [self hideView:isHidden withConstrainAttribute:NSLayoutAttributeHeight];
}

- (void)hideViewByWidth:(BOOL)isHidden {
    [self hideView:isHidden withConstrainAttribute:NSLayoutAttributeWidth];
}

- (void)hideView:(BOOL)isHidden withConstrainAttribute:(NSLayoutAttribute)attribute {
    
    if (self.hidden != isHidden) {
        
        CGFloat constrainConstant = [self getConstrainConstantForAttribure:attribute];
        
        if (isHidden) {
            if (!isnan(constrainConstant)) {
                self.alpha = constrainConstant;
            } else {
                CGSize size = [self getSize];
                self.alpha = (attribute == NSLayoutAttributeHeight)?size.height:size.width;
            }
            [self setConstraintConstant:0 forAttribute:attribute];
            self.hidden = YES;
        } else {
            if (!isnan(constrainConstant)) {
                self.hidden = NO;
                [self setConstraintConstant:self.alpha forAttribute:attribute];
                self.alpha = 1;
            }
        }
    }
}

- (CGFloat)getConstrainConstantForAttribure:(NSLayoutAttribute)attribute {
    NSLayoutConstraint * constraint = [self constrainForAttribure:attribute];
    if (constraint) {
        return constraint.constant;
    } else {
        return NAN;
    }
}

- (NSLayoutConstraint *)constrainForAttribure:(NSLayoutAttribute)attribute {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstAttribute = %d && firstItem = %@", attribute, self];
    NSArray *fillteredArray = [[self.superview constraints] filteredArrayUsingPredicate:predicate];
    
    if (fillteredArray.count == 0) {
        fillteredArray = [[self constraints] filteredArrayUsingPredicate:predicate];
        if([fillteredArray count] > 0) {
            return fillteredArray.firstObject;
        }
        return nil;
    } else {
        return fillteredArray.firstObject;
    }
}

- (BOOL)setConstraintConstant:(CGFloat)constant forAttribute:(NSLayoutAttribute)attribute {
    NSLayoutConstraint *constraint = [self constrainForAttribure:attribute];
    if (constraint) {
        [constraint setConstant:constant];
        return YES;
    } else {
        [self.superview addConstraint: [NSLayoutConstraint constraintWithItem:self attribute:attribute relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:constant]];
        return NO;
    }
}

- (CGSize)getSize {
    [self updateSize];
    return CGSizeMake(self.bounds.size.width, self.bounds.size.height);
}

- (void)updateSize {
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)addBorderToView {
    self.layer.borderColor = [UIColor colorWithRed:194.0f/255.0f green:194.0f/255.0f blue:194.0f/255.0f alpha:1.0f].CGColor;
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 4.0f;
    self.layer.masksToBounds = YES;
}

- (void)addOnlyBorder {
    self.layer.borderColor = [UIColor colorWithRed:194.0f/255.0f green:194.0f/255.0f blue:194.0f/255.0f alpha:1.0f].CGColor;
    self.layer.borderWidth = 1.0f;
}

- (void)addDropShadow {
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.bounds];
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    self.layer.shadowOpacity = 0.5f;
    self.layer.shadowPath = shadowPath.CGPath;
}

@end
