//
//  NewsroomCell.m
//  Looper
//
//  Created by hardik on 2/15/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "NewsroomCell.h"
#import "LooperUtility.h"
#import "UIColor+CustomColor.h"
#import "UIFont+CustomFont.h"
#import "NewsroomVC.h"
#import "UIImageView+AFNetworking.h"

@implementation NewsroomCell
@synthesize imgProfile,viewBackGroundImage,lblDescription,lblCity,lblName,lblTime,viewBackground,btnComment,delegate,commentModel;

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
    [LooperUtility roundUIImageView:imgProfile];
    [LooperUtility roundUIViewWithTransparentBackground:viewBackGroundImage];
    viewBackground.backgroundColor = [UIColor darkShadeGrayBackgroundColor];
    lblCity.font = [UIFont fontAvenirWithSize:FONT_SMALL_SIZE];
    lblName.font = [UIFont fontAvenirHeavyWithSize:FONT_MEDIUM_SIZE];
    lblDescription.font = [UIFont fontAvenirWithSize:FONT_SMALL_SIZE];
    lblTime.font = [UIFont fontAvenirWithSize:FONT_SMALL_SIZE];
    btnComment.titleLabel.font = [UIFont fontAvenirWithSize:FONT_NORMAL_SIZE];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCommentModel:(CommunityListModel *)commentModel1
{
    commentModel = commentModel1;
    lblCity.text = [NSString stringWithFormat:@"%@, %@",commentModel.vCity,commentModel.vState];
    lblName.text = [NSString stringWithFormat:@"%@",commentModel.vFullName];
    [imgProfile setImageWithURL:[NSURL URLWithString:commentModel.vProfilePic] placeholderImage:[UIImage imageNamed:@"LooperRegister"]];
    lblTime.text = commentModel.created_format_date;
    lblDescription.text = commentModel.vQuestion;
    _btnDownArrow.hidden = true;
    if (lblDescription.text.length > 40)
    {
        _btnDownArrow.hidden = false;
    }
    _btnDownArrow.imageView.image = [_btnDownArrow.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_btnDownArrow.imageView setTintColor:[UIColor darkGrayColor]];
    
    btnComment.imageView.image = [btnComment.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [btnComment.imageView setTintColor:[LooperUtility sharedInstance].appThemeColor];
    [btnComment setTitle:[NSString stringWithFormat:@"%@ Comment",commentModel.iTotalComments] forState:UIControlStateNormal];
}

- (IBAction)btnCommentPressed:(id)sender
{
    [delegate commentPressed:commentModel];
}

- (IBAction)btnDownArrowPressed:(id)sender
{
    [delegate showMorePressed:commentModel];
}

@end
