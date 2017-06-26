//
//  GeneralAboutView.h
//  Looper
//
//  Created by rakesh on 1/24/17.
//  Copyright © 2017 rakesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TripRequestListModel.h"

@protocol GeneralAboutViewDelegate <NSObject>

-(void)removeView:(BOOL)isDone;

-(void)messageBtnPressed;


@end

@interface GeneralAboutView : UIView

@property (weak,nonatomic) id <GeneralAboutViewDelegate> delegate;

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) IBOutlet UIImageView *imgBackground;
@property (strong, nonatomic) IBOutlet UIView *viewProfileLayer;
@property (strong, nonatomic) IBOutlet UITextField *lblName;
@property (strong, nonatomic) IBOutlet UIImageView *imgProfile;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UILabel *lblParty;
@property (strong, nonatomic) IBOutlet UILabel *lblRate;

@property (strong, nonatomic) NSString *totalDays;

@property (strong, nonatomic) IBOutlet UIButton *btnViewtrip;
@property (strong, nonatomic) IBOutlet TripRequestListModel *tripRequestModel;

- (IBAction)btnViewTripPressed:(id)sender;
- (IBAction)btnMessagePressed:(id)sender;

@end
