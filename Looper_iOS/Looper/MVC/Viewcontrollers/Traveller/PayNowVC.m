//
//  PayNowVC.m
//  Looper
//
//  Created by hardik on 3/25/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "PayNowVC.h"
#import "UIImageView+AFNetworking.h"

@interface PayNowVC ()

@property (strong, nonatomic) IBOutlet UIImageView *imgProfile;
@property (strong, nonatomic) IBOutlet UIImageView *imgBackgroundProfile;
@property (strong, nonatomic) IBOutlet UIView *viewBgProfile;
@property (strong, nonatomic) IBOutlet UILabel *lblAboutMe;
@property (strong, nonatomic) IBOutlet UILabel *lblAboutMeDescription;
@property (strong, nonatomic) IBOutlet UILabel *lblTripDetail;
@property (strong, nonatomic) IBOutlet UILabel *lblTripDate;
@property (strong, nonatomic) IBOutlet UILabel *lblTripDuration;
@property (strong, nonatomic) IBOutlet UILabel *lblDays;
@property (strong, nonatomic) IBOutlet UILabel *lblActualDays;
@property (strong, nonatomic) IBOutlet UILabel *lblRate;
@property (strong, nonatomic) IBOutlet UILabel *lblActualRate;
@property (strong, nonatomic) IBOutlet UILabel *lblAmount;
@property (strong, nonatomic) IBOutlet UILabel *lblActualAmount;
@property (strong, nonatomic) IBOutlet UIButton *btnPay;
@property (strong, nonatomic) IBOutlet UILabel *lblLooperName;
@property (strong, nonatomic) IBOutlet UILabel *lblLooperCityName;
@property (strong, nonatomic) IBOutlet UILabel *lblLooperResponse;
@property (strong, nonatomic) IBOutlet UILabel *lblLooperRate;
@property (strong, nonatomic) IBOutlet UILabel *lblLooperDaily;

@end

@implementation PayNowVC
@synthesize imgBackgroundProfile,imgProfile,viewBgProfile,lblAboutMe,lblAboutMeDescription,lblActualAmount,lblActualDays,lblActualRate,lblAmount,lblDays,lblRate,lblTripDate,lblTripDetail,lblTripDuration,btnPay,lblLooperCityName,lblLooperDaily,lblLooperName,lblLooperRate,lblLooperResponse,strTripID,strLooperID;


- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareview];
    // Do any additional setup after loading the view.
}

-(void)prepareview
{
    [LooperUtility roundUIImageView:imgProfile];
    [LooperUtility roundUIViewWithTransparentBackground:viewBgProfile];
    
    
    [imgBackgroundProfile setImageToBlur:imgBackgroundProfile.image blurRadius:8 completionBlock:^{
        DebugLog(@"The blurred image has been set");
    }];
    
    lblAboutMe.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_HEADER_SIZE];
    lblAboutMeDescription.font = [UIFont fontAvenirWithSize:FONT_HEADER_SIZE];
    lblTripDetail.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_HEADER_SIZE];
    lblTripDate.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_NORMAL_SIZE];
    lblTripDuration.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_NORMAL_SIZE];
    lblDays.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_NORMAL_SIZE];
    lblActualDays.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_NORMAL_SIZE];
    lblRate.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_NORMAL_SIZE];
    lblActualRate.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_NORMAL_SIZE];
    lblAmount.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_NORMAL_SIZE];
    lblActualAmount.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_NORMAL_SIZE];
    btnPay.titleLabel.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_HEADER_LARGE_SIZE];
    lblLooperName.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_HEADER_LARGE_SIZE];
    lblLooperCityName.font = [UIFont fontAvenirWithSize:FONT_SMALL_SIZE];
    lblLooperResponse.font = [UIFont fontAvenirWithSize:FONT_SMALL_SIZE];
    lblLooperRate.font =  [UIFont fontAvenirNextCondensedMediumWithSize:FONT_HEADER_SIZE];
    lblLooperDaily.font = [UIFont fontAvenirWithSize:FONT_SMALL_SIZE];
    
    lblAboutMeDescription.text = @"Los angeles native. party advocate. FOodi extra ordinary";
    
    [self fetchTripDetail];
}

-(void)fetchTripDetail
{
    [[ServiceHandler sharedInstance].travelerWebService processPayNowTripDetailWithParameter:strLooperID tripID:strTripID successBlock:^(NSDictionary *response)
    {
        [self setupUI:response];
        
    } errorBlock:^(NSError *error)
    {
        
    }];
}

-(void)setupUI:(NSDictionary *)response
{
    lblLooperName.text = response[profile][@"vFullName"];
    lblLooperCityName.text = [NSString stringWithFormat:@"%@,%@",response[@"Profile"][@"vCity"],response[@"Profile"][@"vState"]];
    lblLooperName.text = response[@"Profile"][@"vFullName"];
    lblLooperRate.text = response[@"Profile"][@"iRates"];
    
    [imgProfile setImageWithURL:[NSURL URLWithString:response[@"Profile"][@"vProfilePic"]]];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:response[@"Profile"][@"vProfilePic"]]];
    
    UIImageView *tempImageView = imgBackgroundProfile;
    
    [imgBackgroundProfile setImageWithURLRequest:req placeholderImage:imgBackgroundProfile.image success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        
        tempImageView.image = image;
        [tempImageView setImageToBlur:tempImageView.image blurRadius:8 completionBlock:^{
            
        }];
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        
    }];
    
    lblAboutMeDescription.text = (! [response[@"Profile"][@"vAbout"] isEqualToString:@""]?@"Looper haven't set about yet" :response[@"Profile"][@"vAbout"]);
    lblTripDuration.text = [NSString stringWithFormat:@"%@ To %@",response[@"Trip"][@"dDepartureDate"],response[@"Trip"][@"dArrivalDate"]];
    lblActualDays.text = [NSString stringWithFormat:@"%d",[response[@"Trip"][@"iTotalDays"] intValue]];
    lblActualRate.text = [NSString stringWithFormat:@"%@ %.2f/Day",response[@"Trip"][@"vCurrencyType"],[response[@"Trip"][@"iTripCharge"] floatValue]];
    lblActualAmount.text = [NSString stringWithFormat:@"%@ %.2f",response[@"Trip"][@"vCurrencyType"],[response[@"Trip"][@"iTotalCharges"] floatValue]];
    
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
- (IBAction)btnPayNowPressed:(id)sender {
    
    return;
    // If you haven't already, create and retain a `BTAPIClient` instance with a tokenization
    // key or a client token from your server.
    // Typically, you only need to do this once per session.
    //self.braintreeClient = [[BTAPIClient alloc] initWithAuthorization:aClientToken];
    
    // Create a BTDropInViewController
    
}

- (void)userDidCancelPayment {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
