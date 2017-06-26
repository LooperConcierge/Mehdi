//
//  LooperDetailVC.m
//  Looper
//
//  Created by hardik on 2/3/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "LooperDetailVC.h"
#import "LooperDetailCell.h"
#import "LooperDetailCellImage.h"
#import "LooperHeaderView.h"
#import "TravelerCalendarVC.h"
#import "BookLooperView.h"
#import "UIImageView+LBBlurredImage.h"
#import "UIImage+ImageEffects.h"
#import "UIImageView+AFNetworking.h"
#import "SelectDateVC.h"
#import "ChatVC.h"
#import <Looper-Swift.h>


@interface LooperDetailVC () <UITableViewDelegate,UITableViewDataSource,BookLooperViewDelegate>
{
    NSMutableArray *arrProfileData;
    BookLooperView *looperView;
}

@property (strong, nonatomic) IBOutlet UITableView *tblLooper;
@property (strong, nonatomic) IBOutlet UIView *tblHeaderView;

@property (strong, nonatomic) IBOutlet UIView *tblFooterView;
@property (strong, nonatomic) IBOutlet UIView *viewBackGround;

#pragma mark - header view outlets

@property (strong, nonatomic) IBOutlet UIImageView *imgProfile;
@property (strong, nonatomic) IBOutlet UILabel *lblLooperName;
@property (strong, nonatomic) IBOutlet UILabel *lblLooperCity;
@property (strong, nonatomic) IBOutlet UILabel *lblLooperExpertise;
@property (strong, nonatomic) IBOutlet UILabel *lblLooperRate;
@property (strong, nonatomic) IBOutlet UILabel *lblLooperDaily;
@property (strong, nonatomic) IBOutlet UIImageView *imgBlurLooperProfile;
@property (strong, nonatomic) IBOutlet UIButton *btnInquire;
@property (strong, nonatomic) IBOutlet UIButton *btnBook;
@property (strong, nonatomic) IBOutlet UIView *imgProfileBackView;

@end

@implementation LooperDetailVC

@synthesize tblFooterView,tblHeaderView,tblLooper,viewBackGround,imgBlurLooperProfile,imgProfile,lblLooperCity,lblLooperDaily,lblLooperExpertise,lblLooperName,lblLooperRate,imgProfileBackView,btnBook,btnInquire,looperDetailObj,isFromChat;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareView];
    // Do any additional setup after loading the view.
}

-(void)prepareView
{
    lblLooperName.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_HEADER_SIZE];
    lblLooperCity.font = [UIFont fontAvenirHeavyWithSize:14];
    lblLooperExpertise.font = [UIFont fontAvenirHeavyWithSize:13];
    lblLooperRate.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_HEADER_SIZE];
    lblLooperDaily.font = [UIFont fontAvenirHeavyWithSize:13];
    btnInquire.titleLabel.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_HEADER_SIZE];
    btnBook.titleLabel.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_HEADER_SIZE];
    lblLooperCity.textColor = [LooperUtility sharedInstance].appThemeColor;
    [btnBook setTitle:[[LooperUtility sharedInstance].localization localizedStringForKey:keyBook] forState:UIControlStateNormal];
    [btnInquire setTitle:[[LooperUtility sharedInstance].localization localizedStringForKey:keyInquire] forState:UIControlStateNormal];
    [self setTableHeaderview];
//    self.title = @"RYAN'S PROFILE";
    self.title = looperDetailObj.vFullName;
}

