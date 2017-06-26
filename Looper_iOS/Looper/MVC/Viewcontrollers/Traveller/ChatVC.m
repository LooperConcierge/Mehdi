//
//  ChatVC.m
//  Looper
//
//  Created by hardik on 3/22/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "ChatVC.h"
#import "ChatCell.h"
#import "UIColor+CustomColor.h"
#import "DatabaseManager.h"
#import "NSString+Hashes.h"
#import "FirebaseHelper.h"
#import "Messages.h"
#import "Chat.h"
#import <DateTools/DateTools.h>
#import "UIButton+AFNetworking.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "LoaderView.h"
#import "LooperListModel.h"
#import "LooperDetailVC.h"

#define Msg_Pagination 20

@interface ChatVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    NSMutableArray *arrChatMsg;
    int intTotalMessages;
    int totalPagesSingleChat;
    NSUInteger startMessageCounterSingleChat;
    int currentPageSingleChat;
    
}
@property (strong, nonatomic) IBOutlet UIView *viewHeader;
@property (strong, nonatomic) IBOutlet UITableView *tblChat;
@property (strong, nonatomic) IBOutlet UIButton *btnProfile;
@property (strong, nonatomic) IBOutlet UITextField *txtMessageField;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constantBottomOfSendview;

@end

@implementation ChatVC
@synthesize messageObj,strlastTime,isFromMessageVC;

- (void)viewDidLoad {
    [super viewDidLoad];

    _txtMessageField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    self.tblChat.rowHeight = UITableViewAutomaticDimension;
    self.tblChat.estimatedRowHeight = 160.0;
    self.tblChat.backgroundColor = [UIColor lightGrayBackgroundColor];
    self.btnProfile.layer.cornerRadius = CGRectGetWidth(self.btnProfile.frame)/2;
    self.btnProfile.layer.masksToBounds = YES;
    self.title = @"REGY PARLERA";

    currentPageSingleChat = 1;
    totalPagesSingleChat = 1;
//    [_btnProfile setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:otherUser[@"profilePic"]]];
        [_btnProfile setImageForState:UIControlStateNormal withURL:messageObj.urlReciverPhoto];
    
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    arrChatMsg = [[NSMutableArray alloc] init];
    
    self.title = [NSString stringWithFormat:@"%@",messageObj.strReciverName];
    
    [LoaderView showLoader];
    startMessageCounterSingleChat = 20;
    [self addObservForNewMessage];
    [self getTotalNumberOfChats];
    [self getListOfMessages];
    
//    self.title = [NSString stringWithFormat:@"%@,%@",[self.otherUser valueForKey:@"uName"],datestr];
    
    /*
    chatObj = [Chat fetchObjectWithID:messagePath];
    
    //Data base fetch request
    fetchController = [[NSFetchedResultsController alloc] initWithFetchRequest:[Messages fetchAllMessageObjWIth:chatObj] managedObjectContext:DatabaseSharedInstance.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    fetchController.delegate = self;
    NSError *error;
    [fetchController performFetch:&error];
    
    
    
    //Unread count manage
    NSDictionary  *currentUser = [DatabaseSharedInstance getCurrentUser];
    NSString *cUEmail = currentUser[@"uEmail"];
    cUEmail = [cUEmail sha1];
    
    arrMessage = [[NSMutableArray alloc] initWithArray:[Messages getMessagesOfChatId:messagePath Offset:0 fetchLimit:10]];
    
    
    [_tblChat reloadData];
    
    if (arrMessage.count == 0)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addMessage) name:@"kNotificationChatReceive" object:nil];
    }
    
    
    if (arrMessage.count != 0)
    {
        
        
        ref = [[FIRDatabase database] reference];
        
        [[ref child:[NSString stringWithFormat:@"%@/%@/%@/%@/unreadCount",FIREBASE_APP_USER,cUEmail,FIREBASE_APP_CHATS,messagePath]] setValue:@(0) withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
            
            if (error == nil)
            {
                chatObj.unreadCount = 0;
            }
        }];
    }
        

    
    
    NSString * oUEmail = [[otherUser valueForKey:@"value"]valueForKey:@"uEmail"];
    oUEmail = [oUEmail sha1];
    
    //Get recipient user unread count
    ref = [[FIRDatabase database] reference];
    
    [[ref child:[NSString stringWithFormat:@"%@/%@/%@/%@",FIREBASE_APP_USER,oUEmail,FIREBASE_APP_CHATS,messagePath]] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if (![snapshot.value isKindOfClass:[NSNull class]])
        {
            if ([snapshot.key isEqualToString:@"unreadCount"])
            {
                unReadCount = [snapshot.value intValue];
            }
            else
            {
                unReadCount = [snapshot.value[@"unreadCount"] intValue];
            }
        }
        
    }];
    
    //    Typing status
    self.title = [NSString stringWithFormat:@"%@",[self.otherUser valueForKey:@"uName"]];
    
    ref = [[FIRDatabase database] reference];
    
    [[ref child:[NSString stringWithFormat:@"%@/%@/%@",FIREBASE_APP_PERSISTANCE,oUEmail,messagePath]] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"Typing status changed");
        if ([snapshot.value intValue] == 1)
        {
            self.title = [NSString stringWithFormat:@"%@,%@",[self.otherUser valueForKey:@"uName"],@"typing..."];
            
        }
        else
            self.title = [NSString stringWithFormat:@"%@",[self.otherUser valueForKey:@"uName"]];
        
    }];

    
    [[ref child:[NSString stringWithFormat:@"%@/%@",FIREBASE_APP_PERSISTANCE,oUEmail]] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot)
     {
         if ([snapshot.key isEqualToString:@"status"])
         {
             if ([snapshot.value intValue] == 1)
                 isOnline =  TRUE;
             else
                 isOnline =  FALSE;
             
             
         }
         else if ([snapshot.key isEqualToString:@"timeStamp"])
         {
             if (isOnline)
             {
                 self.title = [NSString stringWithFormat:@"%@,%@",[self.otherUser valueForKey:@"uName"],@"Online"];
             }
             else
             {
                 NSTimeInterval t = [snapshot.value doubleValue];
                 double interval = t/1000;
                 NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
                 NSDateFormatter *df = [[NSDateFormatter alloc] init];
                 [df setDateFormat:@"dd/MM/yyyy hh:mm a"];
                 NSString *datestr =[df stringFromDate:date];
                 self.title = [NSString stringWithFormat:@"%@,%@",[self.otherUser valueForKey:@"uName"],datestr];
                 
             }
             
         }
         NSLog(@"Time stamp recipient changed");
         
     }];
*/
}

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

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [IQKeyboardManager sharedManager].enable = false;

}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [IQKeyboardManager sharedManager].enable = true;
//    [[FirebaseChatManager sharedInstance] removeObserverNewMessageInChatScreenWithIsGroup:false strUserId:messageObj.strSenderId strOtherId:messageObj.strReciverId completionHandler:^(BOOL success, NSDictionary *response)
//    {
//        
//    }];
}


