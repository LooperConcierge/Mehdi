//
//  ExpertiseCollectionViewCell.m
//  Looper
//
//  Created by Meera Dave on 01/02/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "ExpertiseCollectionViewCell.h"
#import "UIColor+CustomColor.h"
#import "ExpertiseGalleryViewController.h"

#import "UIImageView+AFNetworking.h"
@interface ExpertiseCollectionViewCell ()
{
    UITapGestureRecognizer *tapGesture;
    BOOL singleTouch;
}
@end
@implementation ExpertiseCollectionViewCell
@synthesize isSingleTouch;

#pragma mark - View Lifecycle
- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [self setupUI];
    self.VwImage.layer.borderColor=[UIColor whiteColor].CGColor;
    self.VwImage.layer.masksToBounds=YES;
    self.lblName.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_SMALL_SIZE];

    
    
}
- (void)dealloc {
    
}
-(void)setSelected:(BOOL)selected {
   
    if (selected) {
        self.VwImage.layer.borderWidth=2.0f;
        [self.VwImage setBackgroundColor:[UIColor lightGrayBackgroundColor]];
    } else {
        self.VwImage.layer.borderWidth=0.0f;
        [self.VwImage setBackgroundColor:[UIColor darkGrayBackgroundColor]];

    }
}

#pragma mark - SETUP UI

- (void)setupUI {
    [self.VwImage setBackgroundColor:[UIColor darkGrayBackgroundColor]];
    self.btnCellTap.hidden=YES;

}

-(void)setValueOfCell:(PassionModel *)dic SetSingleTouch:(BOOL)value {
    [self.lblName setText:dic.vName];
    [self.imgExpertise setImageWithURL:[NSURL URLWithString:dic.image]];
    if (!value) {
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ontapGesture:)];
        [self addGestureRecognizer:tapGesture];
    }
    
}

- (IBAction)onTapCell:(id)sender {
    [self setSelected:NO];
    self.btnCellTap.hidden = YES;
    if ([self.superview.superview.nextResponder isKindOfClass:[ExpertiseGalleryViewController class]]) {
        [(ExpertiseGalleryViewController *)self.superview.superview.nextResponder OnTapCellUnSelected:sender];
    }
}
- (IBAction)ontapGesture:(UIGestureRecognizer*)gestureRecognizer {
    [self setSelected:YES];
    self.btnCellTap.hidden = NO;
    if ([self.superview.superview.nextResponder isKindOfClass:[ExpertiseGalleryViewController class]]) {
        [(ExpertiseGalleryViewController *)self.superview.superview.nextResponder OnTapCellSelected:gestureRecognizer];
    }
}
@end
