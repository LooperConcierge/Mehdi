//
//  SelectInterestVC.m
//  Looper
//
//  Created by hardik on 2/2/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "SelectInterestVC.h"
#import "InterestCell.h"
#import "CustomTabbar.h"

@interface SelectInterestVC ()
{
    NSMutableArray *arrInterest;
    NSMutableArray *arrSelectedCell;
}
@property (strong, nonatomic) IBOutlet UILabel *lblSelectInterest;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionviewInterest;
@property (strong, nonatomic) IBOutlet UIButton *btnStartSearch;

@end

@implementation SelectInterestVC
@synthesize collectionviewInterest,btnStartSearch,lblSelectInterest,paramDictionary;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareView
{
    self.title = @"PASSIONS";//[[LooperUtility sharedInstance].localization localizedStringForKey:keySelectInterest];
//    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"ExpertiseList" ofType:@"plist"];
//    NSDictionary * values = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
//    arrInterest = [[NSMutableArray alloc] initWithArray:[values valueForKey:@"arrItem"]];
    arrInterest = [[NSMutableArray alloc] init];
    arrSelectedCell = [[NSMutableArray alloc] init];
    btnStartSearch.titleLabel.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_MEDIUM_SIZE];;
    lblSelectInterest.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_MEDIUM_SIZE];;
    
    if (_isFromBookController)
        [btnStartSearch setTitle:@"SELECT PASSION" forState:UIControlStateNormal];
    else
    [btnStartSearch setTitle:@"START SEARCHING" forState:UIControlStateNormal];
    
//    [lblSelectInterest setText:[[LooperUtility sharedInstance].localization localizedStringForKey:keySelectAtlease]];
    [lblSelectInterest setText:@"Select at least three"];
    
//    NSDictionary *param = @{@"iUserID" : [NSString stringWithFormat:@"%d",[LooperUtility getCurrentUser].iUserID]};
    
    [[ServiceHandler sharedInstance].webService processPassionListParameters:nil SuccessBlock:^(NSDictionary *response)
     {
         if ([response isKindOfClass:[NSArray class]])
         {
             NSArray *arrEx = response;
             for (NSDictionary *dict in arrEx)
             {
                 PassionModel *expModel = [[PassionModel alloc] initWithDictionary:dict error:nil];
//                 if ([expModel.isSelected isEqualToString:@"1"])
//                 {
//                     [arrSelectedCell addObject:expModel];
//                 }
                 [arrInterest addObject:expModel];
             }
             
                [collectionviewInterest reloadData];
         }
         
     } errorBlock:^(NSError *error)
     {
         
     }];

    
    
    
}

#pragma mark - CollectionView Delegate & Datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arrInterest.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"InterestCellID";
    
    InterestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    PassionModel *dict = [arrInterest objectAtIndex:indexPath.row];
    
    cell.interestDictionary = dict;
    
    if ([arrSelectedCell containsObject:dict])
        [cell setSelected:YES];
    else
        [cell setSelected:NO];

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    float widthCollectionCell = (collectionView.frame.size.width/3 - 10);

    return CGSizeMake(widthCollectionCell,widthCollectionCell);
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
//    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithDictionary:arrInterest[indexPath.row]];
//    
//    if ([dictionary[@"selected"] boolValue] == TRUE)
//    {
//        [dictionary setValue:[NSNumber numberWithBool:0] forKey:@"selected"];
//    }
//    else
//    {
//        [dictionary setValue:[NSNumber numberWithBool:1] forKey:@"selected"];
//    }
//    
//    [arrInterest replaceObjectAtIndex:indexPath.row withObject:dictionary];

    NSDictionary *dict = [arrInterest objectAtIndex:indexPath.row];
    
    if ([arrSelectedCell containsObject:dict])
    {
        [arrSelectedCell removeObject:dict];
    }
    else
    {
        [arrSelectedCell addObject:dict];
    }
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [arrInterest objectAtIndex:indexPath.row];
    
    if ([arrSelectedCell containsObject:dict])
    {
        [arrSelectedCell removeObject:dict];
    }

}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (IBAction)btnContinuePressed:(id)sender
{
//    [LooperUtility isAlreadyLoginTraveler];
//    [self performSegueWithIdentifier:@"segueLoopers" sender:nil];
//    if (arrSelectedCell.count < 3)
    if (arrSelectedCell.count == 0)
    {
        [LooperUtility createAlertWithTitle:@"Looper" message:@"Please select at least one passion" style:UIAlertControllerStyleAlert controller:self actionHandler:^(UIAlertAction *action) {
            
        }];
        return;
    }
    if (_isFromBookController)
    {
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"selected = 1"];
//        NSArray *filterArray = [arrInterest filteredArrayUsingPredicate:predicate];
//        NSArray *arrExpertiseId = [filterArray valueForKey:@"expertiseID"];
        NSArray *arrExpertiseId = [arrSelectedCell valueForKey:@"iExpertiseID"];
        NSString *strExpertiseID = [arrExpertiseId componentsJoinedByString:@","];
        [paramDictionary setObject:strExpertiseID forKey:@"iExpertiseID"];
        [self performSegueWithIdentifier:@"segueUnwindLooperDetailVC" sender:nil];
    }
    else
    {
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"selected = 1"];
//        NSArray *filterArray = [arrInterest filteredArrayUsingPredicate:predicate];
//        NSArray *arrExpertiseId = [filterArray valueForKey:@"expertiseID"];
        NSArray *arrExpertiseId = [arrSelectedCell valueForKey:@"iExpertiseID"];
        NSString *strExpertiseID = [arrExpertiseId componentsJoinedByString:@","];
        [paramDictionary setObject:strExpertiseID forKey:@"iExpertiseID"];
        
        UIStoryboard *st = [UIStoryboard storyboardWithName:@"Traveler" bundle:nil];
        CustomTabbar *tab = [st instantiateViewControllerWithIdentifier:@"CustomTabbarID"];
        tab.dictSearchParam = paramDictionary;
        AppdelegateObject.window.rootViewController = tab;
    }
}
@end
