//
//  ChatCell.h
//  Looper
//
//  Created by hardik on 3/22/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgLeftBubble;
@property (strong, nonatomic) IBOutlet UILabel *lblDescription;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) IBOutlet UIImageView *imgRightBubble;
@property (strong, nonatomic) IBOutlet UILabel *lblRightTime;
@property (strong, nonatomic) IBOutlet UILabel *lblRightDescription;

@end
