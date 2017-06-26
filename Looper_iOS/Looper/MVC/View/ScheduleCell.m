//
//  ScheduleCell.m
//  LeftRightContententScrollview
//
//  Created by hardik on 1/11/17.
//  Copyright © 2017 rakesh. All rights reserved.
//

#import "ScheduleCell.h"
#import "ShareDataDetails.h"
#import "UIFont+CustomFont.h"

@implementation ScheduleCell
@synthesize lblLeftViewTitle,lblRightViewTitle,lblLeftDescription,lblRightViewDescription,viewRight,viewLeft,objData,viewLeftRating,viewRightRate,btnCheckBox;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
    lblLeftViewTitle.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_HEADER_LARGE_SIZE - 1];
    lblRightViewTitle.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_HEADER_LARGE_SIZE - 1];
    lblLeftViewTitle.textColor = [UIColor whiteColor];
    lblRightViewTitle.textColor = [UIColor whiteColor];
    lblLeftDescription.textColor = [UIColor lightTextColor];
    lblRightViewDescription.textColor = [UIColor lightTextColor];
    lblLeftDescription.font = [UIFont fontAvenirMediumWithSize:FONT_SMALL_SIZE];
    lblRightViewDescription.font = [UIFont fontAvenirMediumWithSize:FONT_SMALL_SIZE];
    [self layoutIfNeeded];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setObjData:(DataModel *)objData1
{
    objData = objData1;
    
    if (objData.displaLeftSide)
    {
        viewLeft.hidden = FALSE;
        viewRight.hidden = TRUE;
    }
    else
    {
        viewRight.hidden = FALSE;
        viewLeft.hidden = TRUE;
    }
    
    //    NSArray *arrContent = obj.arrContent;

}

-(void)createCornerRadius:(UIView *)assignView
{
    [self layoutIfNeeded];
    UIBezierPath *maskPath = [UIBezierPath
                              bezierPathWithRoundedRect:assignView.bounds
                              byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)
                              cornerRadii:CGSizeMake(10, 10)
                              ];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    
    maskLayer.frame = assignView.bounds;
    maskLayer.path = maskPath.CGPath;
    
    assignView.layer.mask = maskLayer;
    
}

-(void)removeCornerRadius:(UIView *)assignView
{
    [self layoutIfNeeded];
    UIBezierPath *maskPath = [UIBezierPath
                              bezierPathWithRoundedRect:assignView.bounds
                              byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)
                              cornerRadii:CGSizeMake(0, 0)
                              ];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    
    maskLayer.frame = assignView.bounds;
    maskLayer.path = maskPath.CGPath;
    
    assignView.layer.mask = maskLayer;
    
}

-(void)dottedLine
{
    UIBezierPath * path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(3, 10.0)];
//    [path addLineToPoint:CGPointMake(0.0, self.bounds.size.height)];
    [path addLineToPoint:CGPointMake(3, self.bounds.size.height)];
    
    [path strokeWithBlendMode:kCGBlendModeNormal alpha:1];
    [path setLineWidth:3.0];
    CGFloat dashes[] = { path.lineWidth * 0, path.lineWidth * 4 };
    [path setLineDash:dashes count:2 phase:0];
    [path setLineCapStyle:kCGLineCapRound];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(10, self.bounds.size.height), false, 2);
    [path fill];
//    [[UIColor redColor] setFill];
    [[UIColor lightGrayColor] setStroke];
    [path stroke];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *mi = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width/2 -3, 0, 10, self.bounds.size.height)];
    mi.image = image;
    
    UIView *imContent = [[UIView alloc]initWithFrame:mi.frame];
    imContent.backgroundColor= [UIColor clearColor];
    UIImageView *imView = [[UIImageView alloc] initWithImage:image];
    [imContent addSubview:imView];
    imContent.tag = 2000;
    [self.contentView addSubview:imContent];
    [self.contentView bringSubviewToFront:btnCheckBox];
//    [self.contentView addSubview:[[UIImageView alloc] initWithImage:image]];
    
}

-(void)setRatings:(CGFloat)rate
{
    //    viewRating.delegate = self;
    
    
    if (objData.displaLeftSide)
    {
        viewLeftRating.emptySelectedImage = [UIImage imageNamed:@"starEmpty"];
        viewLeftRating.fullSelectedImage = [UIImage imageNamed:@"starFull"];
        viewLeftRating.contentMode = UIViewContentModeScaleAspectFill;
        viewLeftRating.maxRating = 5;
        viewLeftRating.minRating = 1;
        viewLeftRating.rating = rate;
        viewLeftRating.editable = NO;
        viewLeftRating.halfRatings = YES;
        viewLeftRating.floatRatings = NO;
    }
    else
    {
        viewRightRate.emptySelectedImage = [UIImage imageNamed:@"starEmpty"];
        viewRightRate.fullSelectedImage = [UIImage imageNamed:@"starFull"];
        viewRightRate.contentMode = UIViewContentModeScaleAspectFill;
        viewRightRate.maxRating = 5;
        viewRightRate.minRating = 1;
        viewRightRate.rating = rate;
        viewRightRate.editable = NO;
        viewRightRate.halfRatings = YES;
        viewRightRate.floatRatings = NO;
    }
}

@end
