//
//  LegalVC.m
//  Looper
//
//  Created by rakesh on 1/25/17.
//  Copyright © 2017 rakesh. All rights reserved.
//

#import "LegalVC.h"
#import "AboutUsVC.h"

@interface LegalVC ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tblview;

@end

@implementation LegalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Legal";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"SettingCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    UILabel *lbl = [cell.contentView viewWithTag:100];
    if (indexPath.row == 0)
    {
        lbl.text = @"Terms of service";
    }
    else
    {
        lbl.text = @"Privacy policy";
    }
    
    lbl.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_MEDIUM_SIZE];
    UILabel *lbl1 = [cell.contentView viewWithTag:102];
    lbl1.backgroundColor = [UIColor lightGrayBackgroundColor];
    
    if ( indexPath.row == 1)
    {
        [lbl1 setHidden:YES];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegue:indexPath];
}

-(void)performSegue:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        [self performSegueWithIdentifier:@"segueTerms" sender:@(1)];
    }
    else
    {
        [self performSegueWithIdentifier:@"segueTerms" sender:@(2)];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    AboutUsVC *vc = segue.destinationViewController;
    
    int index = [sender intValue];
    
    if (index == 1)
    {
        vc.openPageIndex = 1;
    }
    else
    {
        vc.openPageIndex = 2;
    }

}

@end