/*
-(void)addMessage
{
    chatObj = [Chat fetchObjectWithID:messagePath];

    fetchController = [[NSFetchedResultsController alloc] initWithFetchRequest:[Messages fetchAllMessageObjWIth:chatObj] managedObjectContext:DatabaseSharedInstance.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    fetchController.delegate = self;
    NSError *error;
    [fetchController performFetch:&error];
    
    arrMessage = [[NSMutableArray alloc] initWithArray:[Messages getMessagesOfChatId:messagePath Offset:0 fetchLimit:10]];
    
    
    [_tblChat reloadData];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kNotificationChatReceive" object:nil];
}
*/
- (IBAction)btnSendMessagePressed:(id)sender
{
    NSString *msg = [self.txtMessageField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (msg.length > 0)
    {
        [self sendTextMessage];
        _txtMessageField.text = @"";
    }
    /*
    NSDictionary  *currentUser = [DatabaseSharedInstance getCurrentUser];
    NSString *cUEmail = currentUser[@"uEmail"];
    cUEmail = [cUEmail sha1];
    
    ref = [[FIRDatabase database] reference];
    
        
    [[ref child:[NSString stringWithFormat:@"%@/%@/%@/%@",FIREBASE_APP_USER,cUEmail,FIREBASE_APP_CHATS,messagePath]] setValue:@{FIREBASE_APP_PARTICIPANTS : @{@"p1":currentUser,@"p2":otherUser},                                              @"unreadCount":@(0)}];
    
    NSString * oUEmail = [otherUser valueForKey:@"uEmail"];
    oUEmail = [oUEmail sha1];
    
    ref = [[FIRDatabase database] reference];

    unReadCount++;
    [[ref child:[NSString stringWithFormat:@"%@/%@/%@/%@",FIREBASE_APP_USER,oUEmail,FIREBASE_APP_CHATS,messagePath]]
     setValue:@{FIREBASE_APP_PARTICIPANTS :@{@"p1":currentUser,@"p2":otherUser}
                ,@"unreadCount" : @(unReadCount)}];
    
    NSString *msg = [self.txtMessageField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (msg.length > 0)
        [[[ref child:[NSString stringWithFormat:@"%@/%@",FIREBASE_APP_MESSAGES,messagePath]]childByAutoId] setValue:@{@"text":msg,@"from":currentUser[@"uName"],@"to":otherUser[@"uName"],@"mID":messagePath,@"timestamp":[FIRServerValue timestamp]}];
    
    
    _txtMessageField.text = @"";

    [_txtMessageField resignFirstResponder];
    
    
    [[ServiceHandler sharedInstance].looperWebService processSendMessagePush:(AppdelegateObject.looperGlobalObject.isLooper?@"1":@"0") emailID:oUEmail message:msg SuccessBlock:^(NSDictionary *response) {
        
    } errorBlock:^(NSError *error) {
        
    }];
     */
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:true];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    if  (self.tblChat.indexPathsForVisibleRows.count != 0)
    {
        
        NSIndexPath *firstVisibleIndexPath = self.tblChat.indexPathsForVisibleRows[0];
        
        if (firstVisibleIndexPath.section == 0 && firstVisibleIndexPath.row == 0 && totalPagesSingleChat > currentPageSingleChat)
        {
            
            startMessageCounterSingleChat = startMessageCounterSingleChat + 20;
            currentPageSingleChat = currentPageSingleChat + 1;
            
            [LoaderView showLoader];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
               
                [[FirebaseChatManager sharedInstance] getListMessagesWithIsGroup:false strUserId:messageObj.strSenderId strOtherId:messageObj.strReciverId Counter:startMessageCounterSingleChat completionHandler:^(BOOL successe, NSArray * arrResponse)
                {
//                    [self getListOfMessages];
                    [LoaderView hideLoader];
                    
                    arrChatMsg = [[NSMutableArray alloc] initWithArray:arrResponse];
                    
                    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                                        initWithKey: @"messagetimestamp" ascending: YES];
                    
                    NSArray *sortedArray = [arrChatMsg sortedArrayUsingDescriptors: [NSArray arrayWithObject:sortDescriptor]];
                    
                    [arrChatMsg removeAllObjects];
                    
                    arrChatMsg = sortedArray.mutableCopy;
                    
                    NSMutableArray *arrDate = [[NSMutableArray alloc] init];
                    NSMutableArray *arrTemp1 = [[NSMutableArray alloc] init];
                    
                    for (NSDictionary *dict in arrChatMsg) {
                        
                        NSTimeInterval timeStamp = [dict[@"messagetimestamp"] doubleValue] / 1000;
                        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
                        NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
                        dateformatter.dateFormat = @"yyyy MMM dd";
                        NSString * strdate = [dateformatter stringFromDate:date];
                        
                        if (![arrDate containsObject:strdate])
                        {
                            [arrDate addObject:strdate];
                        }
                    }
                    
                    
                    for (NSString *strDate in arrDate)
                    {
                        
                        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                        dict[@"date"] = strDate;
                        NSMutableArray * arrTemp2 = [[NSMutableArray alloc] init];
                        
                        for (int k = 0 ; k < arrChatMsg.count ; k++)
                        {
                            NSDictionary * messageDict = [arrChatMsg objectAtIndex:k];
                            NSTimeInterval timeStamp = ([messageDict[@"messagetimestamp"] doubleValue])/1000;
                            NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
                            NSDateFormatter * dateformatter = [[NSDateFormatter alloc] init];
                            dateformatter.dateFormat = @"yyyy MMM dd";
                            NSString *strdate1 = [dateformatter stringFromDate:date];
                            
                            if ([strdate1 isEqualToString:strDate])
                            {
                                [arrTemp2 addObject:messageDict];
                            }
                        }
                        
                        
                        dict[@"messages"] = arrTemp2;
                        [arrTemp1 addObject:dict];
                    }
                    
                    [arrChatMsg removeAllObjects];
                    arrChatMsg = arrTemp1;
                    [_tblChat reloadData];
                    
                    if(arrChatMsg.count > 0) {
                        
                        NSUInteger numberOfSections = [self.tblChat numberOfSections];
                        NSUInteger numberOfRows = [self.tblChat numberOfRowsInSection:numberOfSections-1];
                        
                        if (numberOfRows > 0)
                        {
                            //let indexPath = NSIndexPath(forRow: numberOfRows-1, inSection: (numberOfSections-1))
                            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:numberOfRows-1 inSection:numberOfSections-1];
                            
                            [self.tblChat scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:true];
                            
                        }
                    }
                    
                    [self.tblChat scrollToRowAtIndexPath:firstVisibleIndexPath atScrollPosition:UITableViewScrollPositionTop animated:true];
                }];
                
            });
        }
    }
    
}


