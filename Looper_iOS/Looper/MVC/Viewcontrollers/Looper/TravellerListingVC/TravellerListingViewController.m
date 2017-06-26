//
//  TravellerListingViewController.m
//  Looper
//
//  Created by Meera Dave on 02/02/16.
//  Copyright © 2016 looper. All rights reserved.
//
#define TRAVELLER_LISTING_IDETIFIER @"TravelleListing"
#import "TravellerListingViewController.h"
#import "TravelleListingTableViewCell.h"
#import "TravellerDetailViewController.h"
#import "TripRequestCell.h"
#import "TravelerTripVC.h"

@interface TravellerListingViewController ()<UITableViewDataSource,UITableViewDelegate,TripRequestCellDelegate>
{
    IBOutlet UIButton *btnHistory;

    __weak IBOutlet UIView *vwLine;
    __weak IBOutlet UITableView *tblListing;
    NSMutableArray *arrData;
    IBOutlet UIView *viewNoRecord;
}

@end

@implementation TravellerListingViewController
@synthesize btnRequest,btnTraveller;

#pragma mark - VIEW LIFE CYCLE

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareView];
    
    //    self.parentViewController.navigationController.navigationBarHidden = TRUE;
    //    self.navigationItem.titleView = self.viewnavTitleBar;
    //    [super hideNavItem];
    // Do any additional setup after loading the view.
}

