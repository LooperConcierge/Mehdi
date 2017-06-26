//
//  SelectLanguageVC.m
//  Looper
//
//  Created by hardik on 5/5/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "SelectLanguageVC.h"

@interface SelectLanguageVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *arraLanguage;
}

@property (strong, nonatomic) IBOutlet UITableView *tblLanguage;

@end

@implementation SelectLanguageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareView];
    // Do any additional setup after loading the view.
}

-(void)prepareView
{
    self.title = @"SELECT LANGUAGE";
    UIView *footerView = [[UIView alloc] init];
    _tblLanguage.tableFooterView = footerView;
    
    arraLanguage = [[NSArray alloc] init];
    
    [[ServiceHandler sharedInstance].webService processGetLanguagesWthSuccessBlock:^(NSDictionary *response)
    {
        if ([response isKindOfClass:[NSArray class]])
        {
            arraLanguage = [[NSArray alloc] initWithArray:(NSArray *)response];
        }
        [_tblLanguage reloadData];
        
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
    return [arraLanguage count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];

    NSDictionary *dict = arraLanguage[indexPath.row];
    UILabel *lbl = [cell.contentView viewWithTag:100];
    lbl.text = dict[@"vName"];
    
    if ([_contaionsLanguage containsObject:dict])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = arraLanguage[indexPath.row];
    
    if ([_contaionsLanguage containsObject:dict])
    {
        [_contaionsLanguage removeObject:dict];
    }
    else
    {
        [_contaionsLanguage addObject:dict];
    }
    [tableView reloadData];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

-(IBAction)btnSavePressed:(id)sender
{
    if (_contaionsLanguage.count == 0)
    {
        [AJNotificationView showNoticeInView:AppdelegateObject.window type:AJNotificationTypeRed title:@"Please select at least one language" linedBackground:AJLinedBackgroundTypeDisabled hideAfter:2.5];
        return;
    }
    [_selectLangDelegate languageArray:_contaionsLanguage];
    [self.navigationController popViewControllerAnimated:YES];
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