// MARK: - Custom Methods

-(void)reloadTable
{
    
    startMessageCounterSingleChat = startMessageCounterSingleChat + 1;
    intTotalMessages = intTotalMessages + 1;
    
    if (intTotalMessages % Msg_Pagination == 0)
    {
        totalPagesSingleChat = intTotalMessages / Msg_Pagination;
    }
    else {
        totalPagesSingleChat = (intTotalMessages / Msg_Pagination) + 1;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getListOfMessages];
    });
    
}

//MARK: - Chatting Methods

-(void)sendTextMessage
{
    
    MessageClass *messageDetail = [[MessageClass alloc] init];
    messageDetail.strMsgType = @"text";
    messageDetail.strMessage = _txtMessageField.text;
    messageDetail.strSenderId = messageObj.strSenderId;
    messageDetail.strReciverId = messageObj.strReciverId;
    messageDetail.strSenderName = messageObj.strSenderName;
    messageDetail.strMembers = @"";
    messageDetail.strReciverName = messageObj.strReciverName;
    messageDetail.urlReciverPhoto = messageObj.urlReciverPhoto;
    
    [[ServiceHandler sharedInstance].looperWebService processSendMessagePush:(AppdelegateObject.looperGlobalObject.isLooper?@"1":@"0") emailID:messageObj.strReciverId message:_txtMessageField.text SuccessBlock:^(NSDictionary *response) {
        
    } errorBlock:^(NSError *error) {
        
    }];
//    if(isGroupChat == false) {
//        FirebaseChatManager.sharedInstance.sendMessageInOneToOneChat(msgObject: messageDetial)
//    }
//    else {
//        FirebaseChatManager.sharedInstance.sendMessageInGroupChat(msgObject: messageDetial)
//    }
    [[FirebaseChatManager sharedInstance] sendMessageInOneToOneChatWithMsgObject:messageDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [arrChatMsg count];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellHeader"];
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    dateformatter.dateFormat = @"yyyy MMM dd";

    NSDate *checkDate = [dateformatter dateFromString:arrChatMsg[section][@"date"]];

    NSString *strToday =  [dateformatter stringFromDate:[NSDate date]];
    NSDate *today =  [dateformatter dateFromString:strToday];
    
    
    NSDate * dateTemp1 = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitDay value:-1 toDate:today options:0];
    
    
    NSString * strYesterDay = [dateformatter stringFromDate:dateTemp1];
    
    NSDate *yesterday = [dateformatter dateFromString:strYesterDay];
    
    UILabel *lblMessageTimeStamp = (UILabel *)[cell.contentView viewWithTag:100];
                                                 
    if ([arrChatMsg[section][@"date"]  isEqualToString:strToday]) {
        lblMessageTimeStamp.text = @"Today";
    } else if (checkDate == yesterday) {
        lblMessageTimeStamp.text = @"Yesterday";
    } else {
        NSDate *dt = [dateformatter dateFromString:arrChatMsg[section][@"date"]];
        [dateformatter setDateFormat:@"EEE, MMM yy"];
        NSString *dtStr = [dateformatter stringFromDate:dt];
        lblMessageTimeStamp.text = dtStr;
    }
    
    return cell;

}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *snp = [arrChatMsg objectAtIndex:section];
    NSArray *arrMessage = [snp valueForKey:@"messages"];

    return [arrMessage count];
}
/*
func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "DateHeader_Identifire") as! IDChatOtherCell
    
    let dateformatter = DateFormatter()
    dateformatter.dateFormat = "yyyy MMM dd"
    
    let checkDate = dateformatter.date(from: self.arrChatMsg[section]["date"] as! String)
    let strToday = dateformatter.string(from: Date())
    let today = dateformatter.date(from: strToday)
    //let dateTemp1 = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: -1, toDate: today!, options: NSCalendarOptions(rawValue: 0))
    
    let dateTemp1 = NSCalendar.current.date(byAdding: .day, value: -1, to: today!)
    
    let strYesterDay = dateformatter.string(from: dateTemp1!)
    let yesterday = dateformatter.date(from: strYesterDay)
    
    if self.arrChatMsg[section]["date"] as! String == strToday {
        cell.labelMessageTimeStamp?.text = "Today"
    } else if checkDate == yesterday {
        cell.labelMessageTimeStamp?.text = "Yesterday"
    } else {
        cell.labelMessageTimeStamp?.text = self.arrChatMsg[section]["date"] as? String
    }
    
    return cell
}
func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 40
}

func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 0
}
*/

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSDictionary *snp = [arrChatMsg objectAtIndex:indexPath.section];
    NSArray *arrMessage = [snp valueForKey:@"messages"];
