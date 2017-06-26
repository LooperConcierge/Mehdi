//
//  TravelerTripVC.m
//  Looper
//
//  Created by hardik on 2/15/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "TravelerTripVC.h"
#import "TravelerTripCell.h"
#import "TripScheduleHeader.h"
#import "KLCPopup.h"
#import "UIImageView+AFNetworking.h"
#import "TravellerDetailViewController.h"
#import "GeneralAboutView.h"
#import "ChatVC.h"
#import "DataModel.h"
#import "ShareDataDetails.h"
#import "ScheduleCell.h"
#import "TableHeaderCell.h"
#import "BusinessDetailVC.h"

@interface TravelerTripVC ()<UITableViewDataSource,UITableViewDelegate,TripScheduleHeaderDelegate,TravelerTripCellDelegate,GeneralAboutViewDelegate,TableHeaderCellDelegate>
{
    BOOL isEdit;
    CGPoint lastContentOffset;
    NSMutableArray *arrData;
//    NSMutableArray *arrContains;
    KLCPopup *pop;
    GeneralAboutView *aboutView;
    NSMutableArray *arrCollectionViewData;
    NSMutableArray *selectedData;
    NSMutableArray *globalArray;
    NSString *dateForDay;
    NSString *buttonLabel;
    BOOL isActivityAdd;
    NSIndexPath *businessIndexPath;
}
@property (strong, nonatomic) IBOutlet UIView *viewPlaningRemaining;
@property (strong, nonatomic) IBOutlet UITableView *tblTravelerSchedule;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) IBOutlet UIImageView *imgProfile;
@property (strong, nonatomic) IBOutlet UIImageView *imgBackgroundProfile;
@property (strong, nonatomic) IBOutlet UILabel *lblTravelerName;

@property (strong, nonatomic) IBOutlet UIView *viewHeader;
@property (strong, nonatomic) IBOutlet UITableView *tblTraveler;
@property (strong, nonatomic) IBOutlet UIView *viewBackGround;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *viewConstHeight;
@property (strong, nonatomic) IBOutlet UIView *viewBottom;

@property (strong, nonatomic) IBOutlet UIButton *btnDelete;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableTopConst;
@property (strong, nonatomic) IBOutlet UIView *viewFooter;
@property (strong, nonatomic) IBOutlet UIView *viewAddDay;
@property (strong, nonatomic) IBOutlet UIButton *btnSelectDate;

@end

@implementation TravelerTripVC
@synthesize imgProfile,imgBackgroundProfile,lblTravelerName,tblTraveler,viewHeader,viewFooter,requestModel,isUpcomingTrip;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareView];
    // Do any additional setup after loading the view.
}


-(void)prepareView
{
    isActivityAdd = false;
    
    arrData = [[NSMutableArray alloc] init];
    selectedData = [[NSMutableArray alloc] init];
    tblTraveler.rowHeight = UITableViewAutomaticDimension;
    tblTraveler.estimatedRowHeight = 160.0;
    _tblTravelerSchedule.rowHeight = UITableViewAutomaticDimension;
    _tblTravelerSchedule.estimatedRowHeight = 100.0;
    
    tblTraveler.tableHeaderView = viewHeader;
    tblTraveler.tableFooterView = viewFooter;
    [LooperUtility roundUIImageView:imgProfile];
    [LooperUtility roundUIViewWithTransparentBackground:self.viewBackGround];
    [imgBackgroundProfile setImageToBlur:imgBackgroundProfile.image blurRadius:8 completionBlock:^{
        DebugLog(@"The blurred image has been set");
    }];
    self.viewConstHeight.constant = 0;
    self.viewBottom.hidden = TRUE;

    
    
    
    if (isUpcomingTrip)
    {
//        [self addRightBarItem];
//        isEdit = FALSE;
        isEdit = true;
        self.viewBottom.hidden = FALSE;
        self.viewConstHeight.constant = 40;
    }
    else
    {
        
    }
    
}

-(void)fetchTripDetailWS
{
    [[ServiceHandler sharedInstance].looperWebService processTravellerDetailWithTripID:[NSString stringWithFormat:@"%d",requestModel.iTripID] iTravellerID:@"" dTravellingDate:@"" dArrivalDate:requestModel.dArrivalDate dDepartureDate:requestModel.dDepartureDate SuccessBlock:^(NSDictionary *response)
     {
         lblTravelerName.text = response[@"vFullName"];
         [imgProfile setImageWithURL:[NSURL URLWithString:response[@"vProfilePic"]]];
         
         __block UIImageView *tempImageView = imgBackgroundProfile;
         NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:response[@"vProfilePic"]]];
         
         [imgBackgroundProfile setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image)
         {
             tempImageView.image = image;
             [tempImageView setImageToBlur:tempImageView.image blurRadius:8 completionBlock:^{
                 
             }];
             
         } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error)
         {
             
         }];
         
