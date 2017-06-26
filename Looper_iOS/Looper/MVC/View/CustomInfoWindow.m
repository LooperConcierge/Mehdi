//
//  CustomInfoWindow.m
//  Looper
//
//  Created by hardik on 2/9/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "CustomInfoWindow.h"

@implementation CustomInfoWindow

@synthesize customMarkerObj,lblMarkerName;

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
}

-(void)setCustomMarkerObj:(CustomMarker *)customMarkerObj1
{
    customMarkerObj = customMarkerObj1;
    lblMarkerName.text = customMarkerObj.snippet;
    
}



@end
