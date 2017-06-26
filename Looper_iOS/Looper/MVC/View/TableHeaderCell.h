//
//  TableHeaderCell.h
//  LeftRightContententScrollview
//
//  Created by hardik on 1/11/17.
//  Copyright © 2017 rakesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"

@protocol TableHeaderCellDelegate <NSObject>

@optional
-(void)btnDonePressed:(DataModel *)dataModelObj;

@end

@interface TableHeaderCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *viewLeft;
@property (strong, nonatomic) IBOutlet UIView *viewRight;
@property (strong, nonatomic) IBOutlet UIView *viewLeftInner;
@property (strong, nonatomic) IBOutlet UIView *viewRightInner;

@property (strong, nonatomic) IBOutlet UILabel *lblViewLeftTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblViewRightTitle;

@property (weak, nonatomic) id<TableHeaderCellDelegate> delegate;

@property (strong, nonatomic) DataModel *objModel;
@property (strong, nonatomic) IBOutlet UIView *bgView;
-(void)createCornerRadius:(UIView *)assignView;
- (IBAction)btnEditPressed:(id)sender;
-(void)dottedLine;
@end
