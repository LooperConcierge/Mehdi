//
//  CommentCell.m
//  Looper
//
//  Created by hardik on 3/26/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "CommentCell.h"
#import "UIFont+CustomFont.h"
#import "LooperUtility.h"
#import "UIImageView+AFNetworking.h"

@implementation CommentCell
@synthesize lblMessage,lblName,lblTime,imgProfile,commentDict;

- (void)awakeFromNib {

    lblTime.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_SMALL_SIZE_10];
    lblName.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_MEDIUM_SIZE];
    lblMessage.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_NORMAL_SIZE];
    [LooperUtility roundUIImageView:imgProfile];

    // Initialization code
}

-(void)setCommentDict:(NSDictionary *)commentDict1
{
    commentDict = commentDict1;
    lblName.text = commentDict[@"vFullName"];
    lblTime.text = commentDict[@"created_format_date"];
    lblMessage.text = commentDict[@"tComments"];
    [imgProfile setImageWithURL:[NSURL URLWithString:commentDict[@"vProfilePic"]] placeholderImage:[UIImage imageNamed:@"LooperRegister"]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
