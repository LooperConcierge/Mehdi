//
//  CommentCell.h
//  Looper
//
//  Created by hardik on 3/26/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgProfile;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblMessage;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) NSDictionary *commentDict;

@end
