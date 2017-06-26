//
//  TableHeaderCell.m
//  LeftRightContententScrollview
//
//  Created by hardik on 1/11/17.
//  Copyright © 2017 rakesh. All rights reserved.
//

#import "TableHeaderCell.h"
#import "UIFont+CustomFont.h"

@implementation TableHeaderCell
@synthesize viewRightInner,viewLeftInner,viewRight,viewLeft,lblViewLeftTitle,lblViewRightTitle,objModel,delegate,bgView;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    lblViewLeftTitle.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_HEADER_LARGE_SIZE - 1];
    lblViewRightTitle.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_HEADER_LARGE_SIZE - 1];
    lblViewRightTitle.textColor = [UIColor whiteColor];
    lblViewLeftTitle.textColor = [UIColor whiteColor];
    [self layoutIfNeeded]; // Needed if want to have frame proper
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    
}


-(void)setObjModel:(DataModel *)objModel1
{
    objModel = objModel1;
    if (self.objModel.displaLeftSide)
    {
        viewLeft.hidden = FALSE;
        viewRight.hidden = TRUE;
        viewLeftInner.backgroundColor = [UIColor colorWithRed:1 green:0.2980 blue:0.3490 alpha:1];
        viewRightInner.backgroundColor = [UIColor whiteColor];
        lblViewLeftTitle.text = self.objModel.strHeaderTitle;
//        [self createCornerRadius:viewLeft];
    }
    else
    {
        viewLeft.hidden = TRUE;
        viewRight.hidden = FALSE;
        viewLeftInner.backgroundColor = [UIColor whiteColor];
        viewRightInner.backgroundColor = [UIColor colorWithRed:1 green:0.2980 blue:0.3490 alpha:1];
        lblViewRightTitle.text = self.objModel.strHeaderTitle;
//        [self createCornerRadius:viewRight];
    }
}


-(void)createCornerRadius:(UIView *)assignView
{
    [self layoutIfNeeded];
    UIBezierPath *maskPath = [UIBezierPath
                              bezierPathWithRoundedRect:assignView.bounds
                              byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                              cornerRadii:CGSizeMake(10, 10)
                              ];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    
    maskLayer.frame = assignView.bounds;
    maskLayer.path = maskPath.CGPath;
    
    assignView.layer.mask = maskLayer;
}

- (IBAction)btnEditPressed:(id)sender
{
    [self.delegate btnDonePressed:objModel];
}

-(void)dottedLine
{
    [self layoutIfNeeded];
    UIBezierPath * path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(3, 10.0)];
    //    [path addLineToPoint:CGPointMake(0.0, self.bounds.size.height)];
    [path addLineToPoint:CGPointMake(3, bgView.bounds.size.height)];
    
    [path strokeWithBlendMode:kCGBlendModeNormal alpha:1];
    [path setLineWidth:3.0];
    CGFloat dashes[] = { path.lineWidth * 0, path.lineWidth * 4 };
    [path setLineDash:dashes count:2 phase:0];
    [path setLineCapStyle:kCGLineCapRound];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(10, bgView.bounds.size.height), false, 2);
    [path fill];
    //    [[UIColor redColor] setFill];
    [[UIColor lightGrayColor] setStroke];
    [path stroke];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *mi = [[UIImageView alloc] initWithFrame:CGRectMake(bgView.bounds.size.width/2 -3, 0, 10, bgView.bounds.size.height)];
    mi.image = image;
    
    UIView *imContent = [[UIView alloc]initWithFrame:mi.frame];
    imContent.backgroundColor= [UIColor clearColor];
    UIImageView *imView = [[UIImageView alloc] initWithImage:image];
    [imContent addSubview:imView];
    [self.bgView addSubview:imContent];
    
    //    [self.contentView addSubview:[[UIImageView alloc] initWithImage:image]];
    
}

@end
