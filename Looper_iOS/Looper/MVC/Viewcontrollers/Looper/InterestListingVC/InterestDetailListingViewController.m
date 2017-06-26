//
//  InterestDetailListingViewController.m
//  Looper
//
//  Created by Meera Dave on 04/02/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "InterestDetailListingViewController.h"
#import "DetailListingTableViewCell.h"
#import "BookLooperView.h"
#import "YelpClient.h"
#import "PlaceModel.h"
#import "UITableView+DragLoad.h"
#import "LoaderView.h"

@interface InterestDetailListingViewController ()<BookLooperViewDelegate,UITableViewDragLoadDelegate,UITextFieldDelegate> {
    __weak IBOutlet UITableView *tblDetailListing;
    __weak IBOutlet UITextField *tfSearchbar;
    NSMutableArray *arrDetailListing;
    BookLooperView *looperView;
    int nextPageStartIndex;
    NSTimer *delaySearch;
    BOOL isPagingApiCall;
}

@end
@implementation InterestDetailListingViewController
@synthesize selectedCategory;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    arrDetailListing =[[NSMutableArray alloc] init];
    
    if ([LooperUtility isInternetAvailable])
    {
        [self callLocationAPI:selectedCategory[@"name"] isLoadMore:NO];
    }
    
    
    tblDetailListing.rowHeight = UITableViewAutomaticDimension;
    tblDetailListing.estimatedRowHeight = 160;
    
    self.title = [selectedCategory[@"name"] uppercaseString];
    
    [tblDetailListing setDragDelegate:self refreshDatePermanentKey:@"InteresetDetail"];
    tblDetailListing.showLoadMoreView = YES;
    tfSearchbar.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    
    [tfSearchbar addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - Control datasource

- (void)finishRefresh
{
    nextPageStartIndex = 10;
    [tblDetailListing finishRefresh];
    [tblDetailListing reloadData];
}

- (void)finishLoadMore
{
    nextPageStartIndex += 10;
    [tblDetailListing finishLoadMore];
    [tblDetailListing reloadData];
}

#pragma mark - Drag delegate methods

- (void)dragTableDidTriggerRefresh:(UITableView *)tableView
{
    //send refresh request(generally network request) here
    arrDetailListing =[[NSMutableArray alloc] init];
    
    if (tfSearchbar.text.length == 0)
    {
        [self callLocationAPI:selectedCategory[@"name"] isLoadMore:NO];
    }
    else
    {
        [self callLocationAPI:[tfSearchbar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isLoadMore:NO];
    }
    

//    [self performSelector:@selector(finishRefresh) withObject:nil afterDelay:2];
}

- (void)dragTableRefreshCanceled:(UITableView *)tableView
{
    //cancel refresh request(generally network request) here
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(finishRefresh) object:nil];
}

- (void)dragTableDidTriggerLoadMore:(UITableView *)tableView
{
    //send load more request(generally network request) here
    if (tfSearchbar.text.length == 0)
    {
        [self callLocationAPI:selectedCategory[@"name"] isLoadMore:YES];
    }
    else
    {
    [self callLocationAPI:[tfSearchbar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isLoadMore:YES];
    }
    
//    [self performSelector:@selector(finishLoadMore) withObject:nil afterDelay:2];
}

- (void)dragTableLoadMoreCanceled:(UITableView *)tableView
{
    //cancel load more request(generally network request) here
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(finishLoadMore) object:nil];
}

-(void)textFieldDidChange:(UITextField *)textField
{
    /*
    NSString *text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (text.length > 3)
    {
        if ([LooperUtility isInternetAvailable])
        {
            // call an asynchronous HTTP request
            [delaySearch invalidate];
            delaySearch = nil;
            delaySearch = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(doSearch) userInfo:nil repeats:NO];
        }
    }
    else if (text.length == 0)
    {
        arrDetailListing = [[NSMutableArray alloc] init];
        [tblDetailListing reloadData];
    }
    else
    {
        
    }
 */
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self doSearch];
    return true;
    
}

-(void)doSearch
{
    [delaySearch invalidate];
    delaySearch = nil;
    arrDetailListing =[[NSMutableArray alloc] init];
//    DebugLog(@"Us %@",text.userInfo[@"searchText"]);
    if (tfSearchbar.text.length == 0)
    {
        [self callLocationAPI:selectedCategory[@"name"] isLoadMore:NO];
    }
    else
    {
        [self callLocationAPI:[tfSearchbar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isLoadMore:NO];
    }
}

-(void)callLocationAPI:(NSString *)term isLoadMore:(BOOL)isLoadMore
{
    NSLog(@"Succ");
    LooperModel *profileObj = [LooperUtility getLooperProfile];
    
    [LoaderView showLoader];
//    [[YelpClient sharedInstance] searchWithTerm:term sort:BestMatched
//                                          deals:NO  location:[NSString stringWithFormat:@"%@, %@",profileObj.vCity,profileObj.vState] startIndex:(int)[arrDetailListing count] categories:@[selectedCategory[@"yelpCategory"]] successBlock:^(NSDictionary *response)
    [[YelpClient sharedInstance] searchWithTerm:term sort:BestMatched
                                          deals:NO  location:[NSString stringWithFormat:@"%@, %@",profileObj.vCity,profileObj.vState] startIndex:(int)[arrDetailListing count] categories:@[selectedCategory[@"yelpCategory"]] successBlock:^(NSDictionary *response)
     {
         [LoaderView hideLoader];
         NSArray *arr = response[@"businesses"];
//         arrDetailListing = [[NSMutableArray alloc] init];
         for (NSDictionary *dict in arr)
         {
             PlaceModel *model = [[PlaceModel alloc] initWithDictionary:dict];
             [arrDetailListing addObject:model];
         }
         if (isLoadMore)
             [self finishLoadMore];
         else
             [self finishRefresh];
         
         
     } errorBlock:^(NSError *error) {
         [self finishLoadMore];
         [LoaderView hideLoader];
     }];
}

#pragma mark - UITableView DataSource and Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrDetailListing count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"DetailListing";
    
    DetailListingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    PlaceModel *model = [arrDetailListing objectAtIndex:indexPath.row];
    cell.modelObj = model;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    TravellerDetailViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TravellerDetailViewController"];
//    [self.navigationController pushViewController:controller animated:YES];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    PlaceModel *model = [arrDetailListing objectAtIndex:indexPath.row];

    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    
    looperView = [[[NSBundle mainBundle] loadNibNamed:@"BookLooperView" owner:self options:nil] lastObject];
    
    //    looperView.frame = window.frame;
    looperView.userTyp = LOOPER_DETAIL;
    looperView.delegate = self;
    looperView.image = [LooperUtility screenshotOfWholeScreen];
    [looperView drawRect:window.frame];
    looperView.tripModel = _tripModel;
    looperView.dictLooperBooking = [[NSMutableDictionary alloc] initWithDictionary:selectedCategory];
    looperView.placeModel = model;
    //    looperView.center = window.center;

    [self.view addSubview:looperView];
    [self.view bringSubviewToFront:looperView];
//    [window insertSubview:looperView aboveSubview:self.view];
//    [window bringSubviewToFront:looperView];
    
}
-(void)removeView:(BOOL)isDone
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [looperView removeFromSuperview];
    if (isDone)
        [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    looperView.delegate = nil;
}
@end
