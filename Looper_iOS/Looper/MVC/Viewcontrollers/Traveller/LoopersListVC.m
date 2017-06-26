//
//  LoopersListVC.m
//  Looper
//
//  Created by hardik on 2/2/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "LoopersListVC.h"
#import "LooperCell.h"
#import "CustomTabbar.h"
#import "LooperListModel.h"
#import "UITableView+DragLoad.h"
#import "LooperDetailVC.h"
//#import "LooperAllListModel.h"

@interface LoopersListVC () <UITableViewDataSource,UITableViewDelegate,UITableViewDragLoadDelegate>
{
    NSMutableArray *arrLooperList;
    int nextPage;
    BOOL isAutoLogin;
    int totalRecord;
}

@property (strong, nonatomic) IBOutlet UITableView *tblLoopers;

@end

@implementation LoopersListVC
@synthesize tblLoopers;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareView];
    // Do any additional setup after loading the view.
}


-(void)prepareView
{
    arrLooperList = [[NSMutableArray alloc] init];
    
    tblLoopers.rowHeight = UITableViewAutomaticDimension;
    tblLoopers.estimatedRowHeight = 160;
    
    nextPage = 0;
    isAutoLogin = FALSE;
    totalRecord = 0;
    self.parentViewController.navigationController.navigationBarHidden = TRUE;
    self.navigationController.navigationBar.topItem.title = @"LOOPERS";
    
    [tblLoopers setDragDelegate:self refreshDatePermanentKey:@"LooperList"];
    tblLoopers.showLoadMoreView = YES;

    
    if (_dictSearchParam == nil)
    {
        [self allLoopers:NO];
    }
    else if (_dictSearchParam != nil && [LooperUtility getCurrentUser] == nil)
    {
        isAutoLogin = TRUE;// FOR EXPLORE CLICK // OR ARRANGE TABLECELL CONDITION LIKE GETCURREN USER DICT == NIL
        [self allLoopers:NO];
    }
    else
    {
        [self searchLooper:NO];
    }
    
    
    
//    UIButton *btnBack = [LooperUtility createBackButton];
//    
//    [btnBack addTarget:self action:@selector(btnBackPressed:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:btnBack] ;
//    
//    self.navigationController.navigationBar.topItem.leftBarButtonItem = backButton;
//    
//    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
//    
//    [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
    
//    [[CustomTabbar sharedInstance] setNavigationBarTitle:@"LOS ANGELES LOOPERS"];
//    [self.tabBarController setTitle:@"LOS ANGELES LOOPERS"];\
//    [self.tabBarController setTitle:@"Title"];
//    self.title = @"LOS ANGELES LOOPERS";

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DebugLog(@"VIEW WILL APPEAR CALLED");
}

-(void)allLoopers:(BOOL)isPullToRefresh
{
    if (_dictSearchParam == nil)
    {
        isAutoLogin = TRUE;
        _dictSearchParam = [[NSMutableDictionary alloc] initWithDictionary:@{@"iCityID":@"",@"pageid":[NSString stringWithFormat:@"%d",nextPage]}];
    }
    else
    {    [_dictSearchParam setObject:[NSString stringWithFormat:@"%d",nextPage] forKey:@"pageid"];}
    
    [[ServiceHandler sharedInstance].travelerWebService processGetLooperListWithParameter:_dictSearchParam SuccessBlock:^(NSDictionary *response)
     {
         if ([response objectForKey:success])
         {
             _dictSearchParam = nil;
             if (isPullToRefresh)
                 [self finishRefresh];
             else
                 [self finishLoadMore];

             return ;
         }
         totalRecord = [response[@"TOTAL_RECORD"] intValue];
         [arrLooperList addObjectsFromArray:[response[data] mutableCopy]];
         
         _dictSearchParam = nil;
         if (isPullToRefresh)
             [self finishRefresh];
         else
             [self finishLoadMore];
         
     } errorBlock:^(NSError *error)
     {
         _dictSearchParam = nil;
         
     }];
}

