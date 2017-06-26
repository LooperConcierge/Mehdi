//
//  TripScheduleHeader.m
//  Looper
//
//  Created by hardik on 4/12/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "TripScheduleHeader.h"

@implementation TripScheduleHeader
@synthesize  dict,lblDay,btnAdd,btnCheckbox,delegate,isEdit;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDict:(NSDictionary *)dict1
{
    dict = dict1;
        
    btnCheckbox.hidden = TRUE;
    
    if (isEdit)
        btnAdd.hidden = TRUE;
    else
        btnAdd.hidden = FALSE;
    
    NSString *dayStr = [dict valueForKey:@"dTravellingDate"];
    lblDay.text = dayStr;
    
}

- (IBAction)btnCheckboxPressed:(id)sender {
    [delegate btnCheckBoxPressed:dict sender:sender];
}

- (IBAction)btnAddpressed:(id)sender
{
    [delegate btnAddPressed:dict sender:dict];
}

@end
