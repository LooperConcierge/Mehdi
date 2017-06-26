//
//  CustomInfoWindow.h
//  Looper
//
//  Created by hardik on 2/9/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomMarker.h"

@interface CustomInfoWindow : UIView

@property (strong, nonatomic) IBOutlet UILabel *lblMarkerName;
@property (strong, nonatomic) CustomMarker *customMarkerObj;


@end
