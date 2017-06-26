//
//  BookingHistoryVC.m
//  Looper
//
//  Created by hardik on 3/16/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "BookingHistoryVC.h"
#import "BookinHistoryCell.h"
#import "UIColor+CustomColor.h"
#import "TripDetailHistory.h"

#import "KLCPopup.h"
#import "RatingView.h"

@interface BookingHistoryVC ()<UITableViewDataSource,UITableViewDelegate,RatingViewDelegate>
{
    NSArray *arrHistory;
    KLCPopup *pop;
    RatingView *viewwRating;
    BOOL isUpcomingTrip;
}
@property (strong, nonatomic) IBOutlet UIView *viewHeader;
@property (strong, nonatomic) IBOutlet UIButton *btnUpcomingTrips;
@property (strong, nonatomic) IBOutlet UITableView *tblBooking;
@property (strong, nonatomic) IBOutlet UIButton *btnPastTrips;
@property (strong, nonatomic) IBOutlet UIButton *btnTrip;
@property (strong, nonatomic) IBOutlet UILabel *lblViewHeader;

@property (strong, nonatomic) IBOutlet UIView *noRecordFound;
@end

@implementation BookingHistoryVC
@synthesize btnPastTrips,btnUpcomingTrips,tblBooking;

- (void)viewDidLoad
{
    [super viewDidLoad];
//    arrHistory = [[NSArray alloc] init];
    self.parentViewController.navigationController.navigationBarHidden = TRUE;
    self.navigationController.navigationBar.topItem.title = @"BOOKINGS";
    btnPastTrips.titleLabel.font = [UIFont fontAvenirNextCondensedRegularWithSize:FONT_MEDIUM_SIZE];
    btnUpcomingTrips.titleLabel.font = [UIFont fontAvenirNextCondensedRegularWithSize:FONT_MEDIUM_SIZE];
    
    [btnUpcomingTrips setTitle:@"CURRENT TRIPS" forState:UIControlStateNormal];
    // Do any additional setup after loading the view.
    
    isUpcomingTrip = TRUE;
    _lblViewHeader.text = @"You haven’t planned any trip yet!";
    
//    if (arrHistory.count == 0)
//    {
//        tblBooking.tableHeaderView = _viewHeader;
//    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.topItem.title = @"BOOKINGS";
    [[ServiceHandler sharedInstance].travelerWebService processTripHistoryWithSuccessBlock:^(NSDictionary *response)
     {
         arrHistory = [[NSArray alloc] initWithObjects:response, nil];
        
         if (isUpcomingTrip && arrHistory.count> 0)
         {
             NSDictionary *dict = [arrHistory objectAtIndex:0];
             NSArray * arrData = [[NSArray alloc] initWithArray:dict[@"Upcoming"]];
             if (arrData.count == 0)
             {
                 _lblViewHeader.text = @"You haven’t planned any trip yet!";
                 _btnTrip.hidden = false;
                 tblBooking.tableHeaderView = _viewHeader;
             }
             else
             {
                 tblBooking.tableHeaderView = nil;
             }
         }

         [tblBooking reloadData];
     } errorBlock:^(NSError *error)
     {
             _lblViewHeader.text = @"You haven’t planned any trip yet!";
             _btnTrip.hidden = false;
             tblBooking.tableHeaderView = _viewHeader;
     }];
    
}
#pragma Mark - TAbleview

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"BookingHistoryCell";
    BookinHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.viewBackground.backgroundColor = [UIColor darkGrayBackgroundColor];

    NSDictionary *dict = [arrHistory objectAtIndex:indexPath.section];
    NSArray *arrData;
    if (isUpcomingTrip)
    {
        arrData = [[NSArray alloc] initWithArray:dict[@"Upcoming"]];
    }
    else
    {
        arrData = [[NSArray alloc] initWithArray:dict[@"Past"]];
    }
    TripRequestListModel *model = [[TripRequestListModel alloc] initWithDictionary:[arrData objectAtIndex:indexPath.row] error:nil];
    cell.modelObj = model;

    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return [arrHistory count];
    NSDictionary *dict = [arrHistory objectAtIndex:section];
    
    if (isUpcomingTrip)
    {
        return [dict[@"Upcoming"] count];
    }
    else
    {
        return [dict[@"Past"] count];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{


    NSDictionary *dict = [arrHistory objectAtIndex:indexPath.section];
    NSArray *arrData;
    if (isUpcomingTrip)
    {
        arrData = [[NSArray alloc] initWithArray:dict[@"Upcoming"]];
    }
    else
    {
        arrData = [[NSArray alloc] initWithArray:dict[@"Past"]];
        
    }
    
    TripRequestListModel *model = [[TripRequestListModel alloc] initWithDictionary:[arrData objectAtIndex:indexPath.row] error:nil];
    
    
    [self performSegueWithIdentifier:@"segueTripDetail" sender:model];
    
//    viewwRating = [[[NSBundle mainBundle] loadNibNamed:@"RatingView" owner:self options:nil] lastObject];
//    viewwRating.delegate = self;
//    pop = [KLCPopup popupWithContentView:viewwRating showType:KLCPopupShowTypeBounceInFromTop dismissType:KLCPopupDismissTypeBounceOutToBottom maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
//    
//    viewwRating.frame = self.view.frame;
//    [pop showAtCenter:self.view.center inView:self.view];

}

-(void)viewDismiss
{
    [pop dismiss:YES];    
}

#pragma Mark - IBAction

- (IBAction)btnUpcomingTripsPressed:(id)sender
{
    isUpcomingTrip = TRUE;
    [tblBooking reloadData];
    [btnUpcomingTrips setTitleColor:[LooperUtility sharedInstance].appThemeColor forState:UIControlStateNormal];
    [btnPastTrips setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    NSDictionary *dict = [arrHistory objectAtIndex:0];
    NSArray *arrData;
    if (isUpcomingTrip)
    {
        arrData = [[NSArray alloc] initWithArray:dict[@"Upcoming"]];
        if (arrData.count == 0)
        {
            _lblViewHeader.text = @"You haven’t planned any trip yet!";
            _btnTrip.hidden = false;
            tblBooking.tableHeaderView = _viewHeader;
        }
        else
        {
            tblBooking.tableHeaderView = nil;
        }
    }
    [tblBooking reloadData];

}


- (IBAction)btnPastTripsPressed:(id)sender
{
    isUpcomingTrip = FALSE;
    [tblBooking reloadData];
    [btnPastTrips setTitleColor:[LooperUtility sharedInstance].appThemeColor forState:UIControlStateNormal];
    [btnUpcomingTrips setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    NSDictionary *dict = [arrHistory objectAtIndex:0];
    NSArray *arrData;
    if (!isUpcomingTrip)
    {
        arrData = [[NSArray alloc] initWithArray:dict[@"Past"]];
        if (arrData.count == 0)
        {
//            _lblViewHeader.text = @"No Record Found!!";
            _btnTrip.hidden = TRUE;
              tblBooking.tableHeaderView = _noRecordFound;
        }
        else
        {
            tblBooking.tableHeaderView = nil;
        }
    }
    [tblBooking reloadData];
}

- (IBAction)btnNewTripPressed:(id)sender
{
    [LooperUtility sharedInstance].isNoTrip = TRUE;
    self.tabBarController.selectedIndex = 0;
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"kCreateNewTrip" object:nil];
}

-(void)onTapBtnUpcomingFromNotificationListingTripID:(NSString *)tripID
{

    isUpcomingTrip = TRUE;
    [tblBooking reloadData];
    [btnUpcomingTrips setTitleColor:[LooperUtility sharedInstance].appThemeColor forState:UIControlStateNormal];
    [btnPastTrips setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    if (arrHistory.count == 0)
    {
        [[ServiceHandler sharedInstance].travelerWebService processTripHistoryWithSuccessBlock:^(NSDictionary *response)
         {
             arrHistory = [[NSArray alloc] initWithObjects:response, nil];
             
             if (isUpcomingTrip && arrHistory.count> 0)
             {
                 NSDictionary *dict = [arrHistory objectAtIndex:0];
                 NSArray * arrData = [[NSArray alloc] initWithArray:dict[@"Upcoming"]];
                 if (arrData.count == 0)
                 {
                     _lblViewHeader.text = @"You haven’t planned any trip yet!";
                     _btnTrip.hidden = false;
                     tblBooking.tableHeaderView = _viewHeader;
                 }
                 else
                 {
                     tblBooking.tableHeaderView = nil;
                     [self openDetailTrip:tripID];
                 }
             }
             
             [tblBooking reloadData];
         } errorBlock:^(NSError *error)
         {
             _lblViewHeader.text = @"You haven’t planned any trip yet!";
             _btnTrip.hidden = false;
             tblBooking.tableHeaderView = _viewHeader;
         }];

    }
    else
    {
        [self openDetailTrip:tripID];
    }
}

-(void)openDetailTrip:(NSString *)tripID
{
    NSDictionary *dict = [arrHistory objectAtIndex:0];
    NSArray *arrData;
    
    if (isUpcomingTrip)
    {
        arrData = [[NSArray alloc] initWithArray:dict[@"Upcoming"]];
        if (arrData.count == 0)
        {
            _lblViewHeader.text = @"You haven’t planned any trip yet!";
            _btnTrip.hidden = false;
            tblBooking.tableHeaderView = _viewHeader;
        }
        else
        {
            tblBooking.tableHeaderView = nil;
            
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.iTripID CONTAINS[cd] %@",tripID];
            //             pred = [NSPredicate predicateWithFormat:@"SELF.iTripID = %@",tripID];
            NSArray *filterArray = [arrData filteredArrayUsingPredicate:pred];
            NSLog(@"FILTER ARRAAY %@",filterArray);
            if (filterArray.count > 0)
            {
                            
                NSDictionary *setDict = [filterArray objectAtIndex:0];
                
                TripRequestListModel *model = [[TripRequestListModel alloc] initWithDictionary:setDict error:nil];
                
                
                [self performSegueWithIdentifier:@"segueTripDetail" sender:model];
                
            }
            else
            {
                [AJNotificationView showNoticeInView:[[[UIApplication sharedApplication] delegate] window] type:AJNotificationTypeRed title:@"The trip detail not available" linedBackground:AJLinedBackgroundTypeDisabled hideAfter:2.5];
            }
        }
    }

}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"segueTripDetail"])
    {
        TripDetailHistory *vc = segue.destinationViewController;
        vc.tripModel = (TripRequestListModel *)sender;
        vc.isUpcomignTrip = isUpcomingTrip;
    }
}


@end