//         [self createDataArray:response];
         buttonLabel = [NSString stringWithFormat:@"%@",response[@"BUTTON_LABEL"]];
         
         requestModel.vProfilePic = response[@"vProfilePic"];
         requestModel.iRate = response[@"iTripCharge"];
         globalArray = [[NSMutableArray alloc] initWithArray:response[@"TRIP_DATA"]];
                  [self processData:response[@"TRIP_DATA"] selectedDate:@""];
         if (isActivityAdd == false)
         {
             [self openAboutView];
         }
         
     } errorBlock:^(NSError *error)
     {
         
     }];
}

-(void)createDataArray:(NSDictionary *)response
{
    arrData = [[NSMutableArray alloc] initWithArray:response[@"TRIP_DATA"]];
    [tblTraveler reloadData];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self fetchTripDetailWS];
//    self.navigationController.hidesBarsOnSwipe = TRUE;
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//     self.navigationController.hidesBarsOnSwipe = NO;
}

-(void)addRightBarItem
{
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setTitle:@"Edit" forState:UIControlStateNormal];
    [btnBack setTitle:@"Done" forState:UIControlStateSelected];
    btnBack.frame = CGRectMake(0, 0, 70, 25);
    
    [btnBack addTarget:self action:@selector(btnRightPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:btnBack] ;
    
    self.navigationItem.rightBarButtonItem = backButton;
    
}

