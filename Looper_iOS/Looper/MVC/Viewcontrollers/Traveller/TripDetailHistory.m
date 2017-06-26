//
//  TripDetailHistory.m
//  Looper
//
//  Created by hardik on 3/22/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "TripDetailHistory.h"
#import "StepSlider.h"
#import "TravellerCalendarCell.h"
#import "TravellerCalendarHeaderView.h"
#import "UIImageView+AFNetworking.h"
#import "PayNowVC.h"
#import "GeneralAboutView.h"
#import "ChatVC.h"
#import "DataModel.h"
#import "ShareDataDetails.h"
#import "ScheduleCell.h"
#import "TableHeaderCell.h"
#import "PaymentVC.h"

#import "BusinessDetailVC.h"


#import "KLCPopup.h"
#import "RatingView.h"

@interface TripDetailHistory ()<TravellerCellDelegate,GeneralAboutViewDelegate,RatingViewDelegate>
{
    NSMutableArray *arrData;
    NSMutableArray *arrContains;
    NSDictionary *dictLooper;
    BOOL isEdit;
    GeneralAboutView *aboutView;
    NSString *strProfilePic;
    NSString *buttonLabel;
    NSString *paymentMessage;
    
    NSMutableArray *arrCollectionViewData;
    NSMutableArray *globalArray;
    NSMutableArray *selectedData;
    NSString *dateForDay;

    IBOutlet NSLayoutConstraint *bottomSpace;
    KLCPopup *pop;
    RatingView *viewwRating;
    IBOutlet NSLayoutConstraint *tblBottomSpace;
    BOOL isFromActivityDetail;
}

@property (strong, nonatomic) IBOutlet UITableView *tblTravelerSchedule;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIView *viewPlaningRemaining;



@property (strong, nonatomic) IBOutlet UIButton *btnEdit;
@property (strong, nonatomic) IBOutlet UIView *viewRequest;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *viewRequestConstHeight;
@end

@implementation TripDetailHistory
@synthesize navTitle,btnEdit,tripModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareView];
    // Do any additional setup after loading the view.
}

-(void)prepareView
{
    buttonLabel = @"";
    paymentMessage = @"";
    self.title = [NSString stringWithFormat:@"%@ Trip", tripModel.vCity];
    selectedData = [[NSMutableArray alloc] init];
    
    _tblTravelerSchedule.rowHeight = UITableViewAutomaticDimension;
    _tblTravelerSchedule.estimatedRowHeight = 100;
    navTitle = [NSString stringWithFormat:@"%@ Trip", tripModel.vCity];
//    self.navigationController.navigationBar.topItem.title = navTitle;
    self.viewRequestConstHeight.constant = 0;
    self.btnEdit.titleLabel.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_MEDIUM_SIZE];
    
    isFromActivityDetail = false;
    
    if(self.isUpcomignTrip)
    {
//        self.btnEdit.hidden = FALSE;
        self.btnEdit.hidden = true;
        isEdit = TRUE;
        self.viewRequestConstHeight.constant = 50;
    }
    else
    {
//        self.btnEdit.hidden = TRUE;
        tblBottomSpace.constant = 0;
        [self.btnEdit setTitle:@"" forState:UIControlStateNormal];
        [self.btnEdit setImage:[UIImage imageNamed:@"starFull"] forState:UIControlStateNormal];
    }
   
    
    
//    viewwRating = [[[NSBundle mainBundle] loadNibNamed:@"RatingView" owner:self options:nil] lastObject];
//    viewwRating.delegate = self;
//    pop = [KLCPopup popupWithContentView:viewwRating showType:KLCPopupShowTypeBounceInFromTop dismissType:KLCPopupDismissTypeBounceOutToBottom maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
//
//    viewwRating.frame = self.view.frame;
//    [pop showAtCenter:self.view.center inView:self.view];
}

