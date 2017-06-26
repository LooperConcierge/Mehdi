//
//  TravelerNotification.m
//  Looper
//
//  Created by hardik on 3/16/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "TravelerNotification.h"
#import "UITableView+DragLoad.h"

@interface TravelerNotification ()<UITableViewDataSource,UITableViewDelegate,UITableViewDragLoadDelegate>
{
    int totalRecord;
    int nextPageStartIndex;
    NSMutableArray *arrNotification;
    IBOutlet UIView *viewNoRecord;
}
@property (strong, nonatomic) IBOutlet UITableView *tblNotification;

@end

@implementation TravelerNotification

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareView
{
  
    
    self.tblNotification.rowHeight = UITableViewAutomaticDimension;
    self.tblNotification.estimatedRowHeight = 160.0;
    [_tblNotification setDragDelegate:self refreshDatePermanentKey:@"Notification"];
    _tblNotification.showLoadMoreView = YES;
    nextPageStartIndex = 0;
    _tblNotification.tableFooterView = [UIView new];
    self.title = @"NOTIFICATIONS";
    nextPageStartIndex = 0;
 
    arrNotification = [[NSMutableArray alloc] init];
    [self fetchNotificationList:YES];
    [self resetBadgerValue];
}

#pragma mark - Control datasource

- (void)finishRefresh
{
    //    nextPageStartIndex += 1;
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dCreatedDate" ascending:FALSE];
//    [arrQuestions sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    if (arrNotification.count == 0)
    {
        _tblNotification.tableHeaderView = viewNoRecord;
    }
    else
    {
        _tblNotification.tableHeaderView = nil;
    }

    [_tblNotification finishRefresh];
    [_tblNotification reloadData];
}

- (void)finishLoadMore
{
    //    nextPageStartIndex += 1;
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dCreatedDate" ascending:FALSE];
//    [arrQuestions sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    if (arrNotification.count == 0)
    {
        _tblNotification.tableHeaderView = viewNoRecord;
    }
    else
    {
        _tblNotification.tableHeaderView = nil;
    }

    [_tblNotification finishLoadMore];
    [_tblNotification reloadData];
}

#pragma mark - Drag delegate methods

- (void)dragTableDidTriggerRefresh:(UITableView *)tableView
{
    //send refresh request(generally network request) here
    
    //    [self performSelector:@selector(finishRefresh) withObject:nil afterDelay:2];
    nextPageStartIndex = 0;
    arrNotification = [[NSMutableArray alloc] init];
    [tableView reloadData];
    [self fetchNotificationList:YES];
}

- (void)dragTableRefreshCanceled:(UITableView *)tableView
{
    //cancel refresh request(generally network request) here
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(finishRefresh) object:nil];
}

- (void)dragTableDidTriggerLoadMore:(UITableView *)tableView
{
    //send load more request(generally network request) here
    //    [self callLocationAPI:[tfSearchbar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    
    if (totalRecord != [arrNotification count])
    {
        nextPageStartIndex += 1;
        [self fetchNotificationList:NO];
    }
    else
    {
        [self performSelector:@selector(finishLoadMore) withObject:nil afterDelay:1];
        [AJNotificationView showNoticeInView:[[[UIApplication sharedApplication] delegate] window] type:AJNotificationTypeRed title:@"No More record" linedBackground:AJLinedBackgroundTypeDisabled hideAfter:2.5];
    }
}

-(void)fetchNotificationList:(BOOL)isPullToRefresh
{
    
    [[ServiceHandler sharedInstance].looperWebService processGetNotificationList:[NSString stringWithFormat:@"%d",nextPageStartIndex] SuccessBlock:^(NSDictionary *response)
     {
         if ([response[success] intValue] == 1)
         {
             NSDictionary *dict = response[data];
             if ([dict isKindOfClass:[NSDictionary class]])
             {
                 [arrNotification addObjectsFromArray:dict[data]];
                 totalRecord = [response[@"TOTAL_RECORD"] intValue];
                 if (isPullToRefresh)
                     [self finishRefresh];
                 else
                     [self finishLoadMore];
                 
             }
         }
         else
         {
             arrNotification = @[].mutableCopy;
             totalRecord = 0;
             if (isPullToRefresh)
                 [self finishRefresh];
             else
                 [self finishLoadMore];
         }
         
         
     } errorBlock:^(NSError *error)
     {
         
     }];
    
}


- (void)dragTableLoadMoreCanceled:(UITableView *)tableView
{
    //cancel load more request(generally network request) here
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(finishLoadMore) object:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrNotification count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCellID" forIndexPath:indexPath];
    
    UILabel *lblName            = [cell.contentView viewWithTag:100];
    UILabel *lblDescription     = [cell.contentView viewWithTag:200];
    UILabel *lblTime            = [cell.contentView viewWithTag:300];
    
    NSDictionary *dict = [arrNotification objectAtIndex:indexPath.row];
    lblName.text = dict[@"vFullName"];
    lblDescription.text = dict[@"tMessage"];
    lblTime.text = dict[@"dTravellingDate"];
    
    lblDescription.font = [UIFont fontAvenirNextCondensedMediumWithSize:14];
    lblName.font = [UIFont fontAvenirNextCondensedMediumWithSize:16];
    lblTime.font = [UIFont fontAvenirNextCondensedMediumWithSize:14];
    
    if ([dict[@"isRead"] isEqualToString:@"N"])
    {
//        lblDescription.font = [UIFont fontAvenirNextCondensedBoldWithSize:14];
//        lblName.font = [UIFont fontAvenirNextCondensedBoldWithSize:16];
//        lblTime.font = [UIFont fontAvenirNextCondensedBoldWithSize:14];
        lblDescription.textColor = AppdelegateObject.looperGlobalObject.appThemeColor;
//        lblName.font =
//        lblTime.font =
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [arrNotification objectAtIndex:indexPath.row];
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"notificationClick"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[ServiceHandler sharedInstance].travelerWebService processNotificationRead:dict[@"iNotificationID"] SuccessBlock:^(NSDictionary *response)
     {
        
    } errorBlock:^(NSError *error)
    {
        
    }];
    
    [self.navigationController popViewControllerAnimated:true];
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
