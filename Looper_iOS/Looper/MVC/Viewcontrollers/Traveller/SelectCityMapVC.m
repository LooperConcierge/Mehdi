//
//  SelectCityMapVC.m
//  Looper
//
//  Created by hardik on 2/2/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "SelectCityMapVC.h"
#import <GoogleMaps/GoogleMaps.h>
#import "CustomInfoWindow.h"
#import "CustomTabbar.h"
#import "UIView+AutoLayoutHideView.h"
#import "KLCPopup.h"
#import "SelectDateVC.h"

@interface SelectCityMapVC () <GMSMapViewDelegate,GMSAutocompleteViewControllerDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSDictionary *paramDictionary;
    KLCPopup *pop;
    BOOL isCityAvailable;
}

@property (strong, nonatomic) IBOutlet UIView *viewAvailableCity;
@property (strong, nonatomic) IBOutlet UITableView *tblCIty;
@property (strong, nonatomic) IBOutlet UITextField *txtSearch;
@property (strong, nonatomic) IBOutlet GMSMapView *googleMap;
@property (strong, nonatomic) IBOutlet UIButton *btnContinue;
@property (strong, nonatomic) IBOutlet UIView *vwSearch;
@property (strong, nonatomic) IBOutlet UIButton *btnSkip;
@end

@implementation SelectCityMapVC
@synthesize googleMap,btnContinue,txtSearch;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareView];
    // Do any additional setup after loading the view.
}

- (IBAction)btnSkipPressed:(id)sender
{
    [LooperUtility isAlreadyLoginTraveler];
}

-(void)prepareView
{
    isCityAvailable = FALSE;
    
    //    self.title = [[LooperUtility sharedInstance].localization localizedStringForKey:keySelectCity];
    self.title = @"SELECT DESTINATION";
    [self.vwSearch addDropShadow];
    btnContinue.titleLabel.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_MEDIUM_SIZE];
    [btnContinue setBackgroundColor:[UIColor lightRedBackgroundColor]];
    
    txtSearch.font = [UIFont fontAvenirWithSize:FONT_MEDIUM_SIZE];
    
    [btnContinue setTitle:[[LooperUtility sharedInstance].localization localizedStringForKey:keyContinue] forState:UIControlStateNormal];
    txtSearch.placeholder = [[LooperUtility sharedInstance].localization localizedStringForKey:keySelectLocation];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[LooperUtility sharedInstance].locationManager.latitude
                                                            longitude:[LooperUtility sharedInstance].locationManager.longitude
                                                                 zoom:6];
    
    googleMap.myLocationEnabled = false;
    googleMap.camera = camera;
    
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:[[CLLocation alloc] initWithLatitude:[LooperUtility sharedInstance].locationManager.latitude longitude:[LooperUtility sharedInstance].locationManager.longitude] completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        
        CustomMarker *marker = [[CustomMarker alloc] init];
        marker.position = camera.target;
        marker.snippet = placemark.addressDictionary[@"City"];
        NSLog(@"Place mark %@",placemark.addressDictionary);
        marker.appearAnimation = YES;
        marker.map = googleMap;
    }];
    
    
    
    _btnSkip.hidden = _isSkipHide;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnContinuePressed:(id)sender
{
    //    UIStoryboard *st = [UIStoryboard storyboardWithName:@"Traveler" bundle:nil];
    //    UINavigationController *navvc = [st instantiateViewControllerWithIdentifier:@"afterLoginID"];
    //    AppdelegateObject.window.rootViewController = navvc;
    
    if (paramDictionary.count == 0)
    {
        [AJNotificationView showNoticeInView:[[[UIApplication sharedApplication] delegate] window]
                                        type:AJNotificationTypeRed
                                       title:@"Please select a destination"
                             linedBackground:AJLinedBackgroundTypeDisabled
                                   hideAfter:2.5f];
        return;
    }
    else
    {
        UserModel *model = [LooperUtility getCurrentUser];
        //        open directly the looperlist screen if from the explore button
        if (model == nil)
        {
            UIStoryboard *st = [UIStoryboard storyboardWithName:@"Traveler" bundle:nil];
            CustomTabbar *tab = [st instantiateViewControllerWithIdentifier:@"CustomTabbarID"];
            tab.dictSearchParam = @{@"iCityID":paramDictionary[@"id"]};
            AppdelegateObject.window.rootViewController = tab;
        }
        else
        {
            if (isCityAvailable)
            {
                [self performSegueWithIdentifier:@"segueSelectDates" sender:nil];
            }
            else
            {
                [self openCityAlert];
            }
        }
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == txtSearch)
    {
        GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
        acController.delegate = self;
        
        GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
        filter.type  = kGMSPlacesAutocompleteTypeFilterCity;
        acController.autocompleteFilter = filter;
        [self presentViewController:acController animated:YES completion:nil];
        return NO;
    }
    return YES;
}

