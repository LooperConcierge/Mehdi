//
//  NewsroomCell.h
//  Looper
//
//  Created by hardik on 2/15/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommunityListModel.h"

@protocol NewsroomCellDelegate <NSObject>

-(void)commentPressed:(CommunityListModel *)commentModel;
-(void)showMorePressed:(CommunityListModel *)commentModel;


@end


@interface NewsroomCell : UITableViewCell
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lblHeightConstant;
@property (strong, nonatomic) IBOutlet UIImageView *imgProfile;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) IBOutlet UILabel *lblCity;
@property (strong, nonatomic) IBOutlet UILabel *lblDescription;
@property (strong, nonatomic) IBOutlet UIView *viewBackground;
@property (strong, nonatomic) IBOutlet UIButton *btnComment;

@property (strong, nonatomic) IBOutlet UIView *viewBackGroundImage;

@property (weak,nonatomic) id<NewsroomCellDelegate>delegate;

@property (strong,nonatomic) CommunityListModel *commentModel;
@property (strong, nonatomic) IBOutlet UIButton *btnDownArrow;

@end
