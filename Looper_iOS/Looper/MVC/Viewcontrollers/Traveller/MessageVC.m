//
//  MessageVC.m
//  Looper
//
//  Created by hardik on 3/22/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "MessageVC.h"
#import "MessagingCell.h"
#import "FirebaseHelper.h"
#import "Messages.h"
#import "Chat.h"
#import "ChatParticipants.h"
#import "ChatVC.h"

@interface MessageVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *arrChats;
    NSString * messagePath;
    UserModel *user;
}

@property (strong, nonatomic) IBOutlet UITableView *tblMessage;
@property (strong, nonatomic) IBOutlet UIView *viewNoRecord;
@end

@implementation MessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareView];
    // Do any additional setup after loading the view.
}

-(void)prepareView
{
    messagePath = @"";
    self.navigationController.navigationBar.topItem.title = @"MESSAGES";
    self.parentViewController.navigationController.navigationBarHidden = TRUE;
 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"REFRESHRECENTCHATPROFILE" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"REFRESHRECENTCHAT" object:nil];
    [self reloadData];
}

-(void)reloadData
{

    NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"msgtime" ascending:false];
    [LooperUtility sharedInstance].arrRecentChat = [[LooperUtility sharedInstance].arrRecentChat sortedArrayUsingDescriptors:[NSArray arrayWithObject:sorter]];
    
    if ([LooperUtility sharedInstance].arrRecentChat.count == 0)
    {
        _tblMessage.tableHeaderView = _viewNoRecord;
    }
    else
    {
        _tblMessage.tableHeaderView = nil;
    }
    [_tblMessage reloadData];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    user = [LooperUtility getCurrentUser];
    if (user == nil)
    {
        [LooperUtility createAlertWithTitle:@"LOOPER" message:keyLoginFirst style:UIAlertControllerStyleAlert controller:self actionHandler:^(UIAlertAction *action) {
//            [LooperUtility navigateToLoginScreen:self.navigationController];
             [LooperUtility openLoginScreen];
        }];
        return;
    }
    [AppdelegateObject authenticateUser];
    
    NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"msgtime" ascending:true];
    [LooperUtility sharedInstance].arrRecentChat = [[LooperUtility sharedInstance].arrRecentChat sortedArrayUsingDescriptors:[NSArray arrayWithObject:sorter]];
    
    if ([LooperUtility sharedInstance].arrRecentChat.count == 0)
    {
        _tblMessage.tableHeaderView = _viewNoRecord;
    }
    else
    {
        _tblMessage.tableHeaderView = nil;
    }
    [_tblMessage reloadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[LooperUtility sharedInstance].arrRecentChat count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"MessageCellID";
    
    MessagingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    NSDictionary *chatMsg = [[LooperUtility sharedInstance].arrRecentChat objectAtIndex:indexPath.row];
    cell.chatDictionary = chatMsg;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *chatMsg = [[LooperUtility sharedInstance].arrRecentChat objectAtIndex:indexPath.row];
    
    UserModel *userObj = [LooperUtility getCurrentUser];
    MessageClass *message = [[MessageClass alloc] init];
    message.strMembers = @"";
    message.strReciverId = [NSString stringWithFormat:@"%@",chatMsg[@"userid"]];
    message.strSenderId = [NSString stringWithFormat:@"%d",userObj.iUserID];
    message.strSenderName = userObj.vFullName;
    message.strMsgType = @"text";
    message.strReciverName = chatMsg[@"name"];
    message.urlReciverPhoto = [NSURL URLWithString:[NSString stringWithFormat:@"%@",chatMsg[@"photo"]]];
    
    NSTimeInterval time = [chatMsg[@"msgtime"] doubleValue];
    ChatVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatVC"];
    vc.messageObj = message;
    vc.strlastTime = time;
    vc.isFromMessageVC = true;
    [self.navigationController pushViewController:vc animated:true];
//    Open above code for chat
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 53;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"segueChatCell"])
    {
        ChatVC *vc = segue.destinationViewController;
        vc.isFromMessageVC = true;
//        vc.otherUser = (NSDictionary *)sender;
//        vc.messagePath = messagePath;
    }
    
}


@end