-(void)createArrayData
{

    arrProfileData = [[NSMutableArray alloc] init];
//    @"ABOUT ME"
    NSDictionary *dictAboutMe = @{@"sectionTitle":[[LooperUtility sharedInstance].localization localizedStringForKey:keyAboutMe],@"description" : @[@{@"imageName" : @"",@"expertiseTitle" :looperDetailObj.vAbout}]};
    
    [arrProfileData addObject:dictAboutMe];
    
    NSArray *arrLanguage = looperDetailObj.languages;
    NSString *strLanguage = [[arrLanguage valueForKey:@"vName"] componentsJoinedByString:@", "];
    NSDictionary *dictLanguages = @{@"sectionTitle":[[LooperUtility sharedInstance].localization localizedStringForKey:keyLanguages],@"description" : @[@{@"imageName" : @"",@"expertiseTitle" : strLanguage}]};
    
    [arrProfileData addObject:dictLanguages];

    //    @"EXPERTISE"
    NSMutableArray *arrExpert = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dict in looperDetailObj.expertises)
    {
        NSDictionary *dictNew = @{@"imageName" : dict[@"image"],
                                  @"expertiseTitle": dict[@"vName"]};
        [arrExpert addObject:dictNew];
    }
    
    NSDictionary *dictExpertise = @{@"sectionTitle":[[LooperUtility sharedInstance].localization localizedStringForKey:keyExpertise],@"description" : arrExpert};
    
    [arrProfileData addObject:dictExpertise];
    
    [tblLooper reloadData];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(void)setTableHeaderview
{
//    ASPECT RATIO ARROUND 184/504
    
    CGFloat tableHeaderHeight = tblHeaderView.frame.size.height;
    CGFloat aspectratio = (tableHeaderHeight/(viewBackGround.frame.size.height-9));
    DebugLog(@"%f",(tableHeaderHeight/(viewBackGround.frame.size.height-9)));
    
    CGFloat newHeight = tableHeaderHeight * aspectratio;
    //        tblLooper.tableHeaderView.frame = CGRectMake(0, 0, tblLooper.frame.size.width,tblLooper.tableHeaderView.frame.size.height +newHeight);
    DebugLog(@"new height %f",tblLooper.tableHeaderView.frame.size.height +newHeight);
    
    if (_IS_IPHONE_6)
    {
         tblLooper.tableHeaderView.frame = CGRectMake(0, 0, tblLooper.frame.size.width, 240);
    }
    else if (_IS_IPHONE_6P)
    {
        tblLooper.tableHeaderView.frame = CGRectMake(0, 0, tblLooper.frame.size.width,270);
    }
    tblLooper.tableHeaderView = tblHeaderView;
    
    
// UPDATING CONSTRAINTS ACCORDING TO IPHONE 6 6+
    [imgProfile setNeedsLayout];
    [imgProfile layoutIfNeeded];
    [imgProfileBackView setNeedsLayout];
    [imgProfileBackView layoutIfNeeded];
    
    tblLooper.rowHeight = UITableViewAutomaticDimension;
    tblLooper.estimatedRowHeight = 160;

    [LooperUtility roundUIImageView:imgProfile];
    [LooperUtility roundUIViewWithTransparentBackground:imgProfileBackView];
    
    [imgProfile setImageWithURL:[NSURL URLWithString:looperDetailObj.vProfilePic] placeholderImage:imgProfile.image];
//    [imgBlurLooperProfile setImageToBlur:imgBlurLooperProfile.image blurRadius:8 completionBlock:^{
//        DebugLog(@"The blurred image has been set");
//    }];
    
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:looperDetailObj.vProfilePic]];
    
    __block UIImageView *tempImageview = imgBlurLooperProfile;
    
    [imgBlurLooperProfile setImageWithURLRequest:req placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        
        [tempImageview setImageToBlur:image blurRadius:8 completionBlock:^{
            DebugLog(@"The blurred image has been set");
        }];
        
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        
        [tempImageview setImageToBlur:tempImageview.image blurRadius:8 completionBlock:^{
            DebugLog(@"The blurred image has been set");
        }];

    }];
    
    lblLooperName.text = looperDetailObj.vFullName;
    lblLooperCity.text = looperDetailObj.vCity;
    lblLooperRate.text = [NSString stringWithFormat:@"$%.0f",looperDetailObj.iRates];
    NSString *strExpertise = [[looperDetailObj.expertises valueForKey:@"vName"] componentsJoinedByString:@", "];
    lblLooperExpertise.text = [NSString stringWithFormat:@"%@",strExpertise];
    
    [self createArrayData];
    [tblLooper reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Mark - Tableview delegate & datasourse methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dict = [arrProfileData objectAtIndex:section];
    NSArray *arr = [dict valueForKey:@"description"];
    return [arr count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [arrProfileData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0 || indexPath.section == 1)
    {
        static NSString *cellID = @"LooperDetailCell";
        //    LooperDetailCellImage
        LooperDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
        
        NSDictionary *dict = [arrProfileData objectAtIndex:indexPath.section];
        NSArray *arr = [dict valueForKey:@"description"];
        
        if (arr.count > 0)
        {
            NSDictionary *values = arr[indexPath.row];
            cell.lblDescription.text = values[@"expertiseTitle"];
        }
        
        
        return cell;
    }
    else
    {
        static NSString *cellID = @"LooperDetailCellWithImage";
        //    LooperDetailCellImage
        LooperDetailCellImage *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
        
        NSDictionary *dict = [arrProfileData objectAtIndex:indexPath.section];
        NSArray *arr = [dict valueForKey:@"description"];
        
        if (arr.count > 0)
        {
            NSDictionary *values = arr[indexPath.row];
            cell.lblLooperExpertiseName.text = values[@"expertiseTitle"];
//            cell.imgLooperExpertise.image = [UIImage imageNamed:values[@"imageName"]];
            [cell.imgLooperExpertise setImageWithURL:[NSURL URLWithString:values[@"imageName"]]];
        }
        
        
        return cell;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *headerReuseIdentifier = @"LooperHeader";

    NSDictionary *dictHeader = [arrProfileData objectAtIndex:section];
    
    // ****** Do Step Two *********
    LooperHeaderView *sectionHeaderView = [tableView dequeueReusableCellWithIdentifier:headerReuseIdentifier];

    sectionHeaderView.lblHeaderName.text = dictHeader[@"sectionTitle"];
    sectionHeaderView.lblHeaderName.textColor = [LooperUtility sharedInstance].appThemeColor;
    return sectionHeaderView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 15)];
    
    view.backgroundColor = [UIColor blackColor];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1 || section == 0)
    {
        return 0;
    }
    return 15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 52;
}


