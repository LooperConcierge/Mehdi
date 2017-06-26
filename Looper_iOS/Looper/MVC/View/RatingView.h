//
//  RatingView.h
//  Looper
//
//  Created by hardik on 5/17/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPFloatRatingView.h"

@protocol RatingViewDelegate <NSObject>

-(void)viewDismiss;
-(void)submitRating:(CGFloat)rate;

@end


@interface RatingView : UIView

@property (strong, nonatomic) IBOutlet TPFloatRatingView *viewRate;

@property (strong, nonatomic) IBOutlet UIButton *btnSubmit;

@property (weak, nonatomic) id <RatingViewDelegate> delegate;
-(void)setRatings:(CGFloat)rate;
@end
