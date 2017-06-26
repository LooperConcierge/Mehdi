//
//  BookLooperView.h
//  Looper
//
//  Created by hardik on 2/4/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+LBBlurredImage.h"
#import "UIImage+ImageEffects.h"
#import "LooperListModel.h"
#import "TripDetailModelList.h"
#import "PlaceModel.h"
@protocol BookLooperViewDelegate <NSObject>

@optional

-(void)removeView:(BOOL)isDone;
-(void)removeViewAndPopToViewController;
-(void)messageBtnPressed;

@end

typedef enum
{
    LOOPER_DETAIL,
    TRAVELER_DETAIL
} FromController;

@interface BookLooperView : UIView
{
    BOOL isSubmitClicked;
}
@property FromController userTyp;
@property (strong,nonatomic) TripDetailModelList *tripModel;// Trip detail 

@property (strong, nonatomic) IBOutlet UIView *viewTextBG;
@property (weak,nonatomic) id <BookLooperViewDelegate> delegate;

@property (strong,nonatomic) NSMutableDictionary *dictLooperBooking;//selected category(interest & date) for which traveler

@property (strong,nonatomic) PlaceModel *placeModel;//For selected place model

@property (strong,nonatomic) LooperObjModel *looperModel;

#pragma Mark - CONFIRMATION VIEW
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) IBOutlet UIImageView *imgBackground;

@property (strong, nonatomic) IBOutlet UIView *viewConfirmation;

@property (strong, nonatomic) IBOutlet UIView *viewProfileLayer;
@property (strong, nonatomic) IBOutlet UIView *viewLooperSchedule;
@property (strong, nonatomic) IBOutlet UIImageView *imgLooeprProfile;

@property (strong, nonatomic) IBOutlet UILabel *lblAfternoon;
@property (strong, nonatomic) IBOutlet UILabel *lblMorning;
@property (strong, nonatomic) IBOutlet UILabel *lblEvening;

@property (strong, nonatomic) IBOutlet UIButton *btnMorning;
@property (strong, nonatomic) IBOutlet UIButton *btnEvening;

@property (strong, nonatomic) IBOutlet UIButton *btnAfternoon;
#pragma MARK - submit party view
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UILabel *lblPartyOf;
@property (strong, nonatomic) IBOutlet UILabel *lblDollarPerDay;

@property (strong, nonatomic) IBOutlet UIView *viewSubmitParty;
//@property (strong, nonatomic) IBOutlet UITextField *lblParty;
@property (strong, nonatomic) IBOutlet UIButton *btnNumberOfPerson;
@property (strong, nonatomic) IBOutlet UIButton *btnPlus;
@property (strong, nonatomic) IBOutlet UIButton *btnMinus;
@property (strong, nonatomic) IBOutlet UIButton *btnSubmit;
@property (strong, nonatomic) IBOutlet UIView *transparencyView;

@property (strong, nonatomic) IBOutlet UIImageView *imgDayMorning;
@property (strong, nonatomic) IBOutlet UIImageView *imgDayAfternoon;
@property (strong, nonatomic) IBOutlet UIImageView *imgDayEvening;
@property (strong, nonatomic) IBOutlet UITextView *txtViewDescription;
@end
