//
//  TravellerDetailViewController.m
//  Looper
//
//  Created by Meera Dave on 03/02/16.
//  Copyright © 2016 looper. All rights reserved.
//
#import "TravellerDetailViewController.h"
#import "UIImageView+ExtraFuction.h"
#import "ExpertiseCollectionViewCell.h"
#import "InterestDetailListingViewController.h"
#import "DateCell.h"
#import "TripDetailModelList.h"
#import "UIImageView+AFNetworking.h"

@interface TravellerDetailViewController () {
    __weak IBOutlet UIImageView *imgTraveller;
    __weak IBOutlet UIImageView *imgTravellerBackground;
    __weak IBOutlet UICollectionView *collectionVwIntreset;
    __weak IBOutlet UIButton *btnAddFood;
    __weak IBOutlet UILabel *lblTravelerName;
    __weak IBOutlet UILabel *lblTravelerAddress;
    __weak IBOutlet UICollectionView *collectionViewDate;
    __weak IBOutlet UILabel *lblTripDuration;
    __weak IBOutlet UILabel *lblTripSchedule;
    __weak IBOutlet UILabel *lblSelectDay;
    PassionModel *selectedInterestDict;
    TripDetailModelList *modelObj;
    NSMutableDictionary *dictParam;
    NSString *strSelectDate;
}

@end

@implementation TravellerDetailViewController
@synthesize tripModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareView];

    // Do any additional setup after loading the view.
}

-(void)prepareView
{
//    collectionViewDate.delegate = nil;
//    collectionViewDate.dataSource = nil;
//    collectionVwIntreset.delegate = nil;
//    collectionVwIntreset.dataSource = nil;
    
    strSelectDate = @"";
//    arrIntrest=[NSMutableArray new];
//    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"ExpertiseList" ofType:@"plist"];
//    NSDictionary * values=[[NSDictionary alloc] initWithContentsOfFile:plistPath];
//    NSArray *arrayValues=[[NSArray alloc] initWithArray:[values valueForKey:@"arrItem"]];
//    [arrIntrest setArray:arrayValues];
    
//    [self SetUI];
    
    [[ServiceHandler sharedInstance].looperWebService processLooperTripDetailWithTripID:[NSString stringWithFormat:@"%d",tripModel.iTripID] SuccessBlock:^(NSDictionary *response)
     {
         NSError *error;
         modelObj = [[TripDetailModelList alloc] initWithDictionary:response error:&error];
         DebugLog(@"TRIP MODEL %@",modelObj);
         
         [self SetUI];
     } errorBlock:^(NSError *error)
     {
         
     }];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Custom Method

-(void)SetUI {

//    [collectionVwIntreset registerNib:[UINib nibWithNibName:@"ExpertiseCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ExpertiseCell"];

//    [];
//    [imgTravellerBackground setImageToBlur:imgTravellerBackground.image blurRadius:8 completionBlock:^{
//        DebugLog(@"The blurred image has been set");
//    }];

    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    lblSelectDay.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_NORMAL_SIZE];
    lblTripSchedule.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_NORMAL_SIZE];
    lblTripDuration.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_NORMAL_SIZE];
    lblTripSchedule.textColor = [UIColor lightGrayColor];
    [imgTraveller setCornerRadiusWithBorder:2.0f color:[UIColor lightGrayColor]];
    
    if (modelObj != nil)
    {
//        arrIntrest = [[NSMutableArray alloc] initWithArray:[LooperUtility expertiseArray:modelObj.iExpertiseID]];
        [imgTraveller setImageWithURL:[NSURL URLWithString:modelObj.vProfilePic] placeholderImage:[UIImage imageNamed:@"TravellerRegister"]];
        
        __block UIImageView *tempImage = imgTravellerBackground;
        
        NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:modelObj.vProfilePic]];
        [imgTravellerBackground setImageWithURLRequest:req placeholderImage:[UIImage imageNamed:@"TravellerRegister"] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image)
        {
            [tempImage setImageToBlur:image blurRadius:8 completionBlock:^{
                DebugLog(@"The blurred image has been set");
            }];
        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error)
        {
            
        }];
        lblTravelerAddress.font = [UIFont fontAvenirHeavyWithSize:14];
        lblTravelerName.text = modelObj.vFullName;
//        lblTravelerAddress.text = [NSString stringWithFormat:@"%@,%@",modelObj.vCity,modelObj.vState];
//        arrIntrest = [[NSMutableArray alloc] initWithArray:[LooperUtility expertiseArrayFromArray:modelObj.iExpertiseID]];
        lblTravelerAddress.text = [NSString stringWithFormat:@"%@",modelObj.vCity];
        lblTripDuration.text = [NSString stringWithFormat:@"%@ To %@",[LooperUtility convertServerDateToAppString:modelObj.dDepartureDate],[LooperUtility convertServerDateToAppString:modelObj.dArrivalDate]];
        
        [collectionViewDate reloadData];
        [collectionVwIntreset reloadData];
    }
    [btnAddFood setTitle:@"SELECT PASSION" forState:UIControlStateNormal];
}