-(void)callWS
{
    [[ServiceHandler sharedInstance].looperWebService processTravellerDetailWithTripID:[NSString stringWithFormat:@"%d",tripModel.iTripID] iTravellerID:@"" dTravellingDate:@"" dArrivalDate:tripModel.dArrivalDate dDepartureDate:tripModel.dDepartureDate SuccessBlock:^(NSDictionary *response)
     {
         
         tripModel.vFullName = [NSString stringWithFormat:@"%@",response[@"vFullName"]];
         tripModel.vProfilePic = [NSString stringWithFormat:@"%@",response[@"vProfilePic"]];
         tripModel.iRate = [NSString stringWithFormat:@"%@",response[@"iTripCharge"]];
         strProfilePic = [NSString stringWithFormat:@"%@",response[@"vProfilePic"]];
         buttonLabel = [NSString stringWithFormat:@"%@",response[@"BUTTON_LABEL"]];
         paymentMessage = [NSString stringWithFormat:@"%@",response[@"PAYMENT_MESSAGE"]];
         
         
         dictLooper = @{@"iLooperID" : response[@"iLooperID"],
                        @"iTripID" : [NSString stringWithFormat:@"%d",tripModel.iTripID],
                        @"vFullName" : response[@"vFullName"],
                        @"vProfilePic" : response[@"vProfilePic"],
                        @"iTripCharge" : response[@"iTripCharge"],
                        @"looperCharge" : response[@"looper_charge"],
                        @"serviceFees" : response[@"service_fees"]
                        };
         
         
         globalArray = [[NSMutableArray alloc] initWithArray:response[@"TRIP_DATA"]];
         [self processData:response[@"TRIP_DATA"] selectedDate:@""];
        
         
         NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
         [dateFormatter setDateFormat:@"HH.mm"];
         NSString *strCurrentTime = [dateFormatter stringFromDate:[NSDate date]];
//         2017-03-04
         dateFormatter.dateFormat = @"yyyy-MM-dd";
         NSString *strCurrentDate = [dateFormatter stringFromDate:[NSDate date]];
         NSString *lastDayString = [arrCollectionViewData lastObject];
         
         if ([buttonLabel isEqualToString:@"VIEW TRIP"])
         {
             if ([strCurrentTime floatValue] >= 17.00 && [strCurrentDate isEqualToString:lastDayString] == true  && [tripModel.iRating floatValue] == 0)
             {
                 NSLog(@"It's night time");
                 [LooperUtility createOkAndCancelAlertWithTitle:@"Looper" message:@"Do you want to rate Looper" style:UIAlertControllerStyleAlert controller:self actionHandler:^(UIAlertAction *action)
                 {
                     if ([action.title isEqualToString:@"OK"])
                     {
                         [self openRatingView];
                     }
                     else
                     {
                         
                     }
                 }];
             }
             else
             {
                 if (isFromActivityDetail == false)
                 {
                    [self openAboutView];
                 }
                 isFromActivityDetail = false;
            }
         }
         else
         {
             if (isFromActivityDetail == false)
             {
                 [self openAboutView];
             }
             isFromActivityDetail = false;
         }
     } errorBlock:^(NSError *error)
     {
         
     }];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [self callWS];
//    [super viewWillAppear:animated];
//    
//    if ([buttonLabel  isEqualToString: @"AWAITING ACCEPTANCE"])
//    {
//        [self openAboutViewLooper];
//    }
//    else if ([buttonLabel isEqualToString:@"FINISH BOOKING"])
//    {
//        [self openAboutViewLooper];
//    }
//    else if ([buttonLabel isEqualToString:@"VIEW TRIP"])
//    {
//
//    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)processData:(NSArray *)processData selectedDate:(NSString *)date
{
    
    
    arrCollectionViewData = [processData valueForKey:@"dTravellingDate"];
    
    arrData = [[NSMutableArray alloc] init];
    
    DataModel *shareObj = [[DataModel alloc] init];
    shareObj.displaLeftSide = YES;
    shareObj.strHeaderTitle = @"Morning";
    
    DataModel *shareObj1 = [[DataModel alloc] init];
    shareObj1.displaLeftSide = NO;
    shareObj1.strHeaderTitle = @"Afternoon";
    
    DataModel *shareObj2 = [[DataModel alloc] init];
    shareObj2.displaLeftSide = YES;
    shareObj2.strHeaderTitle = @"Evening";
    
    if ([date isEqualToString:@""])
    {
        date = [arrCollectionViewData objectAtIndex:0];
        dateForDay = date;
    }
    NSPredicate *findDataForDate = [NSPredicate predicateWithFormat:@"dTravellingDate == %@",date];
    NSArray *dataArray = [processData filteredArrayUsingPredicate:findDataForDate];
    
    if (dataArray.count > 0)
    {
        NSArray *tempDataArray = [dataArray lastObject][data];
        NSPredicate *morningPred = [NSPredicate predicateWithFormat:@"iScheduleZone == '1'"];
        NSArray *arrMorning = [tempDataArray filteredArrayUsingPredicate:morningPred];
        
        morningPred = [NSPredicate predicateWithFormat:@"iScheduleZone == '2'"];
        NSArray *arrAfternoon = [tempDataArray filteredArrayUsingPredicate:morningPred];
        
        morningPred = [NSPredicate predicateWithFormat:@"iScheduleZone == '3'"];
        NSArray *arrEvening = [tempDataArray filteredArrayUsingPredicate:morningPred];
        
        
        for (NSDictionary *dict in arrMorning)
        {
            ShareDataDetails *shareDetailsObj = [[ShareDataDetails alloc] initWithDictionary:dict error:nil];
            
            [shareObj.arrContent addObject:shareDetailsObj];
        }
        
        for (NSDictionary *dict in arrAfternoon)
        {
            ShareDataDetails *shareDetailsObj = [[ShareDataDetails alloc] initWithDictionary:dict error:nil];
            
            [shareObj1.arrContent addObject:shareDetailsObj];
        }
        
        for (NSDictionary *dict in arrEvening)
        {
            ShareDataDetails *shareDetailsObj = [[ShareDataDetails alloc] initWithDictionary:dict error:nil];
            
            [shareObj2.arrContent addObject:shareDetailsObj];
        }
        
        if (arrMorning.count > 0)
        {
            [arrData addObject:shareObj];
        }
        if (arrAfternoon.count > 0)
        {
            [arrData addObject:shareObj1];
        }
        if (arrEvening.count > 0)
        {
            [arrData addObject:shareObj2];
        }
    }
    
    if (arrData.count > 0)
    {
        _tblTravelerSchedule.tableFooterView = nil;
    }
    else
    {
        _tblTravelerSchedule.tableFooterView = _viewPlaningRemaining;
    }
    //
    
    [_tblTravelerSchedule reloadData];
    [_collectionView reloadData];
}


/*

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSDictionary *dict = [arrData objectAtIndex:section];
    
    return [[dict valueForKey:@"DATA"] count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [arrData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellID = @"TravellerCalendarCellID";
    TravellerCalendarCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    if (isEdit)
    {
        cell.isEdit = TRUE;
    }
    else
    {
        cell.isEdit = FALSE;
    }
    
    cell.delegate = self;
    
    NSDictionary *dict = [arrData objectAtIndex:indexPath.section];
    
    NSArray *arr = [dict valueForKey:@"DATA"];
    
    NSDictionary *dict1 = [arr objectAtIndex:indexPath.row];
    
    cell.dictTrip = dict1;
    
    if (arr.count-1 == indexPath.row)
    {
        cell.lblLeftSeperator.hidden = TRUE;
    }
    
    if ([arrContains containsObject:dict1])
    {
        cell.btnCheckBox.selected = TRUE;
    }
    else
    {
        cell.btnCheckBox.selected = FALSE;
    }
    return cell;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *cellID = @"TripHeaderID";
    
    TravellerCalendarHeaderView *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    NSDictionary *trip = [arrData objectAtIndex:section];
    cell.dictHeader = trip;
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    // Detemine if it's in editing mode
    //    if (self.tableView.editing)
    //    {
    //        return UITableViewCellEditingStyleDelete;
    //    }
    
    return UITableViewCellEditingStyleNone;
}

*/

#pragma mark -

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    DataModel *obj = [arrData objectAtIndex:section];
    
    return [obj.arrContent count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [arrData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellID = @"ScheduleCellID";
    ScheduleCell *cell  = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    DataModel *obj = [arrData objectAtIndex:indexPath.section];
    
    
    cell.imgExelLeft.hidden = true;
    cell.imgExelRight.hidden = true;
    
    if (obj.arrContent >0)
    {
        ShareDataDetails *sharObj = [obj.arrContent objectAtIndex:indexPath.row];
        if (obj.displaLeftSide)
        {
            cell.lblLeftViewTitle.text = sharObj.vPlaceName;
//            cell.lblLeftDescription.text = sharObj.vPlaceAddress;
            cell.lblLeftDescription.text = sharObj.tDescription;
            
            if ([sharObj.isEdit intValue] == true)
            {
                cell.imgExelRight.hidden = false;
            }
            [cell.btnLeftBusiness addTarget:self action:@selector(btnLeftBusinessPressed:) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            cell.lblRightViewTitle.text = sharObj.vPlaceName;
//            cell.lblRightViewDescription.text = sharObj.vPlaceAddress;
            cell.lblRightViewDescription.text = sharObj.tDescription;
            if ([sharObj.isEdit intValue] == true)
            {
                cell.imgExelLeft.hidden = false;
            }
            [cell.btnRightBusiness addTarget:self action:@selector(btnRightBusinessPressed:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        
        [cell.btnCheckBox addTarget:self action:@selector(btnScheduleCellCheckboxPressed:) forControlEvents:UIControlEventTouchUpInside];
        if ([selectedData containsObject:sharObj])
        {
            cell.btnCheckBox.selected = true;
        }
        else
        {
            cell.btnCheckBox.selected = false;
        }
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    if (isEdit)
    {
        DataModel *obj = [arrData objectAtIndex:indexPath.section];
        ShareDataDetails *shD = [obj.arrContent objectAtIndex:indexPath.row];
        
        if ([selectedData containsObject:shD])
        {
            [selectedData removeObject:shD];
        }
        else
        {
            [selectedData addObject:shD];
        }
        [tableView reloadData];
    }
     */
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    
    
    NSString *cellID = @"TableHeaderID1";
    
    TableHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    cell.contentView.frame = CGRectMake(0, 0, tableView.frame.size.width, cell.frame.size.height);
    
    DataModel *obj = [arrData objectAtIndex:section];
    
    cell.objModel = obj;
    
    [cell dottedLine];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DataModel *obj = [arrData objectAtIndex:indexPath.section];
    
    ScheduleCell *cellSchedule = (ScheduleCell *)cell;
    
    UIView *dottedView = [cellSchedule.contentView viewWithTag:2000];
    [dottedView removeFromSuperview];
    
    [cellSchedule dottedLine];
    
    cellSchedule.objData = obj;
    
    if (obj.arrContent >0)
    {
        ShareDataDetails *sharObj = [obj.arrContent objectAtIndex:indexPath.row];
        if (obj.displaLeftSide)
        {
            cellSchedule.lblLeftViewTitle.text = sharObj.vPlaceName;
//            cellSchedule.lblLeftDescription.text = sharObj.vPlaceAddress;
            cellSchedule.lblLeftDescription.text = sharObj.tDescription;
        }
        else
        {
            cellSchedule.lblRightViewTitle.text = sharObj.vPlaceName;
//            cellSchedule.lblRightViewDescription.text = sharObj.vPlaceAddress;
            cellSchedule.lblRightViewDescription.text = sharObj.tDescription;
        }
        [cellSchedule setRatings:[sharObj.iRating floatValue]];
        cellSchedule.lblLeft.hidden = false;
        cellSchedule.lblRight.hidden = false;
        
        [cellSchedule removeCornerRadius:cellSchedule.viewRight];
        [cellSchedule removeCornerRadius:cellSchedule.viewLeft];
        
        if(indexPath.row == obj.arrContent.count - 1){
            //this is the last row in section.
            NSLog(@"Index -- %ld section %ld",(long)indexPath.row,(long)indexPath.section);
            cellSchedule.lblLeft.hidden = true;
            cellSchedule.lblRight.hidden = true;
            
            [cellSchedule createCornerRadius:cellSchedule.viewRight];
            [cellSchedule createCornerRadius:cellSchedule.viewLeft];
        }
    }
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    TableHeaderCell *cell = (TableHeaderCell *)view;
    cell.delegate = self;
    DataModel *obj = [arrData objectAtIndex:section];
    if (obj.displaLeftSide)
    {
        [cell createCornerRadius:cell.viewLeft];
    }
    else
    {
        [cell createCornerRadius:cell.viewRight];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //    if (isCurrentTripRunning)
    //    {
    //        return  0;
    //    }
    return 40;
}


-(void)btnLeftBusinessPressed:(UIButton *)btn
{
    CGPoint touchPoint = [btn convertPoint:CGPointZero toView:_tblTravelerSchedule]; // maintable --> replace your tableview name
    NSIndexPath *clickedButtonIndexPath = [_tblTravelerSchedule indexPathForRowAtPoint:touchPoint];
    
    
    DataModel *obj = [arrData objectAtIndex:clickedButtonIndexPath.section];
    if (obj.arrContent >0)
    {
        ShareDataDetails *sharObj = [obj.arrContent objectAtIndex:clickedButtonIndexPath.row];
        isFromActivityDetail = true;
        UIStoryboard *st = [UIStoryboard storyboardWithName:@"Looper" bundle:nil];
        BusinessDetailVC *mainViewController = [st instantiateViewControllerWithIdentifier:@"BusinessDetailVCID"];
        mainViewController.businessID = sharObj.yelpPlaceID;
        mainViewController.notes = sharObj.tDescription;
        [self.navigationController pushViewController:mainViewController animated:true];
    }
    
}


-(void)btnRightBusinessPressed:(UIButton *)btn
{
    CGPoint touchPoint = [btn convertPoint:CGPointZero toView:_tblTravelerSchedule]; // maintable --> replace your tableview name
    NSIndexPath *clickedButtonIndexPath = [_tblTravelerSchedule indexPathForRowAtPoint:touchPoint];
    
    DataModel *obj = [arrData objectAtIndex:clickedButtonIndexPath.section];
    if (obj.arrContent >0)
    {
        ShareDataDetails *sharObj = [obj.arrContent objectAtIndex:clickedButtonIndexPath.row];
        isFromActivityDetail = true;
        UIStoryboard *st = [UIStoryboard storyboardWithName:@"Looper" bundle:nil];
        BusinessDetailVC *mainViewController = [st instantiateViewControllerWithIdentifier:@"BusinessDetailVCID"];
        mainViewController.businessID = sharObj.yelpPlaceID;
        mainViewController.notes = sharObj.tDescription;
        [self.navigationController pushViewController:mainViewController animated:true];
    }
}


-(void)btnScheduleCellCheckboxPressed:(UIButton *)btn
{
    CGPoint touchPoint = [btn convertPoint:CGPointZero toView:_tblTravelerSchedule]; // maintable --> replace your tableview name
    NSIndexPath *clickedButtonIndexPath = [_tblTravelerSchedule indexPathForRowAtPoint:touchPoint];
    
    DataModel *obj = [arrData objectAtIndex:clickedButtonIndexPath.section];
    if (obj.arrContent >0)
    {
        if (isEdit)
        {
            DataModel *obj = [arrData objectAtIndex:clickedButtonIndexPath.section];
            ShareDataDetails *shD = [obj.arrContent objectAtIndex:clickedButtonIndexPath.row];
            
            if ([selectedData containsObject:shD])
            {
                [selectedData removeObject:shD];
            }
            else
            {
                [selectedData addObject:shD];
            }
            [_tblTravelerSchedule reloadData];
        }
    }
}

#pragma mark - collection method

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [arrCollectionViewData count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cellID";
    
    NSString *date = [arrCollectionViewData objectAtIndex:indexPath.row];
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    UILabel *lblDay = (UILabel *)[cell.contentView viewWithTag:100];
    lblDay.text = [NSString stringWithFormat:@"%@ %ld", @"Day",(long)indexPath.row + 1];
    lblDay.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_HEADER_SIZE];
    lblDay.textColor = [UIColor whiteColor];
    if ([date isEqualToString:dateForDay])
    {
        lblDay.textColor = [LooperUtility sharedInstance].appThemeColor;
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    float widthCollectionCell = (collectionView.frame.size.width/3 - 10);
    
    return CGSizeMake(widthCollectionCell,50);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *date = [arrCollectionViewData objectAtIndex:indexPath.row];
    dateForDay = date;
    [self processData:globalArray selectedDate:date];
}


- (IBAction)btnEditPressed:(id)sender
{
    if (_isUpcomignTrip)
    {
        
        UIButton *btn = (UIButton *)sender;
        if (!btn.selected)
        {
            btn.selected = TRUE;
            isEdit = TRUE;
            [btn setTitle:@"Done" forState:UIControlStateNormal];
            [UIView animateWithDuration:2 animations:^{
                self.viewRequestConstHeight.constant = 50;
            }];
        }
        else
        {
            btn.selected = FALSE;
            isEdit = FALSE;
            [btn setTitle:@"Edit" forState:UIControlStateNormal];
            self.viewRequestConstHeight.constant = 0;
        }
        [_tblTravelerSchedule reloadData];
    }
    else
    {
        [self openRatingView];
    }
}

-(void)openRatingView
{
    viewwRating = [[[NSBundle mainBundle] loadNibNamed:@"RatingView" owner:self options:nil] lastObject];
    viewwRating.delegate = self;
    pop = [KLCPopup popupWithContentView:viewwRating showType:KLCPopupShowTypeGrowIn dismissType:KLCPopupDismissTypeShrinkOut maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
    
    viewwRating.frame = self.view.frame;
    [viewwRating setRatings:[tripModel.iRating floatValue]];
    [pop showAtCenter:self.view.center inView:self.view];
}

- (IBAction)btnRequestPressed:(id)sender
{
    if (selectedData.count == 0)
    {
        
        [AJNotificationView showNoticeInView:AppdelegateObject.window type:AJNotificationTypeRed title:@"Please select item to change" linedBackground:AJLinedBackgroundTypeDisabled hideAfter:1.5];
    }
    else
    {
        NSArray *iTravellerTripIDs = [selectedData valueForKey:@"iTravellerTripID"];
        NSString *strId = [iTravellerTripIDs componentsJoinedByString:@","];
//        for (NSDictionary *dict in arrContains)
//        {
            [[ServiceHandler sharedInstance].travelerWebService processRequestToChangeWithTripID:strId successBlock:^(NSDictionary *response)
             {
                 
             } errorBlock:^(NSError *error)
             {
                 
             }];
//        }
    }
}

- (IBAction)btnProgressPressed:(id)sender
{
    [self performSegueWithIdentifier:@"seguePayNow" sender:nil];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"seguePayNow"])
    {
        PayNowVC *vc = segue.destinationViewController;
        vc.strTripID = dictLooper[@"iTripID"];
        vc.strLooperID = dictLooper[@"iLooperID"];
    }
    else if ([segue.identifier isEqualToString:@"seguePayment"])
    {
        PaymentVC *vc = segue.destinationViewController;
        vc.looperDict = dictLooper;
        vc.reqObj = tripModel;
        vc.tripCharge = [dictLooper[@"looperCharge"] floatValue];
        vc.serviceCharge = [dictLooper[@"serviceFees"] floatValue];
        
//        vc.priceForTrip = [arrCollectionViewData count] * (float)tripModel.iRate;
    }
    
}



-(void)openAboutView
{
    UserModel *user = [LooperUtility getCurrentUser];
    if (user == nil)
    {
        [LooperUtility createAlertWithTitle:@"LOOPER" message:keyLoginFirst style:UIAlertControllerStyleAlert controller:self actionHandler:^(UIAlertAction *action) {
//            [LooperUtility navigateToLoginScreen:self.navigationController];
             [LooperUtility openLoginScreen];
        }];
        return;
    }
    
    [self openAboutViewLooper];
    
}

-(void)viewDismiss
{
    [pop dismiss:YES];
}

-(void)submitRating:(CGFloat)rate
{
    NSDictionary *param = @{@"iLooperID": [NSString stringWithFormat:@"%@",dictLooper[@"iLooperID"]],
                            @"iRating" : [NSString stringWithFormat:@"%f",rate],
                            @"iTripID" : [NSString stringWithFormat:@"%@",dictLooper[@"iTripID"]]
                            };
    
    [[ServiceHandler  sharedInstance].travelerWebService processRateLooper:param SuccessBlock:^(NSDictionary *response)
    {
        if ([response[success] intValue] == 1)
        {
//            [LooperUtility createAlertWithTitle:@"Looper" message:response[data][@"MESSAGE"] style:UIAlertControllerStyleAlert controller:self actionHandler:^(UIAlertAction *action) {
//                
//            }];
        }
        else
        {
            [LooperUtility createAlertWithTitle:@"Looper" message:response[@"MESSAGE"] style:UIAlertControllerStyleAlert controller:self actionHandler:^(UIAlertAction *action) {
                
            }];
        }
    } errorBlock:^(NSError *error)
    {
        
    }];
    [pop dismiss:YES];
}

-(void)openAboutViewLooper
{
    
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    
    aboutView = [[[NSBundle mainBundle] loadNibNamed:@"GeneralAboutView" owner:self options:nil] lastObject];
    
    //    looperView.frame = window.frame;
    //    if (looperDetailObj == nil)
    //        looperView.looperAllModel = looperDetailObjAll;
    //    else
    
    aboutView.tripRequestModel = tripModel;

    aboutView.lblDate.text = [NSString stringWithFormat:@"%@  (Total days %lu)",[LooperUtility convertServerDateDesireAppString:tripModel.dBookingDate dateFormat:@"MMM dd, yyyy"],(unsigned long)[arrCollectionViewData count]];
    [aboutView.btnViewtrip setTitle:buttonLabel forState:UIControlStateNormal];
    aboutView.delegate = self;
    aboutView.image = [LooperUtility screenshotOfWholeScreen];
    [aboutView drawRect:window.frame];
    
    aboutView.center = window.center;
    [window insertSubview:aboutView aboveSubview:self.view];
    [window bringSubviewToFront:aboutView];
    
    
}

-(void)removeView:(BOOL)isDone
{

    if (isDone)//close button pressed
    {
        [aboutView removeFromSuperview];
        [self.navigationController popViewControllerAnimated:true];
    }
    else
    {
        if ([buttonLabel  isEqualToString: @"AWAITING ACCEPTANCE"])
        {
            
        }
        else if ([buttonLabel isEqualToString:@"FINISH BOOKING"])
        {
            if (![paymentMessage isEqualToString:@""])
            {
                [aboutView removeFromSuperview];
                [LooperUtility createAlertWithTitle:@"Looper" message:paymentMessage style:UIAlertControllerStyleAlert controller:self actionHandler:^(UIAlertAction *action)
                {
                    [self openAboutViewLooper];
                }];
            }
            else
            {
                [aboutView removeFromSuperview];
                [self performSegueWithIdentifier:@"seguePayment" sender:nil];
            }
        }
        else if ([buttonLabel isEqualToString:@"VIEW TRIP"])
        {
            [aboutView removeFromSuperview];
    //        [self.navigationController popViewControllerAnimated:true];
        }
    }
}

-(void)messageBtnPressed
{
    [aboutView removeFromSuperview];
    [self openChatWithTraveler];
}

-(void)openChatWithTraveler
{
    UserModel *userObj = [LooperUtility getCurrentUser];
    MessageClass *message = [[MessageClass alloc] init];
    message.strMembers = @"";
    message.strReciverId = [NSString stringWithFormat:@"%@",dictLooper[@"iLooperID"]];
    message.strSenderId = [NSString stringWithFormat:@"%d",userObj.iUserID];
    message.strSenderName = userObj.vFullName;
    message.strMsgType = @"text";
    message.strReciverName = dictLooper[@"vFullName"];
    message.urlReciverPhoto = [NSURL URLWithString:[NSString stringWithFormat:@"%@",dictLooper[@"vProfilePic"]]];
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    double milisecond = time * 1000;
    ChatVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatVC"];
    vc.messageObj = message;
    vc.strlastTime = milisecond;
    [self.navigationController pushViewController:vc animated:YES];

    /*
    NSDictionary *currentUser = [[DatabaseManager sharedInstance] getCurrentUser];
    
    NSString *emailStr = [NSString stringWithFormat:@"%@%@",tripModel.vEmail,currentUser[@"uEmail"]];
    
    NSString * messagePath = [FBManagerSharedInstance sortStringAlphabatically:emailStr];
    
    NSDictionary *dict = @{@"uEmail" : tripModel.vEmail,@"uName":tripModel.vFullName,@"profilePic":strProfilePic};
    
    ChatVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatVC"];
    vc.otherUser = dict;
    vc.messagePath = messagePath;
    
    [self.navigationController pushViewController:vc animated:YES];
     */
}
@end
