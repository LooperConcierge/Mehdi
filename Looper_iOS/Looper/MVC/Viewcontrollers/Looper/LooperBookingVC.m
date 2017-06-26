//
//  LooperBookingVC.m
//  Looper
//
//  Created by hardik on 3/26/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "LooperBookingVC.h"
#import "BookinHistoryCell.h"
#import "IQKeyboardManager.h"
#import "TravellerDetailViewController.h"
#import "TravelerTripVC.h"

@interface LooperBookingVC ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
{
    NSArray *arrHistory;
    BOOL isUpcomingTrip;
}
@property (strong, nonatomic) IBOutlet UITableView *tblBooking;
@property (strong, nonatomic) IBOutlet UIButton *btnUpcomingTrip;
@property (strong, nonatomic) IBOutlet UIButton *btnPastTrip;
@property (strong, nonatomic) IBOutlet UIView *viewNoRecord;

@end

@implementation LooperBookingVC
@synthesize tblBooking,btnPastTrip,btnUpcomingTrip;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareView];
    
    // Do any additional setup after loading the view.
}

-(void)prepareView
{
//    arrHistory = [[NSArray alloc] init];
    self.navigationController.navigationBar.topItem.title = @"BOOKING";
    [IQKeyboardManager sharedManager].enable = true;
    btnPastTrip.titleLabel.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_HEADER_SIZE];
    btnUpcomingTrip.titleLabel.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_HEADER_SIZE];
    isUpcomingTrip = TRUE;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[ServiceHandler sharedInstance].looperWebService processLooperTripHistoryWithSuccessBlock:^(NSDictionary *response)
    {
        arrHistory = [[NSArray alloc] initWithObjects:response, nil];
        NSDictionary *dict = [arrHistory objectAtIndex:0];
        
        if (isUpcomingTrip)
        {
            if([dict[@"Upcoming"] count] == 0)
            {
                tblBooking.tableHeaderView = _viewNoRecord;
            }
            else
            {
                tblBooking.tableHeaderView = nil;
            }
        }

        [tblBooking reloadData];
    } errorBlock:^(NSError *error)
    {
        
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"BookingHistoryCell";
    
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
    BookinHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    TripRequestListModel *model = [[TripRequestListModel alloc] initWithDictionary:[arrData objectAtIndex:indexPath.row] error:nil];
    cell.modelObj = model;
    cell.viewBackground.backgroundColor = [UIColor darkGrayBackgroundColor];
    
    return cell;

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
    
        TravelerTripVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TravelerTripVC"];
        vc.isUpcomingTrip = isUpcomingTrip;
        vc.requestModel = model;
        vc.hidesBottomBarWhenPushed = TRUE;
        [self.navigationController pushViewController:vc animated:YES];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 138;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnUpcomingTripPressed:(id)sender {
    isUpcomingTrip = TRUE;
    [btnUpcomingTrip setTitleColor:[UIColor colorWithRed:1 green:0.3333 blue:0.3725 alpha:1.0] forState:UIControlStateNormal];
    [btnPastTrip setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    NSDictionary *dict = [arrHistory objectAtIndex:0];
    
    if (isUpcomingTrip)
    {
         if([dict[@"Upcoming"] count] == 0)
         {
             tblBooking.tableHeaderView = _viewNoRecord;
         }
         else
         {
             tblBooking.tableHeaderView = nil;
         }
    }

    [tblBooking reloadData];
}

- (IBAction)btnPastTripPressed:(id)sender {
    isUpcomingTrip = FALSE;
    [btnPastTrip setTitleColor:[UIColor colorWithRed:1 green:0.3333 blue:0.3725 alpha:1.0] forState:UIControlStateNormal];
    [btnUpcomingTrip setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    NSDictionary *dict = [arrHistory objectAtIndex:0];
    
    if (isUpcomingTrip == FALSE)
    {
        if([dict[@"Past"] count] == 0)
        {
            tblBooking.tableHeaderView = _viewNoRecord;
        }
        else
        {
            tblBooking.tableHeaderView = nil;
        }
    }
    [tblBooking reloadData];
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    // Do whatever you want here
    return YES; // Return NO if you don't want iOS to open the link
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