#pragma mark - Private methods
- (IBAction)btnInquirePressed:(id)sender
{

    UserModel *user = [LooperUtility getCurrentUser];
    if (user == nil)
    {
        [LooperUtility createAlertWithTitle:@"LOOPER" message:keyLoginFirst style:UIAlertControllerStyleAlert controller:self actionHandler:^(UIAlertAction *action) {
            //            [LooperUtility navigateToLoginScreen:self.navigationController];
            [LooperUtility openLoginScreen];
            
        }];
        return;
    }

    UserModel *userObj = [LooperUtility getCurrentUser];
    MessageClass *message = [[MessageClass alloc] init];
    message.strMembers = @"";
    message.strReciverId = [NSString stringWithFormat:@"%d",looperDetailObj.iUserID];
    message.strSenderId = [NSString stringWithFormat:@"%d",userObj.iUserID];
    message.strSenderName = userObj.vFullName;
    message.strMsgType = @"text";
    message.strReciverName = looperDetailObj.vFullName;
    message.urlReciverPhoto = [NSURL URLWithString:[NSString stringWithFormat:@"%@",looperDetailObj.vProfilePic]];

    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    double milisecond = time * 1000;
    ChatVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatVC"];
    vc.messageObj = message;
    vc.strlastTime = milisecond;
    [self.navigationController pushViewController:vc animated:YES];
    /*
    NSDictionary *currentUser = [[DatabaseManager sharedInstance] getCurrentUser];
    
    NSString *emailStr = [NSString stringWithFormat:@"%@%@",looperDetailObj.vEmail,currentUser[@"uEmail"]];
 
    NSString * messagePath = [FBManagerSharedInstance sortStringAlphabatically:emailStr];

    NSDictionary *dict = @{@"uEmail" : looperDetailObj.vEmail,@"uName":looperDetailObj.vFullName,@"profilePic":looperDetailObj.vProfilePic};
    
    ChatVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatVC"];
    vc.otherUser = dict;
    vc.messagePath = messagePath;
    
    
    
    [self.navigationController pushViewController:vc animated:YES];
*/
//    open above commented code for chat
}

