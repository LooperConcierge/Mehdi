//
//  BusinessDetailVC.m
//  Looper
//
//  Created by rakesh on 3/9/17.
//  Copyright © 2017 rakesh. All rights reserved.
//

#import "BusinessDetailVC.h"
#import "YelpClient.h"
#import "UIImageView+AFNetworking.h"
#import "TPFloatRatingView.h"

@interface BusinessDetailVC ()
{
    NSDictionary *responseDict;
}
@property (strong, nonatomic) IBOutlet UILabel *lblCategories;
@property (strong, nonatomic) IBOutlet UILabel *lblHours;
@property (strong, nonatomic) IBOutlet UILabel *lblAddress;
@property (strong, nonatomic) IBOutlet UILabel *lblNotes;
@property (strong, nonatomic) IBOutlet UIImageView *imgProfile;
@property (strong, nonatomic) IBOutlet UILabel *lblRating;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imgProfileHeight;
@property (strong, nonatomic) IBOutlet TPFloatRatingView *viewRating;
@property (strong, nonatomic) IBOutlet UITableView *tblBusiness;

@end

@implementation BusinessDetailVC
@synthesize businessID,notes;

- (void)viewDidLoad {
    [super viewDidLoad];
    _viewRating.emptySelectedImage = [UIImage imageNamed:@"starEmpty"];
    _viewRating.fullSelectedImage = [UIImage imageNamed:@"starFull"];
    _viewRating.contentMode = UIViewContentModeScaleAspectFill;
    _viewRating.maxRating = 5;
    _viewRating.minRating = 1;
    _viewRating.rating = 5;
    _viewRating.editable = NO;
    _viewRating.halfRatings = YES;
    _viewRating.floatRatings = NO;
    _viewRating.backgroundColor = [UIColor clearColor];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view layoutIfNeeded];
    [self callBusinessIDAPI];
}

-(void)callBusinessIDAPI
{
    [[YelpClient sharedInstance] searchBusinessWithID:businessID successBlock:^(NSDictionary *response) {
        responseDict = response;
        [self setupData];
    } errorBlock:^(NSError *error)
     {
         
     }];
}

