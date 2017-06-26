//
//  BookLooperVC.m
//  Looper
//
//  Created by hardik on 2/4/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "TravelerCalendarVC.h"
#import "UIScrollView+APParallaxHeader.h"
#import "TripCalendarModel.h"
#import "TripDetailModel.h"
#import "TravellerCalendarCell.h"
#import "TravellerCalendarHeaderView.h"
#import "TravelerNotification.h"
#import "SelectCityMapVC.h"
#import "SelectDateVC.h"
#import "UIImageView+AFNetworking.h"
#import "DataModel.h"
#import "ScheduleCell.h"
#import "ShareDataDetails.h"
#import "TableHeaderCell.h"
#import "Looper-Swift.h"
#import "BusinessDetailVC.h"

@interface TravelerCalendarVC ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,TableHeaderCellDelegate>
{
    CGFloat searchButtonOriginY;
    BOOL isSeachOpen;
    NSMutableArray *arrData;
    NSMutableArray *selectedData;
    NSMutableArray *arrCollectionViewData;
    NSArray *globalArray;
    BOOL isCurrentTripRunning;
    NSString *dateForDay;
}

@property (strong, nonatomic) IBOutlet UITableView *tblTest;
@property (strong, nonatomic) IBOutlet UIView *lblHeader;
@property (strong, nonatomic) IBOutlet UIButton *btnSearch;
//@property (nonatomic, getter=isPseudoEditing) BOOL pseudoEdit;

@property (strong, nonatomic) IBOutlet UIImageView *imgTraveler;
@property (strong, nonatomic) IBOutlet UILabel *lblTravelerName;
@property (strong, nonatomic) IBOutlet UIButton *btnEdit;
@property (strong, nonatomic) IBOutlet UITableView *tblCurrentTrip;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIButton *btnReqestChange;
@property (strong, nonatomic) IBOutlet UIView *viewCurrentTrip;
@property (strong, nonatomic) IBOutlet UIView *viewCurrentTripNoData;

@end

@implementation TravelerCalendarVC
@synthesize imageBackGround,delegate;

- (void)viewDidLoad
{
    
    [super viewDidLoad];

//    [self prepareView];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self prepareView];
    [super viewWillAppear:animated];
    
    if ([LooperUtility sharedInstance].isNoTrip)
    {
        [self notify];
    }
    
    TravelerModel *userTraveller = [LooperUtility getTravelerProfile];
    
    if (userTraveller == nil)
    {
        
        if ([LooperUtility getCurrentUser] != nil)
        {
            [[ServiceHandler sharedInstance].travelerWebService processTravelerProfileWithSuccessBlock:^(NSDictionary *response)
             {
                 NSDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:response[profile]];
                 [dict setValue:response[profile][@"languages"] forKey:@"languages"];
                 
                 NSError *error;
                 TravelerModel *looperProfile = [[TravelerModel alloc] initWithDictionary:dict error:&error];
                 [LooperUtility settingTravelerProfile:looperProfile];
                 [self setTravellerInfo];
             } errorBlock:^(NSError *error)
             {
                 
             }];
            
        }
    }
    else
    {
        [self setTravellerInfo];
    }
    
}