- (IBAction)btnBookPressed:(id)sender
{

    UserModel *user = [LooperUtility getCurrentUser];
    if (user == nil)
    {
        [LooperUtility createAlertWithTitle:@"LOOPER" message:keyLoginFirst style:UIAlertControllerStyleAlert controller:self actionHandler:^(UIAlertAction *action) {
//            [LooperUtility navigateToLoginScreen:self.navigationController];
             [LooperUtility openLoginScreen];
            
        }];
       return;
    }

    [tblLooper setContentOffset:CGPointZero animated:YES];

    if(_bookParameter.count != 1)
    {
        [self openBookingTripView];
    }
    else
    {
//        [LooperUtility createAlertWithTitle:@"Book" message:[NSString stringWithFormat:@"Do you want to book looper for city %@",looperDetailObj.vCity] style:UIAlertControllerStyleAlert controller:self actionHandler:^(UIAlertAction *action) {
//                if ([action.title isEqualToString:@"OK"])
//                {
//                    SelectDateVCID
                    SelectDateVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectDateVCID"];
                    vc.fromController = FROM_BOOK_LOOPERCONTROLLER;
                    [self.navigationController pushViewController:vc animated:YES];
//                }
//        }];
    }
    
}

-(void)openBookingTripView
{
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    
    looperView = [[[NSBundle mainBundle] loadNibNamed:@"BookLooperView" owner:self options:nil] lastObject];
    
    //    looperView.frame = window.frame;
//    if (looperDetailObj == nil)
//        looperView.looperAllModel = looperDetailObjAll;
//    else
        looperView.looperModel = looperDetailObj;
    
    looperView.dictLooperBooking = [[NSMutableDictionary alloc] initWithDictionary:_bookParameter];
    looperView.userTyp = TRAVELER_DETAIL;
    looperView.delegate = self;
    looperView.image = [LooperUtility screenshotOfWholeScreen];
    [looperView drawRect:window.frame];
    
    //    looperView.center = window.center;
    [window insertSubview:looperView aboveSubview:self.view];
    [window bringSubviewToFront:looperView];

}

-(void)removeView:(BOOL)isDone
{
    if (isDone)
    {
        
    }
    else
    {
        _bookParameter = @{@"iCityID":_bookParameter[@"iCityID"]};
        [looperView removeFromSuperview];
    }
}

-(void)removeViewAndPopToViewController
{
    [looperView removeFromSuperview];
    if (isFromChat == true)
    {
        [self.navigationController popViewControllerAnimated:true];
    }
    else
    {
        [self performSegueWithIdentifier:@"segueLooperListVC" sender:nil];
    }
}

- (IBAction)unwindLooperDetailVC:(UIStoryboardSegue *)unwindSegue
{
    DebugLog(@"VIEW CONTROLLER %@", unwindSegue.sourceViewController);
//    SelectInterestVC *selectInterestVC = (SelectInterestVC *)unwindSegue.sourceViewController;
    SelectDateVC *selectDateVC = (SelectDateVC *)unwindSegue.sourceViewController;
    DebugLog(@"Param %@", selectDateVC.paramDictionary);
    [selectDateVC.paramDictionary setObject:[[looperDetailObj.expertises valueForKey:@"iExpertiseID"] componentsJoinedByString:@","] forKey:@"iExpertiseID"];
    NSString *iCityID = _bookParameter[@"iCityID"];
    NSMutableDictionary *dict = [selectDateVC.paramDictionary mutableCopy];
    [dict setObject:iCityID forKey:@"iCityID"];
    _bookParameter = [[NSDictionary alloc] initWithDictionary:dict];
    
    [self performSelector:@selector(openBookingTripView) withObject:nil afterDelay:0.4];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    BookLooperVC *vc = segue.destinationViewController;
//    vc.imageBackGround = [LooperUtility screenshotOfWholeScreen];
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


-(void)messageBtnPressed
{
    [looperView removeFromSuperview];
    [self btnInquirePressed:nil];
}
@end