-(void)searchLooper:(BOOL)isPullToRefresh
{
    TravelerModel *model = [LooperUtility getTravelerProfile];
    
    [_dictSearchParam setObject:[NSString stringWithFormat:@"%d",nextPage] forKey:@"pageid"];
    [_dictSearchParam setObject:[[model.languages valueForKey:@"iLanguageID"] componentsJoinedByString:@","] forKey:@"iLanguageID"];
    [[ServiceHandler sharedInstance].travelerWebService processGetLooperListBySearchWithParameter:_dictSearchParam successBlock:^(NSDictionary *response)
     {
         if ([response objectForKey:success])
         {
//             _dictSearchParam = nil;
             if (isPullToRefresh)
                 [self finishRefresh];
             else
                 [self finishLoadMore];
             
             return ;
         }
         
         totalRecord = [response[@"TOTAL_RECORD"] intValue];
         [arrLooperList addObjectsFromArray:[response[data] mutableCopy]];
         if (isPullToRefresh)
             [self finishRefresh];
         else
             [self finishLoadMore];
         
     } errorBlock:^(NSError *error)
     {
         
     }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Drag delegate methods

- (void)dragTableDidTriggerRefresh:(UITableView *)tableView
{
    //send refresh request(generally network request) here
    nextPage = 0;
    arrLooperList = [[NSMutableArray alloc] init];
    [tblLoopers reloadData];
    if (_dictSearchParam == nil)
    {
        [self allLoopers:TRUE];
    }
    else
    {
        [self searchLooper:TRUE];
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
//    nextPage++;
    if (totalRecord != [arrLooperList count])
    {
        nextPage++;
        if (_dictSearchParam == nil)
        {
            [self allLoopers:NO];
        }
        else
        {
            [self searchLooper:NO];
        }
    }
    else
    {
        [self performSelector:@selector(finishLoadMore) withObject:nil afterDelay:2];    
    }

}

- (void)dragTableLoadMoreCanceled:(UITableView *)tableView
{
    //cancel load more request(generally network request) here
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(finishLoadMore) object:nil];
}

#pragma mark - Control datasource

- (void)finishRefresh
{
//    nextPage = 0;
    [tblLoopers finishRefresh];
    [tblLoopers reloadData];
    if (arrLooperList.count == 0)
    {
        [LooperUtility createAlertWithTitle:@"No match!" message:@"Please change criteria (passion, language...)" style:UIAlertControllerStyleAlert controller:self actionHandler:^(UIAlertAction *action) {
            
        }];
        
    }
}

- (void)finishLoadMore
{
//    nextPage += 1;
    [tblLoopers finishLoadMore];
    [tblLoopers reloadData];
    if (arrLooperList.count == 0)
    {
        [LooperUtility createAlertWithTitle:@"No match!" message:@"Please change criteria (passion, language...)" style:UIAlertControllerStyleAlert controller:self actionHandler:^(UIAlertAction *action) {
            
        }];
        
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrLooperList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"LooperCellID";
    
    LooperCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    if (_dictSearchParam == nil)
    {
        LooperObjModel *model = [[LooperObjModel alloc] initWithDictionary:[arrLooperList objectAtIndex:indexPath.row] error:nil];
        cell.modelLooper = model;
    }
    else if (_dictSearchParam != nil && isAutoLogin == TRUE)
    {
        LooperObjModel *model = [[LooperObjModel alloc] initWithDictionary:[arrLooperList objectAtIndex:indexPath.row] error:nil];
        cell.modelLooper= model;
    }
    else
    {
        LooperObjModel *model = [[LooperObjModel alloc] initWithDictionary:[arrLooperList objectAtIndex:indexPath.row] error:nil];
        cell.modelLooper = model;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_dictSearchParam == nil)
    {
        LooperObjModel *model = [[LooperObjModel alloc] initWithDictionary:[arrLooperList objectAtIndex:indexPath.row] error:nil];
        [self performSegueWithIdentifier:@"segueLooperDetail" sender:model];
    }
    else if (_dictSearchParam != nil && isAutoLogin == TRUE)
    {
        LooperObjModel *model = [[LooperObjModel alloc] initWithDictionary:[arrLooperList objectAtIndex:indexPath.row] error:nil];
        [self performSegueWithIdentifier:@"segueLooperDetail" sender:model];
    }
    else
    {
        LooperObjModel *model = [[LooperObjModel alloc] initWithDictionary:[arrLooperList objectAtIndex:indexPath.row] error:nil];
        [self performSegueWithIdentifier:@"segueLooperDetail" sender:model];
    }
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"segueLooperDetail"])
    {
        LooperDetailVC *looperVC = segue.destinationViewController;
        if ([sender isKindOfClass:[LooperObjModel class]])
        {
            LooperObjModel *objLooper = (LooperObjModel *)sender;
            looperVC.looperDetailObj = objLooper;
        }
//        else
//        {
//            LooperAllListModel *objLooper = (LooperAllListModel *)sender;
//            looperVC.looperDetailObjAll = objLooper;
//        }
        if (isAutoLogin)
        {
            LooperObjModel *objLooper = (LooperObjModel *)sender;
            looperVC.bookParameter = [[NSMutableDictionary alloc] initWithDictionary:@{@"iCityID":objLooper.iCityID}];
        }
        else
            looperVC.bookParameter = [[NSDictionary alloc] initWithDictionary:[_dictSearchParam mutableCopy]];
    }
}

- (IBAction)unwindToRed:(UIStoryboardSegue *)unwindSegue
{
    //segueLooperListVC
    if ([unwindSegue.identifier isEqualToString:@"segueLooperListVC"])
    {
        arrLooperList = [[NSMutableArray alloc] init];
        _dictSearchParam = nil;
       [self allLoopers:NO];
    }
}
@end