-(void)setupData
{
    
    
    //    _imgProfile.contentMode = UIViewContentModeScaleToFill;
    
    __block UIImageView *tempImageView = _imgProfile;
    __block NSLayoutConstraint *tempConstant = _imgProfileHeight;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:responseDict[@"image_url"]]];
    
    [_imgProfile setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image)
     {
         if (image != nil)
         {
             tempImageView.image = image;
             tempConstant.constant = image.size.height;
         }
     } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
         
     }];
    
    NSArray *address = responseDict[@"location"][@"display_address"];
    NSArray *categories = [responseDict valueForKey:@"categories"];
    NSArray *titles = [categories valueForKey:@"title"];
    _lblAddress.text = [NSString stringWithFormat:@"%@",[address componentsJoinedByString:@", "]];
    _lblRating.text = [NSString stringWithFormat:@"%@ Reviews",responseDict[@"review_count"]];
    _lblCategories.text = [NSString stringWithFormat:@"%@",[titles componentsJoinedByString:@", "]];;
    
    if (notes != nil)
    {
        _lblNotes.text = notes;
    }
    
    _viewRating.rating = [responseDict[@"rating"] floatValue];
    
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* comp = [cal components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    NSInteger weekDay = [comp weekday];
    _lblHours.text = [NSString stringWithFormat:@"Today’s hours: not available"];
    if ([responseDict objectForKey:@"hours"])
    {
        NSArray *weekHours = responseDict[@"hours"];
        NSDictionary *weekDict;
        if (weekHours.count > 0)
        {
            weekDict = [weekHours firstObject];
        }
        if ([weekDict[@"is_open_now"] intValue] == 0)
        {
            _lblHours.text = [NSString stringWithFormat:@"Today’s hours: closed"];
        }
        else
        {
            if (weekHours.count > 0)
            {
//                NSDictionary *weekDict = [weekHours firstObject];
                if ([weekDict objectForKey:@"open"])
                {
                    NSArray *weekHoursArr = [weekDict objectForKey:@"open"];
                    for (NSDictionary *dict in weekHoursArr)
                    {
                        if ([dict[@"day"] integerValue] == weekDay)
                        {
                            
                            NSString *starDT = [self convertDTYelp:dict[@"start"]];
                            NSString *EndDT = [self convertDTYelp:dict[@"end"]];
                            if ([starDT isEqualToString:EndDT])
                            {
                                 _lblHours.text = [NSString stringWithFormat:@"Open 24 hours"];
                            }
                            else
                            {
                            _lblHours.text = [NSString stringWithFormat:@"Today’s hours: %@-%@",starDT,EndDT];
                            }
                            break;
                        }
                    }
                }
            }
        }
    }
    
    
    
    //    _lblAddress.text = [NSString stringWithFormat:@"%@",@"awdsdasdasasdas asdas asas as as as as  awdsdasdasasdas asdas asas as as as as  awdsdasdasasdas asdas asas as as as as  awdsdasdasasdas asdas asas as as as as awdsdasdasasdas asdas asas as as as as  awdsdasdasasdas asdas asas as as as as  awdsdasdasasdas asdas asas as as as as  awdsdasdasasdas asdas asas as as as as test123"];
    ////    [_lblAddress sizeToFit];
    //    _lblCategories.text = [NSString stringWithFormat:@"awdsdasdasasdas asdas asas as as as as awdsdasdasasdas asdas asas as as as as awdsdasdasasdas asdas asas as as as as awdsdasdasasdas asdas asas as as as as "];
    ////    [_lblCategories sizeToFit];
    //    _lblNotes.text = @"awdsdasdasasdas asdas asas as as as as awdsdasdasasdas asdas asas as as as as awdsdasdasasdas asdas asas as as as as awdsdasdasasdas asdas asas as as as as ";//notes;
    //    [_lblNotes sizeToFit];
}

-(NSString *)convertDTYelp:(NSString *)yelpString
{
    NSDateFormatter *formatter;
    NSString        *dateString = yelpString;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HHmm"];
    NSDate *date = [formatter dateFromString:dateString];
    [formatter setDateFormat:@"hh:mm a"];
    NSString        *startDt = [formatter stringFromDate:date];
    return startDt;
}

- (IBAction)btnMapPressed:(id)sender
{
    if (responseDict != nil)
    {
        [LooperUtility createOkAndCancelAlertWithTitle:@"Looper" message:@"Get directions to the business?" style:UIAlertControllerStyleAlert controller:self actionHandler:^(UIAlertAction *action) {
            
            if ([action.title.lowercaseString isEqualToString:@"OK".lowercaseString])
            {
                CLLocationCoordinate2D start = { AppdelegateObject.looperGlobalObject.locationManager.latitude, AppdelegateObject.looperGlobalObject.locationManager.longitude };
                CLLocationCoordinate2D destination = { [responseDict[@"coordinates"][@"latitude"]floatValue] ,[responseDict[@"coordinates"][@"longitude"] floatValue]};
                
                NSString *googleMapsURLString = [NSString stringWithFormat:@"http://maps.google.com/?saddr=%1.6f,%1.6f&daddr=%1.6f,%1.6f",
                                                 start.latitude, start.longitude, destination.latitude, destination.longitude];
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:googleMapsURLString]];
            }
        }];
        
    }
}

- (IBAction)btnCallPressed:(id)sender
{
    
    if (responseDict != nil)
    {
        [LooperUtility createOkAndCancelAlertWithTitle:@"Looper" message:@"Call the business?" style:UIAlertControllerStyleAlert controller:self actionHandler:^(UIAlertAction *action) {
            
            if ([action.title.lowercaseString isEqualToString:@"OK".lowercaseString])
            {
                NSString *phoneNumber = [@"tel://" stringByAppendingString:responseDict[@"phone"]];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
            }
        }];
    }
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

@end
