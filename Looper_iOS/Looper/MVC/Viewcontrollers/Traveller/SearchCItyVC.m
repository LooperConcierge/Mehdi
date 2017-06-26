//
//  SearchCItyVC.m
//  Looper
//
//  Created by hardik on 5/23/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "SearchCItyVC.h"

@interface SearchCItyVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    NSMutableArray *arrCities;
}
@property (strong, nonatomic) IBOutlet UITableView *tblSearch;
@property (strong, nonatomic) IBOutlet UISearchBar *txtSearchBar;

@end

@implementation SearchCItyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - searchbar delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar// called when text starts editing
{
    searchBar.showsCancelButton = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar// called when text ends editing
{
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText// called when text changes (including clear)
{
    
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar// called when cancel button pressed
{
    _txtSearchBar.showsCancelButton = NO;
}

#pragma mark - uitableview delegate & datasource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellID"];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrCities count];
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
//https://maps.googleapis.com/maps/api/place/autocomplete/json?input=Flori&sensor=true&types=(cities)&key=AIzaSyDnerYSSNEhMsU-uyzGPoTaInO3-x9aR2c