-(void)prepareView
{
    btnRequest.titleLabel.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_HEADER_SIZE];
    btnTraveller.titleLabel.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_HEADER_SIZE];
    btnHistory.titleLabel.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_HEADER_SIZE];
    //Localization
    [btnRequest setTitle:[[LooperUtility sharedInstance].localization localizedStringForKey:keyRequest] forState:UIControlStateNormal];
    [btnTraveller setTitle:[[LooperUtility sharedInstance].localization localizedStringForKey:keyTraveler] forState:UIControlStateNormal];
    btnTraveller.selected = YES;
    btnRequest.selected = NO;
    
    self.parentViewController.navigationController.navigationBarHidden = TRUE;
    self.navigationController.navigationBar.topItem.title = @"DASHBOARD";
    
    arrData = [[NSMutableArray alloc] init];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (AppdelegateObject.apnsDictionary != nil)
    {
        NSArray *pageNameArr = [[NSArray alloc] initWithArray:AppdelegateObject.apnsDictionary[@"USER_DATA"]];
        NSDictionary *pageDict = [pageNameArr lastObject];
        NSString *pageName = [pageDict valueForKey:@"page_name"];
        AppdelegateObject.apnsDictionary = nil;
        if ([pageName  isEqual: @"new_trip_request"])
        {
            [self onTapBtnRequest:nil];
        }
        else if ([pageName  isEqual: @"payment_receive"] || [pageName  isEqual: @"change_request"])
        {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                btnTraveller.selected = true;
                
                TripRequestListModel *model = [[TripRequestListModel alloc] initWithDictionary:pageDict[@"trip_data"] error:nil];
                
                
                TravelerTripVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TravelerTripVC"];
                vc.isUpcomingTrip = true;
                vc.requestModel = model;
                vc.hidesBottomBarWhenPushed = TRUE;
                [self.navigationController pushViewController:vc animated:YES];
            });
        }
    }
    else
    {
        if (btnRequest.selected)
        {
            [self fetchTripRequestData];
        }
        else if (btnHistory.selected)
        {
            [self fetchPastTripData];
        }
        else
        {
            [self fetchCurrentTripData];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onTapBtnFromNotificationTripID:(NSString *)tripID
{
    [btnTraveller setSelected:YES];
    [btnRequest setSelected:NO];
    [btnHistory setSelected:NO];
    [UIView animateWithDuration:0.15 animations:^{
        vwLine.center = CGPointMake(btnTraveller.center.x, vwLine.center.y);
    } completion:nil];
    
    [[ServiceHandler sharedInstance].looperWebService processLooperCurrentTripDataSuccessBlock:^(id response)
     {
         if ([response isKindOfClass:[NSArray class]])
         {
             tblListing.tableHeaderView = nil;
             arrData = [[NSMutableArray alloc] initWithArray:response];
             NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.iTripID CONTAINS[cd] %@",tripID];
             NSArray *arrayOfData = [arrData valueForKey:@"DATA"];
//             pred = [NSPredicate predicateWithFormat:@"SELF.iTripID = %@",tripID];
             NSArray *filterArray = [arrayOfData filteredArrayUsingPredicate:pred];
             NSLog(@"FILTER ARRAAY %@",filterArray);
             if (filterArray.count > 0)
             {
                 NSError *error;
                 
                 NSDictionary *setDict = [[filterArray objectAtIndex:0] objectAtIndex:0];
                 
                 
                 TripRequestListModel *model = [[TripRequestListModel alloc] initWithDictionary:setDict error:&error];
                 
                 TravelerTripVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TravelerTripVC"];
                 vc.isUpcomingTrip = true;
                 vc.requestModel = model;
                 vc.hidesBottomBarWhenPushed = TRUE;
                 [self.navigationController pushViewController:vc animated:YES];

             }
             else
             {
                 [AJNotificationView showNoticeInView:[[[UIApplication sharedApplication] delegate] window] type:AJNotificationTypeRed title:@"The trip detail not available" linedBackground:AJLinedBackgroundTypeDisabled hideAfter:2.5];
             }
             [tblListing reloadData];
         }
         else if([response[success] intValue] == 0)
         {
             arrData = [[NSMutableArray alloc] init];
             if (arrData.count == 0)
             {
                 tblListing.tableHeaderView = viewNoRecord;
                 [AJNotificationView showNoticeInView:[[[UIApplication sharedApplication] delegate] window] type:AJNotificationTypeRed title:@"The trip detail not available" linedBackground:AJLinedBackgroundTypeDisabled hideAfter:2.5];
             }
             [tblListing reloadData];
         }
         
     } errorBlock:^(NSError *error)
     {
         arrData = [[NSMutableArray alloc] init];
         if (arrData.count == 0)
         {
             tblListing.tableHeaderView = viewNoRecord;
         }
         [tblListing reloadData];
     }];
}
#pragma mark- IBAction Methods

-(IBAction)onTapBtnTraveller:(id)sender {
    [btnTraveller setSelected:YES];
    [btnRequest setSelected:NO];
    [btnHistory setSelected:NO];
    [UIView animateWithDuration:0.15 animations:^{
        vwLine.center = CGPointMake(btnTraveller.center.x, vwLine.center.y);
    } completion:nil];
    
    [self fetchCurrentTripData];
    
//    [tblListing reloadData];
}

-(IBAction)onTapBtnRequest:(id)sender {
    [btnTraveller setSelected:NO];
    [btnHistory setSelected:NO];
    [btnRequest setSelected:YES];
    [UIView animateWithDuration:0.15 animations:^{
        vwLine.center = CGPointMake(btnRequest.center.x, vwLine.center.y);
    } completion:^(BOOL finished) {
        
    }];
    [self fetchTripRequestData];
//    [tblListing reloadData];
}

- (IBAction)btnHistoryPressed:(id)sender
{
    [btnTraveller setSelected:NO];
    [btnRequest setSelected:NO];
    [btnHistory setSelected:TRUE];
    [UIView animateWithDuration:0.15 animations:^{
        vwLine.center = CGPointMake(btnHistory.center.x, vwLine.center.y);
    } completion:^(BOOL finished) {
        
    }];
    [self fetchPastTripData];
}

-(void)fetchPastTripData
{
    [[ServiceHandler sharedInstance].looperWebService processLooperTripHistoryWithSuccessBlock:^(NSDictionary *response)
     {
         
         if([response[success] intValue] == 1)
         {
             NSArray *tempData = [[NSArray alloc] initWithObjects:response, nil];
             NSDictionary *dict = [tempData objectAtIndex:0];
             
             arrData = [[NSMutableArray alloc] initWithArray:dict[@"Past"]];
             
             if (arrData.count == 0)
             {
                 tblListing.tableHeaderView = viewNoRecord;
             }
             else
             {
                 tblListing.tableHeaderView = nil;
             }

         }
         else if([response[success] intValue] == 0)
         {
             arrData = [[NSMutableArray alloc] init];
             if (arrData.count == 0)
             {
                 tblListing.tableHeaderView = viewNoRecord;
             }
             [tblListing reloadData];
         }
         
         [tblListing reloadData];
         
         
         
         
     } errorBlock:^(NSError *error)
     {
         arrData = [[NSMutableArray alloc] init];
         if (arrData.count == 0)
         {
             tblListing.tableHeaderView = viewNoRecord;
         }
         [tblListing reloadData];
     }];
}

-(void)fetchCurrentTripData
{
    [[ServiceHandler sharedInstance].looperWebService processLooperCurrentTripDataSuccessBlock:^(id response)
     {
         if ([response isKindOfClass:[NSArray class]])
         {
             tblListing.tableHeaderView = nil;
             arrData = [[NSMutableArray alloc] initWithArray:response];
             [tblListing reloadData];
         }
         else if([response[success] intValue] == 0)
         {
             arrData = [[NSMutableArray alloc] init];
             if (arrData.count == 0)
             {
                 tblListing.tableHeaderView = viewNoRecord;
             }
             [tblListing reloadData];
         }
         
     } errorBlock:^(NSError *error)
     {
         arrData = [[NSMutableArray alloc] init];
         if (arrData.count == 0)
         {
             tblListing.tableHeaderView = viewNoRecord;
         }
         [tblListing reloadData];
     }];
}

-(void)fetchTripRequestData
{
    [[ServiceHandler sharedInstance].looperWebService processLooperTripRequestListWithSuccessBlock:^(id response)
     {
         if ([response isKindOfClass:[NSArray class]])
         {
             tblListing.tableHeaderView = nil;
             arrData = [[NSMutableArray alloc] initWithArray:response];
             [tblListing reloadData];
         }
         else if([response[success] intValue] == 0)
         {
             arrData = [[NSMutableArray alloc] init];
             if (arrData.count == 0)
             {
                 tblListing.tableHeaderView = viewNoRecord;
             }
             [tblListing reloadData];
         }
    
     } errorBlock:^(NSError *error)
     {
         arrData = [[NSMutableArray alloc] init];
         if (arrData.count == 0)
         {
             tblListing.tableHeaderView = viewNoRecord;
         }
         [tblListing reloadData];
     }];
}
#pragma mark-  Custom Method
-(void)SetBorderLine:(id)sender BoolValue:(BOOL)Value
{
    UIButton *button =(UIButton *)sender;
    UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, button.frame.size.height - 1.0f, button.frame.size.width, 1)];
    bottomBorder.backgroundColor = [UIColor redColor];
    if (Value) {
        
        [button addSubview:bottomBorder];
    } else {
        
    }
    
}

