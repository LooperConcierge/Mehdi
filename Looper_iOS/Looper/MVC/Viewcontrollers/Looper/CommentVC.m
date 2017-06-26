//
//  CommentVC.m
//  Looper
//
//  Created by hardik on 3/26/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "CommentVC.h"
#import "CommentCell.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "AFNetworking.h"
//#import "UITableView+DragLoad.h"
//UITableViewDragLoadDelegate
#import "NetworkHandler.h"
#import "LoaderView.h"

@interface CommentVC ()<UITableViewDataSource,UITableViewDelegate>
{
    int totalRecords;
    NSMutableArray *arrComment;
    int nextPageid;
    ServiceHandler *service;
}
@property (strong, nonatomic) IBOutlet UIView *viewComment;
@property (strong, nonatomic) IBOutlet UILabel *lblComment;
@property (strong, nonatomic) IBOutlet UITableView *tblComment;
@property (strong, nonatomic) IBOutlet UITextField *txtComment;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constantBottomOfSendview;

@end

@implementation CommentVC
@synthesize tblComment,lblComment,communityID;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareView];
    // Do any additional setup after loading the view.
}


-(void)prepareView
{
    tblComment.rowHeight = UITableViewAutomaticDimension;
    tblComment.estimatedRowHeight = 160;
    lblComment.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_HEADER_SIZE];
//    [tblComment setDragDelegate:self refreshDatePermanentKey:@""];
//    tblComment.showLoadMoreView = YES;
    arrComment = [[NSMutableArray alloc] init];
    nextPageid = 0;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognize)];
    [self.tblComment addGestureRecognizer:tapGesture];
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[self class]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    _txtComment.autocapitalizationType = UITextAutocapitalizationTypeSentences;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [IQKeyboardManager sharedManager].enable = false;
    service = [ServiceHandler sharedInstance];
    [self performSelector:@selector(fetchCommentList) withObject:nil afterDelay:1];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [IQKeyboardManager sharedManager].enable = true;
}

-(void)tapGestureRecognize
{
    [self.view endEditing:YES];
}

-(void)fetchCommentList
{
    
    [service.looperWebService processCommentListWithCommunityID:[NSString stringWithFormat:@"%@",communityID] pageID:nextPageid SuccessBlock:^(NSDictionary *response)
        {
            nextPageid++;
            [arrComment addObjectsFromArray:response[data]];
            totalRecords = [response[@"TOTAL_RECORD"] intValue];
            
//            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dCreatedDate" ascending:NO];
//            [arrComment sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        
            [tblComment reloadData];
            [tblComment scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:arrComment.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            
        } errorBlock:^(NSError *error)
        {
            
        }];
    
    
    
//    [self commentListWithCommunityID:@"10" pageID:nextPageid SuccessBlock:^(NSDictionary *response) {
//        
//        nextPageid++;
//        [arrComment addObjectsFromArray:response[data]];
//        totalRecords = [response[@"TOTAL_RECORD"] intValue];
//        
//        //            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dCreatedDate" ascending:NO];
//        //            [arrComment sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
//        
//        [tblComment reloadData];
//        [tblComment scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:arrComment.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//        
//    } errorBlock:^(NSError *error)
//    {
//        
//    }];
}


-(void)commentListWithCommunityID:(NSString *)communityID
                                  pageID:(int)pageid
                            SuccessBlock:(void (^)(NSDictionary *))successBlock
                              errorBlock:(void (^)(NSError *))errorBlock
{
    
    [LoaderView showLoader];
    
    NSDictionary *param  = @{@"iCommunityID" : @([communityID intValue]),
                             @"pageid" : @(pageid)
                             };


       NetworkHandler *networkHandler = [[NetworkHandler alloc] initWithBaseUrl:[NSURL URLWithString:kBaseURL]];
    [networkHandler POST:@"community/commentList" parameters:param success:^(id responseObject)
     {
         [LoaderView hideLoader];
    
         
     } failure:^(NSError *error)
     {
         [LoaderView hideLoader];
         errorBlock(error);
     }];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrComment count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"CommentCellID";
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    NSDictionary *dict = [arrComment objectAtIndex:indexPath.row];
    cell.commentDict = dict;
    if (totalRecords != [arrComment count] && indexPath.row == [arrComment count]-1)
    {
        [self fetchCommentList];
    }
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void)keyboardWillShow:(NSNotification*) notification
{
    NSDictionary *userInfo = notification.userInfo;
    if (userInfo)
    {
        NSValue *keyboardFramBegin = userInfo[UIKeyboardFrameBeginUserInfoKey];
        CGRect keyboardFramebeginRect = [keyboardFramBegin CGRectValue];
        
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:500 initialSpringVelocity:5 options:UIViewAnimationOptionCurveLinear animations:^{
            
            self.constantBottomOfSendview.constant = keyboardFramebeginRect.size.height;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished)
         {
             
         }];
        
    } else
    {
        // no userInfo dictionary in notification
    }
    
}

-(void)keyboardDidHide:(NSNotification*) notification
{
    NSDictionary *userInfo = notification.userInfo;
    if (userInfo)
    {
        
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            self.constantBottomOfSendview.constant = 0;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished)
         {
             
         }];
        
    } else
    {
        // no userInfo dictionary in notification
    }
    
}


- (IBAction)btnCommentPressed:(id)sender
{
    if (![_txtComment.text isValidString])
    {
        [AJNotificationView showNoticeInView:AppdelegateObject.window type:AJNotificationTypeRed title:@"Please enter comment" linedBackground:AJLinedBackgroundTypeDisabled hideAfter:1.5];
        return;
    }
    [self.txtComment resignFirstResponder];
    
    [[ServiceHandler sharedInstance].looperWebService processAddCommentToCommunityWithID:[NSString stringWithFormat:@"%@",communityID] strComment:[_txtComment.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] SuccessBlock:^(NSDictionary *response)
    {
        [arrComment addObject:response[data][0]];
        totalRecords++;
        [tblComment reloadData];
        _txtComment.text = @"";
        [tblComment scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:arrComment.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    } errorBlock:^(NSError *error)
    {
        
    }];
    
}

- (IBAction)btnClosePressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