// Handle the user's selection.
- (void)viewController:(GMSAutocompleteViewController *)viewController
didAutocompleteWithPlace:(GMSPlace *)place {
    // Do something with the selected place.
    DebugLog(@"Place name %@", place.name);
    DebugLog(@"Place address %@", place.formattedAddress);
    txtSearch.text = place.formattedAddress;
    DebugLog(@"Place attributions %@", place.attributions.string);
    DebugLog(@"Place attributions %f %f", place.coordinate.latitude,place.coordinate.longitude);
    [googleMap clear];
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:[[CLLocation alloc] initWithLatitude:place.coordinate.latitude longitude:place.coordinate.longitude] completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        
        DebugLog(@"place mark %@", placemark.addressDictionary);
    }];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:place.coordinate.latitude
                                                            longitude:place.coordinate.longitude
                                                                 zoom:6];
    CustomMarker *marker = [[CustomMarker alloc] init];
    marker.position = camera.target;
    marker.snippet = place.name;
    marker.appearAnimation = YES;
    marker.map = googleMap;
    
    googleMap.camera = camera;
    
    paramDictionary = [LooperUtility checkCityAvailableInAppOrNot:txtSearch.text];
    
    isCityAvailable = FALSE;
    if (paramDictionary.count != 0)
    {
        isCityAvailable = TRUE;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    if (!isCityAvailable)
    {
        [self openCityAlert];
    }
}

- (void)viewController:(GMSAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error {
    // TODO: handle the error.
    NSLog(@"error: %ld", (long)[error code]);
    [self dismissViewControllerAnimated:YES completion:nil];
}

// User canceled the operation.
- (void)wasCancelled:(GMSAutocompleteViewController *)viewController {
    NSLog(@"Autocomplete was cancelled.");
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - GoogleMapview delegate method

-(UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker
{
    CustomInfoWindow *customView =[[[NSBundle mainBundle] loadNibNamed:@"CustomInfoWindow" owner:self options:nil] lastObject];
    customView.customMarkerObj = (CustomMarker *)marker;
    return customView;
}

-(void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker
{
    //    [self openPopUp];
}

#pragma mark - UItableviewcell

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[LooperUtility sharedInstance].arrCity count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellCityID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    UILabel *lbl = (UILabel *)[cell.contentView viewWithTag:1001];
    NSDictionary *dict = [[LooperUtility sharedInstance].arrCity objectAtIndex:indexPath.row];
    lbl.text = dict[@"vName"];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    paramDictionary = [[LooperUtility sharedInstance].arrCity objectAtIndex:indexPath.row];
    txtSearch.text = paramDictionary[@"vName"];
    isCityAvailable = TRUE;
    [pop dismiss:YES];
}

-(void)openPopUp
{
    pop = [KLCPopup popupWithContentView:self.viewAvailableCity showType:KLCPopupShowTypeSlideInFromTop dismissType:KLCPopupDismissTypeSlideOutToBottom maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
    
    [pop showAtCenter:self.view.center inView:self.view];
}

-(void)openCityAlert
{
    [LooperUtility createAlertWithTitle:@"We are on the way!" message:@"The selected destination is not available yet." style:UIAlertControllerStyleAlert controller:self actionHandler:^(UIAlertAction *action) {
        if ([[action.title lowercaseString] isEqualToString:@"ok"])
        {
            [self openPopUp];
        }
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"segueSelectDates"])
    {
        // set city for seach looper
        
        SelectDateVC *selectDate = segue.destinationViewController;
        selectDate.fromController = FROM_CITY_CONTROLLER;
        selectDate.paramDictionary = [[NSMutableDictionary alloc] initWithDictionary:@{@"iCityID":paramDictionary[@"id"]}];
    }
}

@end
