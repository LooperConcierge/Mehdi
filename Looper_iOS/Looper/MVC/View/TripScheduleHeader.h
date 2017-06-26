//
//  TripScheduleHeader.h
//  Looper
//
//  Created by hardik on 4/12/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TripScheduleHeaderDelegate <NSObject>

-(void)btnAddPressed:(NSDictionary *)dict sender:(id)sender;

-(void)btnCheckBoxPressed:(NSDictionary *)dict sender:(id)sender;

@end

@interface TripScheduleHeader : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblDay;
@property (strong, nonatomic) NSDictionary *dict;
@property (strong, nonatomic) IBOutlet UIButton *btnCheckbox;
@property (strong, nonatomic) IBOutlet UIButton *btnAdd;
@property  BOOL isEdit;
@property (strong, nonatomic) id<TripScheduleHeaderDelegate> delegate;
//@property (strong, nonatomic) IBOutlet UIButton *btnAdd;

@end