//    NSTimeInterval timeInt = [snp.timestamp doubleValue];
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInt/1000];
//    NSString *dateStr = [date timeAgoSinceNow];
    
//    NSDictionary *currentUser = [[DatabaseManager sharedInstance] getCurrentUser];
    
    NSDictionary *messageDict = [arrMessage objectAtIndex:indexPath.row];
    
    if ([messageObj.strSenderId intValue] != [messageDict[@"senderid"] intValue])
    {
        static NSString *cellID = @"ReceiverCell";
        ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
        
        cell.imgLeftBubble.image = [[UIImage imageNamed:@"chatReceiver"] stretchableImageWithLeftCapWidth:24 topCapHeight:15];
        
        cell.imgLeftBubble.image = [cell.imgLeftBubble.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [cell.imgLeftBubble setTintColor:[UIColor darkGrayColor]];
        cell.lblDescription.text = messageDict[@"messgae"];
        cell.lblTime.text = [[FirebaseChatManager sharedInstance] getTimeFromTimeStempWithTimeStamp:[messageDict[@"messagetimestamp"] doubleValue]];

        return cell;
    }
    else
    {
        static NSString *cellID = @"SenderCell";
        ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
        
        cell.imgRightBubble.image = [[UIImage imageNamed:@"chatSender"] stretchableImageWithLeftCapWidth:24 topCapHeight:15];
        
        cell.lblRightDescription.text = messageDict[@"messgae"];
        cell.lblRightTime.text = [[FirebaseChatManager sharedInstance] getTimeFromTimeStempWithTimeStamp:[messageDict[@"messagetimestamp"] doubleValue]];
        return cell;
    }
    
    

}


