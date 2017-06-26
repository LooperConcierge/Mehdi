//
//  MessagingCell.h
//  Looper
//
//  Created by hardik on 3/22/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessagingCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) IBOutlet UIImageView *imgProfile;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblDescription;
@property (strong, nonatomic) NSDictionary *chatDictionary;

@end