-(IBAction)btnRightPressed:(UIButton *)sender
{
     isActivityAdd = true;
    if (sender.selected == TRUE)
    {
        self.viewBottom.hidden = TRUE;
        self.viewConstHeight.constant = 0;
        sender.selected = FALSE;
        isEdit = FALSE;
        [_tblTravelerSchedule reloadData];
//        [tblTraveler reloadData];
//       tblTraveler.tableFooterView = self.viewFooter;
    }
    else
    {
        self.viewBottom.hidden = FALSE;
        self.viewConstHeight.constant = 40;
        sender.selected = TRUE;
        isEdit = TRUE;
        [_tblTravelerSchedule reloadData];
//        [tblTraveler reloadData];
//        tblTraveler.tableFooterView = nil;
    }

}
/*
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [arrData count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dict = [arrData objectAtIndex:section];
    
    return [[dict valueForKey:@"DATA"] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"TravelerTripCellID";
    
    TravelerTripCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    NSDictionary *dict = [arrData objectAtIndex:indexPath.section];

    NSArray *arr = [dict valueForKey:@"DATA"];
    
    NSDictionary *dict1 = [arr objectAtIndex:indexPath.row];
    cell.delegate = self;
    cell.dictData = dict1;
    
    if ([arrContains containsObject:dict1])
    {
        cell.btnCheckxox.selected = TRUE;
    }
    else
    {
        cell.btnCheckxox.selected = FALSE;
    }
    if (isUpcomingTrip)
    {
        [cell setupUI:isEdit];
    }
    else
    {
         [cell setupUI:FALSE];
    }
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *cellID = @"TripHeaderID";
    NSDictionary *dict = [arrData objectAtIndex:section];
    TripScheduleHeader *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.delegate = self;
    if (isUpcomingTrip)
        cell.isEdit = isEdit;
    else
        cell.isEdit = true;
    
    cell.dict = dict;

    return cell;
}


-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint currentOffset = scrollView.contentOffset;
    if (currentOffset.y > lastContentOffset.y)
    {
        // Downward
//        UIEdgeInsets inset = UIEdgeInsetsMake(44, 0, 0, 0);
//        tblTraveler.contentInset = inset;
//        tblTraveler.scrollIndicatorInsets = inset;
    }
    else
    {
        // Upward
//        UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, 0, 0);
//        tblTraveler.contentInset = inset;
//        tblTraveler.scrollIndicatorInsets = inset;

    }
    lastContentOffset = currentOffset;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{

    if (fromIndexPath != toIndexPath )
    {

    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 46;
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
                cell.lblLeftDescription.text = sharObj.vPlaceAddress;
                cell.lblLeftDescription.text = sharObj.tDescription;
//                cell.lblLeftNotesDesc.text = sharObj.tDescription;
                if ([sharObj.isEdit intValue] == true)
                {
                    cell.imgExelRight.hidden = false;
                }
                [cell.btnLeftBusiness addTarget:self action:@selector(btnLeftBusinessPressed:) forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                cell.lblRightViewTitle.text = sharObj.vPlaceName;
//                cell.lblRightViewDescription.text = sharObj.vPlaceAddress;
                cell.lblRightViewDescription.text = sharObj.tDescription;
//                cell.lblRightNotesDesc.text = sharObj.tDescription;
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
//                cellSchedule.lblLeftDescription.text = sharObj.vPlaceAddress;
                cellSchedule.lblLeftDescription.text = sharObj.tDescription;
            }
            else
            {
                cellSchedule.lblRightViewTitle.text = sharObj.vPlaceName;
//                cellSchedule.lblRightViewDescription.text = sharObj.vPlaceAddress;
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

-(void)btnLeftBusinessPressed:(UIButton *)btn
{
    CGPoint touchPoint = [btn convertPoint:CGPointZero toView:_tblTravelerSchedule]; // maintable --> replace your tableview name
    NSIndexPath *clickedButtonIndexPath = [_tblTravelerSchedule indexPathForRowAtPoint:touchPoint];
    
    DataModel *obj = [arrData objectAtIndex:clickedButtonIndexPath.section];
    if (obj.arrContent >0)
    {
        ShareDataDetails *sharObj = [obj.arrContent objectAtIndex:clickedButtonIndexPath.row];
        isActivityAdd = true;
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
        isActivityAdd = true;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(IBAction)btnAddPressed:(id)sender
//{
//    TravellerDetailViewController *trVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TravellerDetailViewController"];
//    [self.navigationController pushViewController:trVC animated:YES];
//}

- (IBAction)btnAddDaysPressed:(id)sender
{
    self.viewAddDay.layer.cornerRadius = 4;
    self.viewAddDay.layer.masksToBounds = YES;
    pop = [KLCPopup popupWithContentView:self.viewAddDay showType:KLCPopupShowTypeSlideInFromTop dismissType:KLCPopupDismissTypeSlideOutToBottom maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
    
    [pop showAtCenter:self.view.center inView:self.view];
    
}


- (IBAction)btnDonePressed:(id)sender {
    
    
    if (![[_btnSelectDate.titleLabel.text lowercaseString] isEqualToString:@"select date"])
    {
        [self addDayToArray];
    }
    [pop dismiss:YES];
}

-(IBAction)btnSelectDate:(id)sender
{
//    UIButton *btn = (UIButton *)sender;
    NSString *strSelectDate = self.btnSelectDate.titleLabel.text;
    
    if ([[strSelectDate lowercaseString] isEqualToString:@"select date"])
    {
        NSDate *date = [NSDate date];
        NSString *strDate = [LooperUtility stringFromDate:date];
        NSDate *dDate = [LooperUtility dateFromString:strDate];
        
        [[LooperUtility sharedInstance] showActionSheetDatePickerInView:self.view setMinDate:nil setMaxDate:nil selectedDate:dDate doneBlock:^(NSDate *selectedDate)
         {
             [self.btnSelectDate setTitle:[LooperUtility stringFromDate:selectedDate] forState:UIControlStateNormal];
         }];
    }
    else
    {
        NSDate *dateForPicker = [LooperUtility dateFromString:strSelectDate];
        //            [dtPicker setDate:dateForPicker animated:YES];
        [[LooperUtility sharedInstance] showActionSheetDatePickerInView:self.view setMinDate:nil setMaxDate:nil selectedDate:dateForPicker doneBlock:^(NSDate *selectedDate)
         {
             [self.btnSelectDate setTitle:[LooperUtility stringFromDate:selectedDate] forState:UIControlStateNormal];
         }];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma MArk 
-(void)addDayToArray
{
    NSString *stringDay = self.btnSelectDate.titleLabel.text;
    [arrData addObject:@{@"isEdit" :[NSNumber numberWithInteger:1],@"day":stringDay,@"value":@[]}];
    [self.tblTraveler reloadData];
}

-(void)btnCheckBoxPressed:(NSDictionary *)dict sender:(id)sender
{
//    NSIndexPath *cell = [tblTraveler indexPathForCell:(TripScheduleHeader *)[[sender superview] superview]];
//    
//    NSLog(@"INdexpath %ld",(long)cell.row);
}

-(void)btnAddPressed:(NSDictionary *)dict sender:(id)sender
{
        TravellerDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TravellerDetailViewController"];
    
        vc.tripModel = requestModel;
        vc.hidesBottomBarWhenPushed = TRUE;
        [self.navigationController pushViewController:vc animated:YES];

}

-(void)checkBoxIsChecked:(BOOL)isChecked dictData:(NSDictionary *)dictData
{
//    if ([arrContains containsObject:dictData])
//    {
//        [arrContains removeObject:dictData];
//    }
//    else
//    {
//        [arrContains addObject:dictData];
//    }
}

- (IBAction)btnDeletePressed:(id)sender
{
    
    if (selectedData.count == 0)
    {
        [LooperUtility createAlertWithTitle:@"Looper" message:@"Please select an item to delete" style:UIAlertControllerStyleAlert controller:self actionHandler:^(UIAlertAction *action)
        {
            
        }];
    }
    else
    {
        NSString *iTravelerTripIds = [[selectedData valueForKey:@"iTravellerTripID"] componentsJoinedByString:@","];
        
        [[ServiceHandler sharedInstance].looperWebService processDeleteTrips:iTravelerTripIds SuccessBlock:^(NSDictionary *response)
         {
             selectedData = [[NSMutableArray alloc] init];
             [self fetchTripDetailWS];
        } errorBlock:^(NSError *error)
         {
            
        }];
    }
}

-(void)openAboutView
{
//    [self removeView:true];
    
    UserModel *user = [LooperUtility getCurrentUser];
    if (user == nil)
    {
        [LooperUtility createAlertWithTitle:@"LOOPER" message:keyLoginFirst style:UIAlertControllerStyleAlert controller:self actionHandler:^(UIAlertAction *action) {
//            [LooperUtility navigateToLoginScreen:self.navigationController];
             [LooperUtility openLoginScreen];
        }];
        return;
    }
    
    [tblTraveler setContentOffset:CGPointZero animated:YES];
    
    [self openAboutViewTraveler];
    
}

-(void)openAboutViewTraveler
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
        aboutView.tripRequestModel = self.requestModel;

        aboutView.lblDate.text = [NSString stringWithFormat:@"%@  (Total days %lu)",[LooperUtility convertServerDateDesireAppString:self.requestModel.dBookingDate dateFormat:@"MMM dd, yyyy"],(unsigned long)[arrCollectionViewData count]];
        [aboutView.btnViewtrip setTitle:buttonLabel forState:UIControlStateNormal];
        aboutView.delegate = self;
        aboutView.image = [LooperUtility screenshotOfWholeScreen];
        [aboutView drawRect:window.frame];
        
                aboutView.center = window.center;
        [window insertSubview:aboutView aboveSubview:self.view];
        [window bringSubviewToFront:aboutView];

}

-(void)processData:(NSArray *)processData selectedDate:(NSString *)date
{
    tblTraveler.delegate = self;
    tblTraveler.delegate = self;
    
    
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


-(void)removeView:(BOOL)isDone
{
    if (isDone)
    {
        [aboutView removeFromSuperview];
        [self.navigationController popViewControllerAnimated:true];
    }
    else
    {
        if ([[buttonLabel lowercaseString] isEqualToString:[@"AWAITING PAYMENT" lowercaseString]])
        {
            [aboutView removeFromSuperview];
            [self.navigationController popViewControllerAnimated:true];
        }
        else if ([[buttonLabel lowercaseString] isEqualToString:[@"VIEW TRIP" lowercaseString]])
        {
             [aboutView removeFromSuperview];
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
    message.strReciverId = [NSString stringWithFormat:@"%@",requestModel.iTravellerID];
    message.strSenderId = [NSString stringWithFormat:@"%d",userObj.iUserID];
    message.strSenderName = userObj.vFullName;
    message.strMsgType = @"text";
    message.strReciverName = requestModel.vFullName;
    message.urlReciverPhoto = [NSURL URLWithString:[NSString stringWithFormat:@"%@",requestModel.vProfilePic]];
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    double milisecond = time * 1000;
    ChatVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatVC"];
    vc.messageObj = message;
    vc.strlastTime = milisecond;
    [self.navigationController pushViewController:vc animated:YES];

    
    /*
    NSDictionary *currentUser = [[DatabaseManager sharedInstance] getCurrentUser];
    
    NSString *emailStr = [NSString stringWithFormat:@"%@%@",requestModel.vEmail,currentUser[@"uEmail"]];
    
    NSString * messagePath = [FBManagerSharedInstance sortStringAlphabatically:emailStr];
    
    NSDictionary *dict = @{@"uEmail" : requestModel.vEmail,@"uName":requestModel.vFullName,@"profilePic":requestModel.vProfilePic};
    
    ChatVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatVC"];
    vc.otherUser = dict;
    vc.messagePath = messagePath;
    
    [self.navigationController pushViewController:vc animated:YES];
     */
}

- (IBAction)btnAddActivityPressed:(id)sender
{
   
    TravellerDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TravellerDetailViewController"];
    
    vc.tripModel = requestModel;
    vc.hidesBottomBarWhenPushed = TRUE;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
