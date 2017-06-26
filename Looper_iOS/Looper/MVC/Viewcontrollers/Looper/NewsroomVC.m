//
//  NewsroomVC.m
//  Looper
//
//  Created by hardik on 2/15/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "NewsroomVC.h"
#import "NewsroomCell.h"
#import "UITableView+DragLoad.h"
#import "CommentVC.h"

@interface NewsroomVC ()<UITableViewDelegate,UITableViewDataSource,NewsroomCellDelegate,UITableViewDragLoadDelegate,UISearchBarDelegate>
{
    NSMutableArray *arrQuestions;
    int totalRecord;
    int nextPageStartIndex;
    IBOutlet UIView *viewNoRecord;
    IBOutlet UISearchBar *searchBar;
    NSMutableArray *selectedCellIndexPath;
}
@property (strong, nonatomic) IBOutlet UITableView *tblNews;

@end

@implementation NewsroomVC
@synthesize tblNews;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareView];
    // Do any additional setup after loading the view.
}

-(void)prepareView
{
    selectedCellIndexPath = [[NSMutableArray alloc] init];
    tblNews.rowHeight = UITableViewAutomaticDimension;
    tblNews.estimatedRowHeight = 160;
    self.navigationController.navigationBar.topItem.title = @"LOOPER COMMUNITY";
    [tblNews setDragDelegate:self refreshDatePermanentKey:@"Newsroom"];
    tblNews.showLoadMoreView = YES;
    tblNews.showRefreshView = YES;

   
}

-(void)viewWillAppear:(BOOL)animated
{
    nextPageStartIndex = 0;
    
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    arrQuestions = [[NSMutableArray alloc] init];
    [self fetchQuestionList:YES];
    [super viewDidAppear:animated];
}