-(void)setTravellerInfo
{
    TravelerModel *userTraveller = [LooperUtility getTravelerProfile];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:userTraveller.vProfilePic]];
    _imgTraveler.contentMode = UIViewContentModeScaleAspectFit;
    UIActivityIndicatorView *activity = (UIActivityIndicatorView *)[self.view viewWithTag:400];
    activity.hidden = false;
    __block UIImageView *tempImageView = _imgTraveler;
    [_imgTraveler setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"TravellerRegister"] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image)
     {
         if (image != nil)
         {
             tempImageView.image = image;
             activity.hidden = true;
//             tempImageView.image = [LooperUtility imageWithImage:image scaledToSize:tempImageView.frame.size];
//             UIImage *resizeImage = [[FirebaseChatManager sharedInstance] resizeImageWithImage:image newWidth:tempImageView.frame.size.width];
//             tempImageView.image = resizeImage;
//             tempImageView.frame = CGRectMake(tempImageView.frame.origin.x, tempImageView.frame.origin.y, resizeImage.size.width, resizeImage.size.height);
         }
         
     } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error)
     {
         
     }];
    //    [_imgTraveler setImageWithURL:[NSURL URLWithString:user.vProfilePic] placeholderImage:[UIImage imageNamed:@"TravellerRegister"]];
    NSArray *arrName = [userTraveller.vFullName componentsSeparatedByString:@" "];
    _lblTravelerName.text = [NSString stringWithFormat:@"Hi, %@",(arrName.count > 0 ? arrName[0] :userTraveller.vFullName)];
    _lblTravelerName.textColor = [UIColor whiteColor];
    
    _btnReqestChange.titleLabel.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_HEADER_LARGE_SIZE];

}
-(void)prepareView
{
    self.parentViewController.navigationController.navigationBarHidden = TRUE;
    selectedData = [[NSMutableArray alloc] init];
    arrCollectionViewData = [[NSMutableArray alloc] init];
    
//    if (_IS_IPHONE_6P)
//    {
        self.lblHeader.frame = CGRectMake(self.lblHeader.frame.origin.x, self.lblHeader.frame.origin.y, _ScreenWidth, _ScreenWidth);
//    }
    arrData = [[NSMutableArray alloc] init];
    isCurrentTripRunning = true;
    self.tblCurrentTrip.dataSource = nil;
    self.tblCurrentTrip.delegate = nil;
    _btnEdit.hidden = TRUE;
    /*
    [[ServiceHandler sharedInstance].travelerWebService processScheduleTripSuccessBlock:^(NSDictionary *resposne)
    {
        if ([resposne[success] intValue] == 1)
        {
            isCurrentTripRunning = false;
            _btnEdit.hidden = false;
            globalArray = resposne[data][0][@"TRIP_DATA"];
            [self processData:globalArray selectedDate:@""];
        }
        else
        {
            isCurrentTripRunning = true;
            self.tblCurrentTrip.dataSource = nil;
            self.tblCurrentTrip.delegate = nil;
            
            arrData = [LooperUtility sharedInstance].arrCity.mutableCopy;
            if (arrData.count == 0)
            {
                [[LooperUtility sharedInstance] getCityActionHandler:^(BOOL status)
                {
                    if (status == true)
                    {
                        TravelerModel *user = [LooperUtility getTravelerProfile];
                        NSArray *arrName = [user.vFullName componentsSeparatedByString:@" "];
                        _lblTravelerName.text = [NSString stringWithFormat:@"Hi, %@",(arrName.count > 0 ? arrName[0] :user.vFullName)];

                        arrData = [LooperUtility sharedInstance].arrCity.mutableCopy;
                        _btnEdit.hidden = TRUE;
                        [self.tblTest reloadData];
                    }
                }];
            }
            
            _btnEdit.hidden = TRUE;
            [self.tblTest reloadData];
        }
    } errorBlock:^(NSError *error)
    {
        
    }];
*/
    arrData = [LooperUtility sharedInstance].arrCity.mutableCopy;
    [self.tblTest reloadData];
//    if (arrData.count == 0)
//    {
//        [[LooperUtility sharedInstance] getCityActionHandler:^(BOOL status)
//         {
//             if (status == true)
//             {
//                 TravelerModel *user = [LooperUtility getTravelerProfile];
//                 NSArray *arrName = [user.vFullName componentsSeparatedByString:@" "];
//                 _lblTravelerName.text = [NSString stringWithFormat:@"Hi, %@",(arrName.count > 0 ? arrName[0] :user.vFullName)];
//                 
//                 arrData = [LooperUtility sharedInstance].arrCity.mutableCopy;
//                 _btnEdit.hidden = TRUE;
//                 [self.tblTest reloadData];
//             }
//         }];
//    }
    [[LooperUtility sharedInstance] getCityActionHandler:^(BOOL status)
     {
         if (status == true)
         {
             TravelerModel *user = [LooperUtility getTravelerProfile];
             NSArray *arrName = [user.vFullName componentsSeparatedByString:@" "];
             _lblTravelerName.text = [NSString stringWithFormat:@"Hi, %@",(arrName.count > 0 ? arrName[0] :user.vFullName)];
             
             arrData = [LooperUtility sharedInstance].arrCity.mutableCopy;
             _btnEdit.hidden = TRUE;
             [self.tblTest reloadData];
         }
     }];
    _btnEdit.hidden = TRUE;
    [self.tblTest reloadData];
    // Setting background dot view //
    self.tblCurrentTrip.rowHeight = UITableViewAutomaticDimension;
    self.tblCurrentTrip.estimatedRowHeight = 97;
    self.tblCurrentTrip.estimatedSectionHeaderHeight = 30;
    
    self.tblTest.rowHeight = UITableViewAutomaticDimension;
    self.tblTest.estimatedRowHeight = 97;
    
    [self.lblHeader setNeedsLayout];
    [self.lblHeader layoutIfNeeded];
    
    [self.view layoutIfNeeded];
        self.tblTest.tableHeaderView.frame = self.lblHeader.frame;
        self.tblTest.tableHeaderView = self.lblHeader;
    self.constTopButtonSearch.constant = (self.lblHeader.frame.size.height-(self.btnSearch.frame.size.height+30)) - self.tblTest.contentOffset.y;
    
    self.btnEdit.titleLabel.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_MEDIUM_SIZE];
    self.btnSearch.layer.cornerRadius = self.btnSearch.frame.size.height/2;
    self.btnSearch.layer.masksToBounds = YES;
    
}