#pragma mark - UITableView DataSource and Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (btnRequest.selected)
    {
        return [arrData count];
    }
    else if (btnHistory.selected)
    {
        return [arrData count];
    }
    else
    {
        NSDictionary *dict = [arrData objectAtIndex:section];
        NSArray *arr = [dict valueForKey:@"DATA"];
        return [arr count];
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (btnRequest.selected)
    {
        static NSString *cellID = @"TripRequestCellID";
        NSError *error;
        
        TripRequestListModel *model = [[TripRequestListModel alloc] initWithDictionary:[arrData objectAtIndex:indexPath.row] error:&error];
        
        TripRequestCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
        cell.viewBG.backgroundColor = [UIColor darkGrayBackgroundColor];
        cell.delegate = self;
        cell.requestModel = model;
        cell.btnAccept.hidden = false;
        cell.btnReject.hidden = false;
        return cell;
    }
    else if (btnHistory.selected)
    {
        static NSString *cellID = @"TripRequestCellID";
        NSError *error;
        
        TripRequestListModel *model = [[TripRequestListModel alloc] initWithDictionary:[arrData objectAtIndex:indexPath.row] error:&error];
        
        TripRequestCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
        cell.viewBG.backgroundColor = [UIColor darkGrayBackgroundColor];
        cell.delegate = self;
        cell.requestModel = model;
        cell.btnAccept.hidden = true;
        cell.btnReject.hidden = true;

        return cell;
    }
    else
    {
        
        static NSString *cellID = @"TripRequestCellID";
        NSError *error;
        
        
        
        NSDictionary *dict = [arrData objectAtIndex:indexPath.section];
        NSArray *arr = [dict valueForKey:@"DATA"];
        NSDictionary *setDict = [arr objectAtIndex:indexPath.row];

        
        TripRequestListModel *model = [[TripRequestListModel alloc] initWithDictionary:setDict error:&error];
        TripRequestCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
        cell.viewBG.backgroundColor = [UIColor darkGrayBackgroundColor];
        cell.delegate = self;
        [cell setRequestData:model];
        cell.btnAccept.hidden = true;
        cell.btnReject.hidden = true;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (btnRequest.isSelected)
    {
        
    }
    else if (btnHistory.isSelected)
    {
        NSError *error;
        
        
        
        NSDictionary *dict = [arrData objectAtIndex:indexPath.row];
        
        
        TripRequestListModel *model = [[TripRequestListModel alloc] initWithDictionary:dict error:&error];
        
        
        TravelerTripVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TravelerTripVC"];
        vc.isUpcomingTrip = false;
        vc.requestModel = model;
        vc.hidesBottomBarWhenPushed = TRUE;
        [self.navigationController pushViewController:vc animated:YES];

    }
    else
    {
        NSError *error;
        
        
        
        NSDictionary *dict = [arrData objectAtIndex:indexPath.section];
        NSArray *arr = [dict valueForKey:@"DATA"];
        NSDictionary *setDict = [arr objectAtIndex:indexPath.row];
        
        
        TripRequestListModel *model = [[TripRequestListModel alloc] initWithDictionary:setDict error:&error];
        
        
        TravelerTripVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TravelerTripVC"];
        vc.isUpcomingTrip = true;
        vc.requestModel = model;
        vc.hidesBottomBarWhenPushed = TRUE;
        [self.navigationController pushViewController:vc animated:YES];
    }
//    if (btnRequest.selected)
//    {
//        [self performSegueWithIdentifier:@"segueTravelerDetail" sender:nil];
//    }
//    else
//    {
//        [self performSegueWithIdentifier:@"segueTrip" sender:nil];
//    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (btnRequest.isSelected)
    {
        return 1;
    }
    else if (btnHistory.isSelected)
    {
        return 1;
    }
    else{
        return [arrData count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (btnRequest.isSelected)
    {
        return 0;
    }
    else if (btnHistory.isSelected)
    {
        return 0;
    }
    else
        return 0;
//    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (btnRequest.selected)
    {
        return 138;
    }
    else
    {
        return 138;
//        return 106;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (btnRequest.isSelected)
    {
        return [[UIView alloc] init];
    }
    else if (btnHistory.isSelected)
    {
        return [[UIView alloc] init];
    }
    else
    {
        return [[UIView alloc] init];
    }
    /*
    UIView *viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0,tblListing.bounds.size.width, 40)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, tableView.frame.size.width, 30)];
    
    NSDictionary *dict = [arrData objectAtIndex:section];
    NSString *string = dict[@"dDepartureDate"];

    //[list objectAtIndex:section];
     Section header is in 0th index... 
    [label setText:string];
    [label setTextColor:[UIColor whiteColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[UIFont fontAvenirNextCondensedMediumWithSize:FONT_HEADER_LARGE_SIZE]];
    [viewHeader addSubview:label];
    [viewHeader setBackgroundColor:[UIColor blackColor]];
    
    return viewHeader;
    */
}


-(void)tripAcceptOrDeclinePressedWithStatus:(BOOL)eStatus tripModel:(TripRequestListModel *)tripModel
{
    DebugLog(@"trip request model %@",tripModel);
    NSString *status;
    if (eStatus)
        status = @"1";
    else
        status = @"2";
    
    [[ServiceHandler sharedInstance].looperWebService processLooperTripRequestActionWithRequestID:[NSString stringWithFormat:@"%@",tripModel.iRequestID] eStatus:status SuccessBlock:^(NSDictionary *response)
    {
//        [arrData removeAllObjects];
        if([response[@"STATUS"]  isEqual: @"ACCEPT"])
        {
//            [self performSegueWithIdentifier:@"segueTravelerDetail" sender:tripModel];
            [self fetchTripRequestData];
        }
        else
        {
            [self fetchTripRequestData];
        }
        
//        [tblListing reloadData];
        
    } errorBlock:^(NSError *error)
    {
        
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segueTravelerDetail"])
    {
        TravellerDetailViewController *vc = segue.destinationViewController;
        vc.tripModel = (TripRequestListModel *)sender;
    }
}

@end