#pragma mark - searchbar delegate 

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"test");
    //NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"SELF beginswith[c] %@", searchBar];
    //newStories = [stories filteredArrayUsingPredicate:filterPredicate];
    //NSLog(@"newStories %@", newStories);
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar1
{
    [searchBar1 setShowsCancelButton:true animated:true];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar1
{
    [searchBar1 setShowsCancelButton:false animated:true];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar1
{
    [arrQuestions removeAllObjects];
    nextPageStartIndex = 0;
    [self fetchQuestionList:true];
    [searchBar1 resignFirstResponder];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar1
{
    [searchBar1 setShowsCancelButton:false animated:true];
    [searchBar1 resignFirstResponder];
}
#pragma mark - Control datasource

- (void)finishRefresh
{
//    nextPageStartIndex += 1;
    if (arrQuestions.count == 0)
    {
        tblNews.tableHeaderView = viewNoRecord;
    }
    else
    {
        tblNews.tableHeaderView = nil;
    }
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dCreatedDate" ascending:FALSE];
    [arrQuestions sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];

    
    [tblNews finishRefresh];
    [tblNews reloadData];
}

- (void)finishLoadMore
{
//    nextPageStartIndex += 1;
    if (arrQuestions.count == 0)
    {
        tblNews.tableHeaderView = viewNoRecord;
    }
    else
    {
        tblNews.tableHeaderView = nil;
    }
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dCreatedDate" ascending:FALSE];
    [arrQuestions sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [tblNews finishLoadMore];
    [tblNews reloadData];
}

#pragma mark - Drag delegate methods

- (void)dragTableDidTriggerRefresh:(UITableView *)tableView
{
    //send refresh request(generally network request) here
    
//    [self performSelector:@selector(finishRefresh) withObject:nil afterDelay:2];
    nextPageStartIndex = 0;
    arrQuestions = [[NSMutableArray alloc] init];
    [self fetchQuestionList:YES];
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
    
    if (totalRecord != [arrQuestions count])
    {
        nextPageStartIndex += 1;
        [self fetchQuestionList:NO];
    }
    else
    {
        [self performSelector:@selector(finishLoadMore) withObject:nil afterDelay:1];
    }
}

- (void)dragTableLoadMoreCanceled:(UITableView *)tableView
{
    //cancel load more request(generally network request) here
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(finishLoadMore) object:nil];
}


-(void)fetchQuestionList:(BOOL)isPullToRefresh
{
 
        NSDictionary *req = @{@"pageid" : @(nextPageStartIndex),
                              @"vQuestion" : [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]};
    
        [[ServiceHandler sharedInstance].looperWebService processLooperCommunityList:req SuccessBlock:^(NSDictionary *response)
         {
             if ([response[success] integerValue] == 1)
             {
                 if ([response isKindOfClass:[NSDictionary class]])
                 {
                     //                 arrQuestions = [[NSArray alloc] initWithArray:response[data]];
                     [arrQuestions addObjectsFromArray:response[data][data]];
                     totalRecord = [response[data][@"TOTAL_RECORD"] intValue];
                     if (isPullToRefresh)
                         [self finishRefresh];
                     else
                         [self finishLoadMore];
                     
                 }
             }
             else
             {
                 if (isPullToRefresh)
                     [self finishRefresh];
                 else
                     [self finishLoadMore];
             }
             
             
         } errorBlock:^(NSError *error)
         {
             
         }];
    
}

-(void)onTapBtnFromNotificationOpenCommunityID:(NSString *)communityID
{
    [self performSelector:@selector(openCOmmentScreenn:) withObject:communityID afterDelay:1];
}

-(void)openCOmmentScreenn:(NSString *)communityID
{
    NSDictionary *req = @{@"pageid" : @(nextPageStartIndex),
                          @"vQuestion" : @""};
    
    [[ServiceHandler sharedInstance].looperWebService processLooperCommunityList:req SuccessBlock:^(NSDictionary *response)
     {
         if ([response[success] integerValue] == 1)
         {
             if ([response isKindOfClass:[NSDictionary class]])
             {
                 //                 arrQuestions = [[NSArray alloc] initWithArray:response[data]];
                 arrQuestions = [[NSMutableArray alloc] init];
                 [arrQuestions addObjectsFromArray:response[data][data]];
                 totalRecord = [response[data][@"TOTAL_RECORD"] intValue];
                 
                 NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.iCommunityID CONTAINS[cd] %@",communityID];
                 NSArray *filterArray = [arrQuestions filteredArrayUsingPredicate:pred];
                 NSLog(@"FILTER ARRAAY %@",filterArray);
                 if (filterArray.count > 0)
                 {
                  
                     NSError *error;
                     CommunityListModel *model = [[CommunityListModel alloc] initWithDictionary:[filterArray objectAtIndex:0] error:&error];
                     [self performSegueWithIdentifier:@"segueComment" sender:model];
                 }
             }
         }
         
     } errorBlock:^(NSError *error)
     {
         
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrQuestions count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"NewsroomCellID";
    
    NSError *error;
    CommunityListModel *model = [[CommunityListModel alloc] initWithDictionary:[arrQuestions objectAtIndex:indexPath.row] error:&error];
    NewsroomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    cell.commentModel = model;
    cell.delegate = self;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([selectedCellIndexPath containsObject:indexPath])
    {
        [selectedCellIndexPath removeObject:indexPath];
    }
    else
    {
        [selectedCellIndexPath addObject:indexPath];
    }
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (IBAction)btnAddPressed:(id)sender
{
    [self performSegueWithIdentifier:@"segueAskCommunity" sender:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([selectedCellIndexPath containsObject:indexPath])
    {
        return UITableViewAutomaticDimension;
    }
    else
    {
        return 175;
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"segueComment"])
    {
        CommentVC *vc = (CommentVC *)segue.destinationViewController;
        CommunityListModel *community = (CommunityListModel *)sender;
        vc.communityID =  [NSString stringWithFormat:@"%d",community.iCommunityID];
    }
}


-(void)commentPressed:(CommunityListModel *)commentModel
{
    [self performSegueWithIdentifier:@"segueComment" sender:commentModel];
}

-(void)showMorePressed:(CommunityListModel *)commentModel
{
    
}

@end