/*
- (IBAction)btnLoadMorePressed:(id)sender
{
    NSArray *arrTemp = [[NSArray alloc] initWithArray:[Messages getMessagesOfChatId:messagePath Offset:[arrChatMsg count] fetchLimit:5]];
    
    for (Messages *msgObj in arrTemp)
    {
        [arrChatMsg insertObject:msgObj atIndex:0];
    }
    [_tblChat reloadData];
}
*/
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)addObservForNewMessage
{
    [[FirebaseChatManager sharedInstance] addObserveForNewMessageInChatScreenWithIsGroup:false strUserId:messageObj.strSenderId strLastTime:[NSString stringWithFormat:@"%f",strlastTime] strOtherId:messageObj.strReciverId completionHandler:^(BOOL success, NSDictionary *conversation)
    {
        [self reloadTable];
    }];
    

}

-(void)getTotalNumberOfChats
{
    [[FirebaseChatManager sharedInstance] totalNumberOfMessagesWithIsGroup:false strUserId:messageObj.strSenderId strOtherId:messageObj.strReciverId completionHandler:^(NSInteger totalMessage)
     {
         intTotalMessages = (int)totalMessage;
         
         if (intTotalMessages % Msg_Pagination == 0) {
             totalPagesSingleChat = intTotalMessages / Msg_Pagination;
         }
         else {
             totalPagesSingleChat = (intTotalMessages / Msg_Pagination) + 1;
         }

    }];

}