-(void)processData:(NSArray *)processData selectedDate:(NSString *)date
{
    _tblCurrentTrip.delegate = self;
    _collectionView.delegate = self;
    _tblCurrentTrip.dataSource = self;
    _collectionView.dataSource = self;
    
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
    
    if (arrCollectionViewData.count > 0)
    {
        _viewCurrentTrip.hidden = false;
        _tblCurrentTrip.tableFooterView = nil;
    }
    if (arrData.count > 0)
    {
        _viewCurrentTrip.hidden = false;
        _tblCurrentTrip.tableFooterView = nil;
    }
    else
    {
        _tblCurrentTrip.tableFooterView = _viewCurrentTripNoData;
    }
    
    [_tblCurrentTrip reloadData];
    [_collectionView reloadData];
}

-(void)notify
{
    [self btnSearchPressed:nil];
}

-(void)setNavigationBarButton
{
    UIButton *btnBack = [LooperUtility createCloseButton];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"day_afternoon_pink"] forState:UIControlStateNormal];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:btnBack] ;
    self.navigationItem.leftBarButtonItem = backButton;
}

/*
- (void)loadData {
    
    self.tblTest.dataSource =nil;
    self.tblTest.delegate = nil;
    
    arrData = [[NSMutableArray alloc] init];
    
    
    DataModel *shareObj = [[DataModel alloc] init];
    shareObj.displaLeftSide = NO;
    shareObj.strHeaderTitle = @"Title 1";
    
    // 1st view
    ShareDataDetails *shareDetailsObj = [[ShareDataDetails alloc] init];
    shareDetailsObj.intRating = 3;
    shareDetailsObj.strTitle = @"Detail Title 1";
    shareDetailsObj.strDescription = @"dasdasdasdasdasdasdasdasasdasd";
    
    [shareObj.arrContent addObject:shareDetailsObj];
    [arrData addObject:shareObj];
    
    // 2nd view
    DataModel *shareObj1 = [[DataModel alloc] init];
    shareObj1.displaLeftSide = YES;
    shareObj1.strHeaderTitle = @"Title 2";
    
    ShareDataDetails *shareDetailsObj1 = [[ShareDataDetails alloc] init];
    shareDetailsObj1.intRating = 1;
    shareDetailsObj1.strTitle = @"Detail Title 1 Detail Title 1 Detail Title 1 Detail Title 1";
    shareDetailsObj1.strDescription = @"Detail Description 1";
    [shareObj1.arrContent addObject:shareDetailsObj1];
    
    ShareDataDetails *shareDetailsObj2 = [[ShareDataDetails alloc] init];
    shareDetailsObj2.intRating = 4;
    shareDetailsObj2.strTitle = @"Detail Title 2";
    shareDetailsObj2.strDescription = @"Detail Description 2";
    [shareObj1.arrContent addObject:shareDetailsObj2];
    
    [arrData addObject:shareObj1];
    
    
    // 3rd view
    DataModel *shareObj3 = [[DataModel alloc] init];
    shareObj3.displaLeftSide = NO;
    shareObj3.strHeaderTitle = @"Title 3";
    
    ShareDataDetails *shareDetailsObj3 = [[ShareDataDetails alloc] init];
    shareDetailsObj3.intRating = 3;
    shareDetailsObj3.strTitle = @"Detail Title 3";
    shareDetailsObj3.strDescription = @"Detail Description 1 Detail Description 1 Detail Description 1 Detail Description 1 Detail Description 1";
    
    [shareObj3.arrContent addObject:shareDetailsObj3];
    [arrData addObject:shareObj3];
    
    _tblCurrentTrip.rowHeight = UITableViewAutomaticDimension;
    _tblCurrentTrip.estimatedRowHeight = 120;
    _tblCurrentTrip.tableFooterView = nil;
    
    _tblCurrentTrip.sectionHeaderHeight = UITableViewAutomaticDimension;
    _tblCurrentTrip.estimatedSectionHeaderHeight = 25;
    
    // Do any additional setup after loading the view.
    
    [_tblCurrentTrip setBackgroundView:nil];
    //    _tableView.backgroundColor = [UIColor redColor];
    _tblCurrentTrip.backgroundColor = [UIColor colorWithRed:0.1216 green:0.1176 blue:0.1176 alpha:1];
//    _viewCollectionBG.backgroundColor = [UIColor colorWithRed:0.1216 green:0.1176 blue:0.1176 alpha:1];
    [_tblCurrentTrip reloadData];

    
    
}
*/
#pragma mark -

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (isCurrentTripRunning)
//    {
    if (tableView == _tblTest)
    {
        return [arrData count];
    }
    else
    {
        DataModel *obj = [arrData objectAtIndex:section];
        
        return [obj.arrContent count];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    if (isCurrentTripRunning)
//    {
    if (tableView == _tblTest)
    {
        return 1;
    }
    return [arrData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
//    if (isCurrentTripRunning)
//    {
    if (tableView == _tblTest)
    {
        static NSString *cellID = @"popularCity";
        UITableViewCell *tblcell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
        UIImageView *img = [[tblcell contentView] viewWithTag:100];
        UILabel *lbl = [[tblcell contentView] viewWithTag:101];
        NSDictionary *dict = [arrData objectAtIndex:indexPath.row];
//        img.image = [UIImage imageNamed:dict[@"imageName"]];
        [img setImageWithURL:[NSURL URLWithString:dict[@"vImage"]] placeholderImage:[UIImage imageNamed:@"italy"]];
//        lbl.text = dict[@"cityTitle"];
        lbl.text = dict[@"vName"];
        return tblcell;
        
    }
    else
    {
        static NSString *cellID = @"ScheduleCellID";
        ScheduleCell *cell  = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
        
        DataModel *obj = [arrData objectAtIndex:indexPath.section];
    
        
        if (obj.arrContent >0)
        {
            ShareDataDetails *sharObj = [obj.arrContent objectAtIndex:indexPath.row];
            if (obj.displaLeftSide)
            {
                cell.lblLeftViewTitle.text = sharObj.vPlaceName;
//                cell.lblLeftDescription.text = sharObj.vPlaceAddress;
                cell.lblLeftDescription.text = sharObj.tDescription;
                cell.imgExelLeft.hidden = true;
                cell.imgExelRight.hidden = true;
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
                cell.imgExelLeft.hidden = true;
                cell.imgExelRight.hidden = true;
                if ([sharObj.isEdit intValue] == true)
                {
                    cell.imgExelLeft.hidden = false;
                }
                [cell.btnLeftBusiness addTarget:self action:@selector(btnRightBusinessPressed:) forControlEvents:UIControlEventTouchUpInside];
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
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tblTest)
    {
    SelectDateVC *selectDate = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectDateVCID"];
    selectDate.hidesBottomBarWhenPushed = TRUE;
        selectDate.fromController = FROM_CITY_CONTROLLER;
    NSDictionary * paramDictionary = [arrData objectAtIndex:indexPath.row];
    selectDate.paramDictionary = [[NSMutableDictionary alloc] initWithDictionary:@{@"iCityID":paramDictionary[@"id"]}];

    [self.navigationController pushViewController:selectDate animated:YES];
    }
    else
    {
        /*
        if ([self tabBarController].tabBar.hidden)
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
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *cellID = @"TripHeaderID";
    
//    if (isCurrentTripRunning)
//    {
    if (tableView == _tblTest)
    {
        TravellerCalendarHeaderView *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        cell.lblLeftTitle.text = @"Popular cities";
        return cell.contentView;
    }
    else
    {
    
        NSString *cellID = @"TableHeaderID1";
        
        TableHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        
        cell.contentView.frame = CGRectMake(0, 0, tableView.frame.size.width, cell.frame.size.height);
        
        DataModel *obj = [arrData objectAtIndex:section];
        
        cell.objModel = obj;

        [cell dottedLine];
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tblTest)
    {
    }
    else
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
    
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if (tableView == _tblTest)
    {
        
    }
    else
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
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if (isCurrentTripRunning)
//    {
//        return  0;
//    }
    return 40;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//}

//
//- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
//    // Move this assignment to the method/action that
//    // handles table editing for bulk operation.
//    if (!isCurrentTripRunning)
//    {
//        self.pseudoEdit = YES;
//        
//        [super setEditing:editing animated:animated];
//    }
//    
//}
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    // Detemine if it's in editing mode
//    if (self.tableView.editing)
//    {
//        return UITableViewCellEditingStyleDelete;
//    }
    
    return UITableViewCellEditingStyleNone;
}


-(void)btnLeftBusinessPressed:(UIButton *)btn
{
    CGPoint touchPoint = [btn convertPoint:CGPointZero toView:_tblCurrentTrip]; // maintable --> replace your tableview name
    NSIndexPath *clickedButtonIndexPath = [_tblCurrentTrip indexPathForRowAtPoint:touchPoint];
    
    DataModel *obj = [arrData objectAtIndex:clickedButtonIndexPath.section];
    if (obj.arrContent >0)
    {
        ShareDataDetails *sharObj = [obj.arrContent objectAtIndex:clickedButtonIndexPath.row];
        
        UIStoryboard *st = [UIStoryboard storyboardWithName:@"Looper" bundle:nil];
        BusinessDetailVC *mainViewController = [st instantiateViewControllerWithIdentifier:@"BusinessDetailVCID"];
        mainViewController.businessID = sharObj.yelpPlaceID;
        mainViewController.notes = sharObj.tDescription;
        [self.navigationController pushViewController:mainViewController animated:true];
    }
}


-(void)btnRightBusinessPressed:(UIButton *)btn
{
    CGPoint touchPoint = [btn convertPoint:CGPointZero toView:_tblCurrentTrip]; // maintable --> replace your tableview name
    NSIndexPath *clickedButtonIndexPath = [_tblCurrentTrip indexPathForRowAtPoint:touchPoint];
    
    DataModel *obj = [arrData objectAtIndex:clickedButtonIndexPath.section];
    if (obj.arrContent >0)
    {
        ShareDataDetails *sharObj = [obj.arrContent objectAtIndex:clickedButtonIndexPath.row];
        
        UIStoryboard *st = [UIStoryboard storyboardWithName:@"Looper" bundle:nil];
        BusinessDetailVC *mainViewController = [st instantiateViewControllerWithIdentifier:@"BusinessDetailVCID"];
        mainViewController.businessID = sharObj.yelpPlaceID;
        mainViewController.notes = sharObj.tDescription;
        [self.navigationController pushViewController:mainViewController animated:true];
    }
}

-(void)btnScheduleCellCheckboxPressed:(UIButton *)btn
{
    CGPoint touchPoint = [btn convertPoint:CGPointZero toView:_tblCurrentTrip]; // maintable --> replace your tableview name
    NSIndexPath *clickedButtonIndexPath = [_tblCurrentTrip indexPathForRowAtPoint:touchPoint];
    
    DataModel *obj = [arrData objectAtIndex:clickedButtonIndexPath.section];
    if (obj.arrContent >0)
    {
        if ([self tabBarController].tabBar.hidden)
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
            [_tblCurrentTrip reloadData];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (isCurrentTripRunning)
    {
        
    if(!isSeachOpen) {
        self.constTopButtonSearch.constant = (self.lblHeader.frame.size.height-(self.btnSearch.frame.size.height+30)) -scrollView.contentOffset.y;
        [self.view layoutIfNeeded];
    }
    
    if (self.tblTest.contentOffset.y > self.lblHeader.frame.size.height-(self.btnSearch.frame.size.height+30)) {
        // moved up
        
        if (!isSeachOpen) {
            isSeachOpen = TRUE;
            
            [self expandButton:YES WithAnimation:YES];
        }
    } else if (self.tblTest.contentOffset.y < self.lblHeader.frame.size.height-self.btnSearch.frame.size.height+30) {
        // moved down
        
        if (isSeachOpen) {
            isSeachOpen = FALSE;
            
            [self expandButton:NO WithAnimation:YES];
        }
    }
    }
}

- (void)expandButton: (BOOL)expand WithAnimation: (BOOL)animated {
    //    CollectionReusableView *header = (CollectionReusableView *)[_collectionView dequeueReusableSupplementaryViewOfKind: NVBnbCollectionElementKindHeader withReuseIdentifier:@"header" forIndexPath:headerIndex];
    
    NSTimeInterval time = 0;
    CGFloat value = self.lblHeader.frame.size.height-(self.btnSearch.frame.size.height);
    
    if(animated)
        time = 0.2;
    
    [UIView animateWithDuration:time animations:^{
        if(expand) {
            searchButtonOriginY = self.constTopButtonSearch.constant;
            self.constTopButtonSearch.constant = 0;
            
            self.constLeadingButtonSearch.constant = 0.0f;
            self.constWidthButtonSearch.constant = [UIScreen mainScreen].bounds.size.width;
            self.btnSearch.layer.cornerRadius = 0;
            [self.btnSearch setTitle:@"EXPLORE" forState:UIControlStateNormal];
            self.btnSearch.titleLabel.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_MEDIUM_SIZE];
        } else {
            
            self.constTopButtonSearch.constant = searchButtonOriginY;
            
            self.constLeadingButtonSearch.constant = 10.0f;
            self.constWidthButtonSearch.constant = 50.0f;
            self.btnSearch.layer.cornerRadius = self.btnSearch.frame.size.height/2;
            self.btnSearch.layer.masksToBounds = YES;
            [self.btnSearch setTitle:@"" forState:UIControlStateNormal];
        }
        
        
        [self.view layoutIfNeeded];
    }];
}

#pragma mark -
- (IBAction)btnEditPressed:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (!btn.selected)
    {
        self.tblTest.tableHeaderView = nil;
        self.btnSearch.hidden = YES;
//        [self.tblTest setEditing:YES animated:YES];
        btn.selected = TRUE;
        [self tabBarController].tabBar.hidden = TRUE;
        [btn setTitle:@"Done" forState:UIControlStateNormal];
    }
    else
    {
        btn.selected = FALSE;
        self.tblTest.tableHeaderView = self.lblHeader;
        self.btnSearch.hidden = FALSE;
//        [self.tblTest setEditing:NO animated:YES];
        [btn setTitle:@"Edit" forState:UIControlStateNormal];
        [self tabBarController].tabBar.hidden = FALSE;
        self.constTopButtonSearch.constant = (self.lblHeader.frame.size.height-(self.btnSearch.frame.size.height+30)) - self.tblTest.contentOffset.y;
    }
//    [self.tblTest reloadData];
    [self.tblCurrentTrip reloadData];
}


- (IBAction)btnSearchPressed:(id)sender
{
    SelectCityMapVC *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectCityMapVCID"];
    nav.isSkipHide = TRUE;
    [LooperUtility sharedInstance].isNoTrip = FALSE;
    [self.navigationController pushViewController:nav animated:YES];
}

- (IBAction)btnRequestChangePressed:(id)sender
{
    if (selectedData.count == 0)
    {
        
        [AJNotificationView showNoticeInView:AppdelegateObject.window type:AJNotificationTypeRed title:@"Please select item to change" linedBackground:AJLinedBackgroundTypeDisabled hideAfter:1.5];
    }
    else
    {
        NSArray *iTravellerTripIDs = [selectedData valueForKey:@"iTravellerTripID"];
        NSString *strId = [iTravellerTripIDs componentsJoinedByString:@","];
//        for (NSDictionary *dict in selectedData)
//        {
            [[ServiceHandler sharedInstance].travelerWebService processRequestToChangeWithTripID:strId successBlock:^(NSDictionary *response)
             {
                 
             } errorBlock:^(NSError *error)
             {
                 
             }];
//        }
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
#pragma mark tableheadercell delegate 
-(void)btnDonePressed:(DataModel *)dataModelObj
{
    if ([self tabBarController].tabBar.hidden == true)
    {
        if ([selectedData containsObject:dataModelObj])
        {
            [selectedData removeObject:dataModelObj];
        }
        else
        {
            [selectedData addObject:dataModelObj];
        }
        [self.tblCurrentTrip reloadData];
    }
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
}


@end
