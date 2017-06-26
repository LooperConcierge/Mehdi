//
//  ExpertiseGalleryViewController.h
//  Looper
//
//  Created by Meera Dave on 30/01/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "BaseViewController.h"
#import "BaseNavVC.h"

typedef enum {
    SETTING_PROFILE,
    UPLOAD_DOCUMENT
}FromController;

@protocol ExpertiseGalleryDelegate <NSObject>

@optional
-(void)expertiseArray:(NSArray *)expertiseArray;

@end


@interface ExpertiseGalleryViewController : BaseNavVC

-(IBAction)OnTapCellSelected:(id)sender;
-(IBAction)OnTapCellUnSelected:(id)sender;

@property(nonatomic)FromController isProfileController;
@property (strong, nonatomic) NSMutableArray *arrContainsExpertise;

@property (weak, nonatomic) id <ExpertiseGalleryDelegate> expertiseDelegate;

@end