-(void)getListOfMessages
{
    [[FirebaseChatManager sharedInstance] getListMessagesWithIsGroup:false strUserId:messageObj.strSenderId strOtherId:messageObj.strReciverId Counter:startMessageCounterSingleChat completionHandler:^(BOOL isSuccess, NSArray * conversation)
     {

         [LoaderView hideLoader];
         
         arrChatMsg = [[NSMutableArray alloc] initWithArray:conversation];
         
         NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                             initWithKey: @"messagetimestamp" ascending: YES];
         
         NSArray *sortedArray = [arrChatMsg sortedArrayUsingDescriptors: [NSArray arrayWithObject:sortDescriptor]];
         
//         [arrChatMsg removeAllObjects];
         
         arrChatMsg = [[NSMutableArray alloc] initWithArray:sortedArray.mutableCopy];
         
         NSMutableArray *arrDate = [[NSMutableArray alloc] init];
         NSMutableArray *arrTemp1 = [[NSMutableArray alloc] init];
         
         for (NSDictionary *dict in arrChatMsg) {
             
             NSTimeInterval timeStamp = [dict[@"messagetimestamp"] doubleValue] / 1000;
             NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
             NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
             dateformatter.dateFormat = @"yyyy MMM dd";
             NSString * strdate = [dateformatter stringFromDate:date];
             
             if (![arrDate containsObject:strdate])
            {
                [arrDate addObject:strdate];
             }
         }
         
         
         for (NSString *strDate in arrDate)
            {
             
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                dict[@"date"] = strDate;
                NSMutableArray * arrTemp2 = [[NSMutableArray alloc] init];
             
                for (int k = 0 ; k < arrChatMsg.count ; k++)
                {
                    NSDictionary * messageDict = [arrChatMsg objectAtIndex:k];
                    NSTimeInterval timeStamp = ([messageDict[@"messagetimestamp"] doubleValue])/1000;
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
                    NSDateFormatter * dateformatter = [[NSDateFormatter alloc] init];
                    dateformatter.dateFormat = @"yyyy MMM dd";
                    NSString *strdate1 = [dateformatter stringFromDate:date];
                    
                    if ([strdate1 isEqualToString:strDate])
                    {
                        [arrTemp2 addObject:messageDict];
                    }
                }
             
             
                dict[@"messages"] = arrTemp2;
                [arrTemp1 addObject:dict];
         }
         
//         [arrChatMsg removeAllObjects];
         arrChatMsg = [[NSMutableArray alloc] initWithArray:arrTemp1];
         [self.tblChat reloadData];

         if(arrChatMsg.count > 0) {
             
             NSUInteger numberOfSections = [self.tblChat numberOfSections];
             NSUInteger numberOfRows = [self.tblChat numberOfRowsInSection:numberOfSections-1];
             
             if (numberOfRows > 0)
             {
                 //let indexPath = NSIndexPath(forRow: numberOfRows-1, inSection: (numberOfSections-1))
                 NSIndexPath * indexPath = [NSIndexPath indexPathForRow:numberOfRows-1 inSection:numberOfSections-1];
                 
                 [self.tblChat scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:true];
            
             }
         }
     }];
}

- (IBAction)btnProfilePressed:(id)sender
{
    if (isFromMessageVC == true)
    {
        [[ServiceHandler sharedInstance].travelerWebService processGetLooperDetailWithID:messageObj.strReciverId SuccessBlock:^(NSDictionary *response)
         {
             
             if([response[success] intValue] == 1)
             {
                 LooperObjModel *model = [[LooperObjModel alloc] initWithDictionary:response[data] error:nil];
                 
                 LooperDetailVC *looperVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LooperDetailVCID"];
                 
                 looperVC.looperDetailObj = model;
                 looperVC.isFromChat = true;
                 looperVC.bookParameter = [[NSMutableDictionary alloc] initWithDictionary:@{@"iCityID":model.iCityID}];
                 [self.navigationController pushViewController:looperVC animated:true];
                 
             }
         } errorBlock:^(NSError *error) {
             
         }];
    }
    
}


@end
