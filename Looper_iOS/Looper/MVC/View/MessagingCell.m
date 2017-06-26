//
//  MessagingCell.m
//  Looper
//
//  Created by hardik on 3/22/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "MessagingCell.h"
#import "UIFont+CustomFont.h"
#import "LooperUtility.h"
#import "ChatParticipants.h"
#import "Messages.h"
#import "UIImageView+AFNetworking.h"
#import <DateTools/DateTools.h>

@implementation MessagingCell
@synthesize  lblDescription,lblName,lblTime,imgProfile,chatDictionary;

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    lblTime.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_SMALL_SIZE];
    lblName.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_NORMAL_SIZE];
    lblDescription.font = [UIFont fontAvenirNextCondensedRegularWithSize:FONT_SMALL_SIZE];
    [LooperUtility roundUIImageView:imgProfile];
    lblDescription.text=@"Lorem ipsum simplyLorem ipsum simplyLorem ipsum simplyLorem ipsum simplyLorem ipsum simplyLorem ipsum simplyLorem ipsum simplyLorem ipsum simplyLorem ipsum simply";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setChatDictionary:(NSDictionary *)chatDictionary1
{
    chatDictionary = chatDictionary1;
    
    NSTimeInterval timeInt = [chatDictionary[@"msgtime"] doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInt/1000];
    NSString *dateStr = [date timeAgoSinceNow];
    
    lblTime.text = dateStr;
    
    lblDescription.text = chatDictionary[@"msg"];
//    lblTime.text = [];
    lblName.text = chatDictionary[@"name"];
    [imgProfile setImageWithURL:[NSURL URLWithString:chatDictionary[@"photo"]]];
    lblTime.text = dateStr;
}
@end
