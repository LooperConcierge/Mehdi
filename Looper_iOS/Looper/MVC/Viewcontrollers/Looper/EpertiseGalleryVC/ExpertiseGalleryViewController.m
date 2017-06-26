//
//  ExpertiseGalleryViewController.m
//  Looper
//
//  Created by Meera Dave on 30/01/16.
//  Copyright © 2016 looper. All rights reserved.
//
#define TITLE @"EXPERTISE"
#define CELL_IDENTIFIER @"ExpertiseCell"
#import "ExpertiseGalleryViewController.h"
#import "ExpertiseCollectionViewCell.h"
#import "TravellerListingViewController.h"
#import "PassionModel.h"

@interface ExpertiseGalleryViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
 IBOutlet UICollectionView *collectionViewExpertise;
    NSMutableArray *arrExpertise;
    NSMutableArray *arrSelectedCell;
    IBOutlet UILabel *lblInterest;
    IBOutlet UIButton *btnContinue;
    IBOutlet UIButton *btnTerms;
    IBOutlet UIView *viewTerms;
    IBOutlet UIWebView *webview;
}
@end

@implementation ExpertiseGalleryViewController

#pragma mark - VIEW LIFE CYCLE
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareView];

    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"expertise gallary vc disapear");
    
}

-(void)prepareView
{
    arrExpertise = [[NSMutableArray alloc] init];
    arrSelectedCell = [[NSMutableArray alloc] init];
    
    
    self.title = @"PASSIONS";
    lblInterest.font = [UIFont fontAvenirHeavyWithSize:FONT_MEDIUM_SIZE];
    btnContinue.titleLabel.font = [UIFont fontAvenirWithSize:FONT_MEDIUM_SIZE];
    lblInterest.text = @"Select at least three";
    
    //PRevious expertise list
//    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"ExpertiseList" ofType:@"plist"];
//    NSDictionary * values=[[NSDictionary alloc] initWithContentsOfFile:plistPath];
//    NSArray *arrayValues=[[NSArray alloc] initWithArray:[values valueForKey:@"arrItem"]];
//    [arrExpertise setArray:arrayValues];
    //END PREV
    [collectionViewExpertise registerNib:[UINib nibWithNibName:@"ExpertiseCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:CELL_IDENTIFIER];
    [collectionViewExpertise setAllowsMultipleSelection:YES];
    if (_IS_IPHONE_6) {
        [collectionViewExpertise setContentSize:CGSizeMake(collectionViewExpertise.bounds.size.width, 477)];
    } else {
        [collectionViewExpertise setContentSize:CGSizeMake(collectionViewExpertise.bounds.size.width, 400)];
        
    }
    
    btnContinue.hidden = false;
    if (AppdelegateObject.looperGlobalObject.isLooper && self.isProfileController == UPLOAD_DOCUMENT)
    {
        [btnContinue setTitle:@"COMPLETE REGISTRATION" forState:UIControlStateNormal];
    }
    else
    {
        [btnContinue setTitle:@"SAVE" forState:UIControlStateNormal];
        btnContinue.hidden = true;
    }
    
//    if ([LooperUtility sharedInstance].looperSignupDict != nil && [[LooperUtility sharedInstance].looperSignupDict objectForKey:@"vExpertises"])
//    {
//        NSArray *expertise = [[[LooperUtility sharedInstance].looperSignupDict valueForKey:@"vExpertises"] componentsSeparatedByString:@","];
//        
//        for (NSString *expertiseID in expertise)
//        {
//            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.expertiseID == %@",expertiseID];
//            NSArray *filterArray = [arrExpertise filteredArrayUsingPredicate:predicate];
//            if (filterArray.count > 0)
//            {
//                [arrSelectedCell addObject:[filterArray firstObject]];
//            }
//        }
//    }
    if (_arrContainsExpertise != nil)
        arrSelectedCell = [[NSMutableArray alloc] initWithArray:_arrContainsExpertise];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSDictionary *param = @{@"iUserID" : [NSString stringWithFormat:@"%d",[LooperUtility getCurrentUser].iUserID]};
    
    [[ServiceHandler sharedInstance].webService processPassionListParameters:param SuccessBlock:^(NSDictionary *response)
    {
        if ([response isKindOfClass:[NSArray class]])
        {
            NSArray *arrEx = response;
            for (NSDictionary *dict in arrEx)
            {
                PassionModel *expModel = [[PassionModel alloc] initWithDictionary:dict error:nil];
                if ([expModel.isSelected isEqualToString:@"1"])
                {
                    [arrSelectedCell addObject:expModel];
                }
                [arrExpertise addObject:expModel];
            }
    
            [collectionViewExpertise reloadData];
        }
        
    } errorBlock:^(NSError *error)
    {
        
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - CollectionView Delegate & Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return arrExpertise.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ExpertiseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    
    PassionModel *dict = [arrExpertise objectAtIndex:indexPath.row];
    
    [cell setValueOfCell:dict SetSingleTouch:NO];

    if ([arrSelectedCell containsObject:dict])
        [cell setSelected:YES];
    else
        [cell setSelected:NO];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    //float widthCollectionCell;
//    if (_IS_IPHONE_5) {
//         widthCollectionCell = (collectionView.frame.size.width/3 - 5);
//        return CGSizeMake(widthCollectionCell,widthCollectionCell-5);
//    } else {
//        widthCollectionCell = (collectionView.frame.size.width/3-10);
//         return CGSizeMake(widthCollectionCell,widthCollectionCell-10);
//   }
    float widthCollectionCell = (collectionView.frame.size.width/3 - 10);
    
    return CGSizeMake(widthCollectionCell,widthCollectionCell);
}

#pragma mark- IBAction Methods

- (IBAction)onTapCountinue:(id)sender {

    if (arrSelectedCell.count == 0)
    {
        [AJNotificationView showNoticeInView:AppdelegateObject.window type:AJNotificationTypeRed title:@"Please select at least one passion" linedBackground:AJLinedBackgroundTypeDisabled hideAfter:2.5];
        return;
    }
    
    if (self.isProfileController == UPLOAD_DOCUMENT)
    {
        [self completingRegister];
        
    }
    else
    {
        [_expertiseDelegate expertiseArray:arrSelectedCell];
        [self.navigationController popViewControllerAnimated:YES];
    }
//    if (AppdelegateObject.looperGlobalObject.isLooper)
//    {
//    }
//    else
//    {
//        [self performSegueWithIdentifier:@"segueTraveler" sender:nil];
//    }
//    TravellerListingViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TravellerListingViewController"];
//    [self.navigationController pushViewController:controller animated:YES];
}

-(NSString *)validateExpertise
{
    NSString *message = @"";
    
    if (arrSelectedCell.count == 0)
    {
        message = @"Please select the expertise first";
    }
    
    return message;
}

-(void)completingRegister
{
    NSString *message = [self validateExpertise];
    NSMutableArray *selectedExpertise = [[NSMutableArray alloc] init];
    
    if (message.length > 0 )
    {
        [AJNotificationView showNoticeInView:AppdelegateObject.window type:AJNotificationTypeRed title:message linedBackground:AJLinedBackgroundTypeDisabled hideAfter:2.5];
        return;
    }
    else
    {
        for (PassionModel *expertise in arrSelectedCell)
        {
            [selectedExpertise addObject:expertise.iExpertiseID];
        }
        [[LooperUtility sharedInstance].looperSignupDict setObject:[selectedExpertise componentsJoinedByString:@","] forKey:@"vExpertises"];
    }
    NSDictionary *images = [[LooperUtility sharedInstance].looperSignupDict valueForKey:@"images"];
//    [[LooperUtility sharedInstance].looperSignupDict removeObjectForKey:@"images"];
    NSMutableDictionary *nImageDict = [[NSMutableDictionary alloc] init];
    
    for (NSString *image in images.allKeys)
    {
        UIImage *currentImage = images[image];
        NSData *convertImage = UIImageJPEGRepresentation(currentImage, 0.1);
        UIImage *nImage = [UIImage imageWithData:convertImage];
        [nImageDict setObject:nImage forKey:image];
    }
    
    NSMutableDictionary *dictionaryToSend = [[NSMutableDictionary alloc] init];
    
    for (NSString *strKey in [LooperUtility sharedInstance].looperSignupDict.allKeys)
    {
        DebugLog(@"String key %@", strKey);
        if (![strKey isEqualToString:@"images"])
        {
            [dictionaryToSend setObject:[[LooperUtility sharedInstance].looperSignupDict valueForKey:strKey] forKey:strKey];
        }
    }
    
//    return;
    
    [[ServiceHandler sharedInstance].webService processLooperSignUp:dictionaryToSend imageData:nImageDict successBlock:^(NSDictionary *response)
     {
         NSString *userEmail = [LooperUtility sharedInstance].looperSignupDict[@"vEmail"];
         NSString *password = [LooperUtility sharedInstance].looperSignupDict[@"vPassword"];
         
         [LooperUtility sharedInstance].looperSignupDict = nil;
         

              NSError *errorUser;
              UserModel *userObject = [[UserModel alloc] initWithDictionary:response error:&errorUser];
              [LooperUtility settingCurrentUser:userObject];
              
              [LooperUtility isAlreadyLoginLooper:true];
              
     } errorBlock:^(NSError *error)
     {
         
     }];
    
    //Uncomment the above section for looper signup
//            [LooperUtility isAlreadyLoginLooper];//unComment this section for force signin
}

-(IBAction)OnTapCellSelected:(id)sender {
    
    CGPoint location = [sender locationInView:collectionViewExpertise];
    NSIndexPath *swipedIndexPath = [collectionViewExpertise indexPathForItemAtPoint:location];
    
    NSDictionary *dict = [arrExpertise objectAtIndex:swipedIndexPath.row];
    
    if (btnContinue.isHidden)
    {
        ExpertiseCollectionViewCell *cell = (ExpertiseCollectionViewCell *) [collectionViewExpertise cellForItemAtIndexPath:swipedIndexPath];
        
        if ([arrSelectedCell containsObject:dict])
        {
            [cell setSelected:YES];
        }
        else
        {
            [cell setSelected:NO];
        }
        return;
    }
    [arrSelectedCell addObject:dict];


}
-(IBAction)OnTapCellUnSelected:(id)sender {
    
    UIButton *button = (UIButton *) sender;
    ExpertiseCollectionViewCell *cell = (ExpertiseCollectionViewCell *)[[button superview] superview];
    NSIndexPath *indexPath = [collectionViewExpertise indexPathForCell:cell];
    
    NSDictionary *dict = [arrExpertise objectAtIndex:indexPath.row];
    if (btnContinue.isHidden)
    {
        ExpertiseCollectionViewCell *cell = (ExpertiseCollectionViewCell *) [collectionViewExpertise cellForItemAtIndexPath:indexPath];
        if ([arrSelectedCell containsObject:dict])
        {
            [cell setSelected:YES];
        }
        else
        {
            [cell setSelected:NO];
        }
        return;
        return;
    }
    
    
    if ([arrSelectedCell containsObject:dict])
    {
        [arrSelectedCell removeObject:dict];
    }
}

- (IBAction)btnTermsCheckBoxPressed:(id)sender
{
    btnTerms.selected = !btnTerms.selected;
}

- (IBAction)btnAgreePressed:(id)sender
{
//    if (btnTerms.selected)
//    {
    [UIView animateWithDuration:0.3 animations:^{
        viewTerms.alpha = 0;
             [self completingRegister];
    } completion: ^(BOOL finished) {//creates a variable (BOOL) called "finished" that is set to *YES* when animation IS completed.
        viewTerms.hidden = finished;//if animation is finished ("finished" == *YES*), then hidden = "finished" ... (aka hidden = *YES*)
    }];
//    }
//    else
//    {
//        [AJNotificationView showNoticeInView:[[[UIApplication sharedApplication] delegate] window]
//                                        type:AJNotificationTypeRed
//                                       title:@"Please check terms & condition box"
//                             linedBackground:AJLinedBackgroundTypeDisabled
//                                   hideAfter:2.5f];
//    }
}
- (IBAction)btnDisAgreePressed:(id)sender
{
    
        [UIView animateWithDuration:0.3 animations:^{
            viewTerms.alpha = 0;
        } completion: ^(BOOL finished) {//creates a variable (BOOL) called "finished" that is set to *YES* when animation IS completed.
            viewTerms.hidden = finished;//if animation is finished ("finished" == *YES*), then hidden = "finished" ... (aka hidden = *YES*)
        }];
    
}

@end