#pragma mark - CollectionView Delegate & Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (collectionView == collectionVwIntreset)
    {
        return [modelObj.iExpertiseIDs count];
    }
    else
    {
        return [modelObj.date_list count];
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == collectionVwIntreset)
    {
        static NSString *cellID = @"ExpertiseCell";
        ExpertiseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
        cell.isSingleTouch=YES;

        PassionModel *passion = [[PassionModel alloc] initWithDictionary:[modelObj.iExpertiseIDs objectAtIndex:indexPath.row] error:nil];
        
        [cell setValueOfCell:passion SetSingleTouch:YES];
//        if ([selectedInterestDict[@"name"] isEqualToString:[arrIntrest objectAtIndex:indexPath.row][@"name"]])
        if ([selectedInterestDict.vName isEqualToString:passion.vName])
        {
            [cell setSelected:YES];
        }
        else
            [cell setSelected:NO];
        
        return cell;
        
    }
    else
    {
        static NSString *cellID = @"SelectDateCellID";
        DateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
        [cell setSelected:NO];
        
        if (modelObj != nil)
        {
            NSString *strDate = [modelObj.date_list objectAtIndex:indexPath.row];
//            cell.lblDate.text = [LooperUtility convertServerDateToAppString:strDate];
            cell.lblDate.text = [NSString stringWithFormat:@"Day %ld",(long)indexPath.row + 1];
        }
        
        return cell;
    }

}

//- (CGSize)collectionView:(UICollectionView *)collectionView
//                  layout:(UICollectionViewLayout *)collectionViewLayout
//  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//    float widthCollectionCell;
//    
//    if (collectionView == collectionVwIntreset)
//    {
//        if (_IS_IPHONE_5) {
//            widthCollectionCell = (collectionView.frame.size.width/3 -10);
//            return CGSizeMake(widthCollectionCell,widthCollectionCell-5);
//        } else {
//            widthCollectionCell = (collectionView.frame.size.width/3-10);
//            return CGSizeMake(widthCollectionCell,widthCollectionCell-10);
//        }
//    }
//    else
//    {
//        widthCollectionCell = (collectionView.frame.size.width/3 -10);
//        return CGSizeMake(widthCollectionCell, 25);
//    }
//}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    float widthCollectionCell;
    if (collectionView == collectionVwIntreset)
    {
        widthCollectionCell = (collectionView.frame.size.width/3 - 10);
        return CGSizeMake(widthCollectionCell,widthCollectionCell);
    }
    else
    {
        widthCollectionCell = (collectionView.frame.size.width/3);
        return CGSizeMake(widthCollectionCell,collectionView.frame.size.height/2);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"indexPath select >>%@",indexPath);
    if (collectionView == collectionVwIntreset)
    {
//        selectedInterestDict = [[NSMutableDictionary alloc] initWithDictionary:[arrIntrest objectAtIndex:indexPath.row]];
        selectedInterestDict = [[PassionModel alloc] initWithDictionary:[modelObj.iExpertiseIDs objectAtIndex:indexPath.row] error:nil];
//        NSArray * arrData = [[NSArray alloc] initWithArray:[LooperUtility expertiseArray:@[@{@"iExpertiseID" : selectedInterestDict.iExpertiseID}]]];
        
        dictParam = @{@"expertiseID" : selectedInterestDict.iExpertiseID,
                      @"imgName" : @"",
                      @"name" : selectedInterestDict.vName,
                      @"selected" : selectedInterestDict.isSelected,
                      @"yelpCategory" : selectedInterestDict.vName}.mutableCopy;
        
        [btnAddFood setTitle:[NSString stringWithFormat:@"ADD %@",[selectedInterestDict.vName uppercaseString]] forState:UIControlStateNormal];
    }
    else
    {
        DateCell *cell = (DateCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [cell setSelected:YES];
        NSString *strDate = [modelObj.date_list objectAtIndex:indexPath.row];
        strSelectDate = strDate;
        
    }
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
   
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"indexPath Deselect >>%@",indexPath);
    
    if (collectionView == collectionVwIntreset)
    {
     
    }
    else
    {
        
    }
}

#pragma mark - IBAction Method

-(IBAction)OnTapAddInterest:(id)sender
{
    if (selectedInterestDict == nil)
    {
        [AJNotificationView showNoticeInView:AppdelegateObject.window type:AJNotificationTypeRed title:@"Please select a passion" linedBackground:AJLinedBackgroundTypeDisabled hideAfter:2.5];
        return;
    }
    else if ([strSelectDate isEqualToString:@""])
    {
        [AJNotificationView showNoticeInView:AppdelegateObject.window type:AJNotificationTypeRed title:@"Please select a day" linedBackground:AJLinedBackgroundTypeDisabled hideAfter:2.5];
        return;
    }

    
    [dictParam setObject:strSelectDate forKey:@"selectedDate"];
    [self performSegueWithIdentifier:@"segueInterestDetail" sender:nil];
    
//    InterestDetailListingViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"InterestDetailListingViewController"];
//    [self.navigationController pushViewController:controller animated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    segueInterestDetail
    if ([segue.identifier isEqualToString:@"segueInterestDetail"])
    {
        InterestDetailListingViewController *vc = segue.destinationViewController;
        vc.selectedCategory = dictParam;
        vc.tripModel = modelObj;
        self.hidesBottomBarWhenPushed = NO;
    }
}

@end
