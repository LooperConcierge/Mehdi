//
//  RatingView.m
//  Looper
//
//  Created by hardik on 5/17/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "RatingView.h"
#import "UIFont+CustomFont.h"

@implementation RatingView
@synthesize delegate,viewRate,btnSubmit;

-(void)drawRect:(CGRect)rect
{
    self.frame = rect;
//    [self setRatings:5];
    btnSubmit.titleLabel.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_HEADER_SIZE];
}

- (IBAction)btnSubmitPressed:(id)sender
{
    [delegate submitRating:viewRate.rating];
}

- (IBAction)btnCancelPressed:(id)sender
{
    [delegate viewDismiss];
}

-(void)setRatings:(CGFloat)rate
{
    //    viewRating.delegate = self;
    viewRate.emptySelectedImage = [UIImage imageNamed:@"starEmpty"];
    viewRate.fullSelectedImage = [UIImage imageNamed:@"starFull"];
    viewRate.contentMode = UIViewContentModeScaleAspectFill;
    viewRate.maxRating = 5;
    viewRate.minRating = 1;
    viewRate.rating = rate;
    viewRate.editable = YES;
    viewRate.halfRatings = NO;
    viewRate.floatRatings = NO;
    
}
@end
