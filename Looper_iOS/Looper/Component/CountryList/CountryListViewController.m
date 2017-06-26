//
//  CountryListViewController.m
//  Country List
//
//  Created by Pradyumna Doddala on 18/12/13.
//  Copyright (c) 2013 Pradyumna Doddala. All rights reserved.
//

#import "CountryListViewController.h"
#import "CountryListDataSource.h"
#import "CountryCell.h"

@interface CountryListViewController ()<UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *dataRows;
@property (strong, nonatomic) NSArray *filterDataRows;
@property (strong, nonatomic) IBOutlet UISearchBar *txtSearchBar;
@end

@implementation CountryListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil delegate:(id)delegate
{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self) {
        // Custom initialization
        _delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    CountryListDataSource *dataSource = [[CountryListDataSource alloc] init];
    _dataRows = [dataSource countries];
    [_tableView reloadData];
    _txtSearchBar.placeholder = @"Search the country";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:TRUE animated:YES];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.name CONTAINS [cd] %@",searchText];
    NSLog(@"Search text %@",searchText);
    
    NSArray *filter  = [self.dataRows filteredArrayUsingPredicate:predicate];
    if (filter.count > 0)
    {
        _filterDataRows = filter;
        [_tableView reloadData];
    }
    NSLog(@"Filter array %@",filter);
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:false animated:YES];
    [searchBar resignFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = false;
    [searchBar resignFirstResponder];
}
#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_filterDataRows.count > 0)
        return  [self.filterDataRows count];
    else
        return [self.dataRows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    CountryCell *cell = (CountryCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[CountryCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    if (_filterDataRows.count > 0){
        cell.textLabel.text = [[_filterDataRows objectAtIndex:indexPath.row] valueForKey:kCountryName];
    cell.detailTextLabel.text = [[_filterDataRows objectAtIndex:indexPath.row] valueForKey:
                                 kCountryCallingCode];
    }
    else
    {
        cell.textLabel.text = [[_dataRows objectAtIndex:indexPath.row] valueForKey:kCountryName];
        cell.detailTextLabel.text = [[_dataRows objectAtIndex:indexPath.row] valueForKey:kCountryCallingCode];
    }
    
    
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_txtSearchBar resignFirstResponder];
}

#pragma mark -
#pragma mark Actions

- (IBAction)done:(id)sender
{
    if ([_delegate respondsToSelector:@selector(didSelectCountry:)]) {
        
        if (_filterDataRows.count > 0){
            [self.delegate didSelectCountry:[_filterDataRows objectAtIndex:[_tableView indexPathForSelectedRow].row]];
        }
        else
        {
            [self.delegate didSelectCountry:[_dataRows objectAtIndex:[_tableView indexPathForSelectedRow].row]];

        }

        [self dismissViewControllerAnimated:YES completion:NULL];
    } else {
        NSLog(@"CountryListView Delegate : didSelectCountry not implemented");
    }
}

- (IBAction)btnCancelPressed:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
@end
