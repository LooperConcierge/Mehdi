//
//  PayoutInfoVC.m
//  Looper
//
//  Created by hardik on 4/18/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "PayoutInfoVC.h"
#import "HGImagePicker.h"
#import "UIImageView+AFNetworking.h"

@interface PayoutInfoVC ()
{
    HGImagePicker *hgImagePicker;
    UIImage *imgPersonalID;
    NSDictionary *dictParam;
}
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *ssnHeightConst;
//@property (strong, nonatomic) IBOutlet UIView *viewBGTxt;

@property (strong, nonatomic) IBOutlet UITextField *txtPersonalID;
@property (strong, nonatomic) IBOutlet UITextField *txtAccountNumber;
@property (strong, nonatomic) IBOutlet UITextField *txtFirstName;
@property (strong, nonatomic) IBOutlet UITextField *txtLastName;

@property (strong, nonatomic) IBOutlet UITextField *txtRoutingNumber;
@property (strong, nonatomic) IBOutlet UITextField *txtStreetAddress;

@property (strong, nonatomic) IBOutlet UITextField *txtSocialSecurityNo;
//@property (strong, nonatomic) IBOutlet UITextView *txtAddressView;
@property (strong, nonatomic) IBOutlet UITextField *txtCity;
@property (strong, nonatomic) IBOutlet UITextField *txtState;
@property (strong, nonatomic) IBOutlet UITextField *txtCountry;
@property (strong, nonatomic) IBOutlet UITextField *txtZipCode;

@property (strong, nonatomic) IBOutlet UITextField *txtDob;


@end

@implementation PayoutInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"PAYOUT INFO";
    
    _txtPersonalID.userInteractionEnabled = false;
//    _viewBGTxt.layer.borderWidth = 0.5;
//    _viewBGTxt.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    _viewBGTxt.layer.masksToBounds = true;
//    _viewBGTxt.layer.cornerRadius = 2;
    _txtDob.userInteractionEnabled = false;
    
    [[ServiceHandler sharedInstance].looperWebService processGetAccountInfoSuccessBlock:^(NSDictionary *response)
    {
        if (response != nil)
        {
            dictParam = [[NSDictionary alloc] initWithDictionary:response];
            
            [self setupDetail];
        }
    } errorBlock:^(NSError *error)
    {
        
    }];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupDetail
{
    _ssnHeightConst.constant = 0.0;
    _txtSocialSecurityNo.userInteractionEnabled = false;
    _txtDob.userInteractionEnabled = false;
    _txtFirstName.text = dictParam[@"vFirstName"];
    _txtLastName.text = dictParam[@"vLastName"];
    _txtRoutingNumber.text = dictParam[@"iRoutingNumber"];
    _txtAccountNumber.text = dictParam[@"iBankNumber"];
    _txtSocialSecurityNo.text = dictParam[@"vFirstName"];
    _txtCity.text = dictParam[@"vCity"];
    _txtState.text = dictParam[@"vState"];
    _txtCountry.text = dictParam[@"vCountry"];
    _txtZipCode.text = dictParam[@"iZipCode"];
//    _txtDob.text = [LooperUtility convertServerDateToAppString:dictParam[@"dDob"]];
    _txtDob.text = [LooperUtility convertServerDateDesireAppString:dictParam[@"dDob"] dateFormat:@"MM/dd/yyyy"];
//    _txtAddressView.text = dictParam[@"vAddress"];
    if (dictParam[@"vImage"] != nil)
    {
//        _txtPersonalID.text = @"Photo uploaded";
        UIImageView *img = [[UIImageView alloc] init];
//        [img setImageWithURL:[NSURL URLWithString:dictParam[@"vImage"]]];
        [img setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dictParam[@"vImage"]]]] placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
            
            imgPersonalID = img.image;
             _txtPersonalID.text = @"ID uploaded";
            
        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            
        }];
        
    }
}

- (IBAction)btnSubmitPressed:(id)sender
{
    NSString *message = [self validation];
    
    if (message.length > 0)
    {
        [LooperUtility createAlertWithTitle:@"Looper" message:@"Please fill in all required fields." style:UIAlertControllerStyleAlert controller:self actionHandler:^(UIAlertAction *action) {
            
        }];
        return;
    }

    if (dictParam == nil)
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MM/dd/yyyy"];
        
        NSDate *date = [df dateFromString:_txtDob.text];
        [df setDateFormat:@"yyyy-MM-dd"];
        NSString *strDate = [df stringFromDate:date];
        NSDictionary *dict = @{@"vFirstName": [_txtFirstName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],
                               @"vLastName": [_txtLastName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],
                               @"iBankNumber": [_txtAccountNumber.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],
                               @"iRoutingNumber": [_txtRoutingNumber.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],
                               @"dDob": strDate,
                               @"vAddress": [_txtStreetAddress.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],
                               @"vCity": [_txtCity.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],
                               @"vState": [_txtState.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],
                               @"vCountry": [_txtCountry.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],
                               @"iZipCode": [_txtZipCode.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],
                               @"iLastSsn": [_txtSocialSecurityNo.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
                               };
        
        [[ServiceHandler sharedInstance].looperWebService processSaveAccountInfo:dict imageDict:@{@"vPersonalID" : imgPersonalID} SuccessBlock:^(NSDictionary *response)
         {
             
             if ([response[success] intValue] == 1)
             {
                  [LooperUtility createAlertWithTitle:@"Looper" message:response[data][@"MESSAGE"] style:UIAlertControllerStyleAlert controller:self actionHandler:^(UIAlertAction *action) {
                      [self.navigationController popViewControllerAnimated:YES];
                  }];
             }
             else
             {
                 [LooperUtility createAlertWithTitle:@"Looper" message:response[@"MESSAGE"] style:UIAlertControllerStyleAlert controller:self actionHandler:^(UIAlertAction *action) {
                     
                 }];
             }

         } errorBlock:^(NSError *error) {
             
         }];
    
    }
    else
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MM/dd/yyyy"];
        
        NSDate *date = [df dateFromString:_txtDob.text];
        [df setDateFormat:@"yyyy-MM-dd"];
        NSString *strDate = [df stringFromDate:date];
        
        NSDictionary *dict = @{
                               @"vFirstName": [_txtFirstName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],
                               @"vLastName": [_txtLastName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],
                               @"iBankNumber": [_txtAccountNumber.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],
                               @"iRoutingNumber": [_txtRoutingNumber.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],
                               @"dDob": @"",
                               @"vAddress": [_txtStreetAddress.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],
                               @"vCity": [_txtCity.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],
                               @"vState": [_txtState.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],
                               @"vCountry": [_txtCountry.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],
                               @"iZipCode": [_txtZipCode.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],
                               @"iLastSsn": @"",
                               @"iAccountID" : [NSString stringWithFormat:@"%@",dictParam[@"iAccountID"]]
                               };

        [[ServiceHandler sharedInstance].looperWebService processUpdateAccountInfoParam:dict SuccessBlock:^(NSDictionary *response)
        {
            if ([response[success] intValue] == 1)
            {
                [LooperUtility createAlertWithTitle:@"Looper" message:response[data][@"MESSAGE"] style:UIAlertControllerStyleAlert controller:self actionHandler:^(UIAlertAction *action) {
                    
                }];
            }
            else
            {
                [LooperUtility createAlertWithTitle:@"Looper" message:response[@"MESSAGE"] style:UIAlertControllerStyleAlert controller:self actionHandler:^(UIAlertAction *action) {
                    
                }];
            }
        } errorBlock:^(NSError *error)
         {
            
        }];
    }
}




#pragma MARK - Private methods

-(NSString *)validation
{
    NSString *message = @"";
    
    if (![_txtFirstName.text isValidString])
    {
        [_txtFirstName becomeFirstResponder];
        message = @"Please enter first name";
    }
    else if (![_txtLastName.text isValidString])
    {
        [_txtLastName becomeFirstResponder];
        message = @"Please enter last name";
    }
    else if (![_txtAccountNumber.text isValidString])
    {
        [_txtAccountNumber becomeFirstResponder];
        message = @"Please enter account number";
    }
    else if (![_txtRoutingNumber.text isValidString])
    {
        [_txtRoutingNumber becomeFirstResponder];
        message = @"Please enter rounting number";
    }
    else if (![_txtSocialSecurityNo.text isValidString])
    {
        [_txtSocialSecurityNo becomeFirstResponder];
        message = @"Please enter last 4 digit of SSN";
    }
    else if (_txtSocialSecurityNo.text.length <4)
    {
        [_txtSocialSecurityNo becomeFirstResponder];
        message = @"Please enter last 4 digit of SSN";
    }
    else if (_txtSocialSecurityNo.text.length > 4)
    {
        [_txtSocialSecurityNo becomeFirstResponder];
        message = @"SSN Number should be less then 4 digit";
    }
//    else if (![_txtAddressView.text isValidString])
//    {
//        [_txtAddressView becomeFirstResponder];
//        message = @"Please enter address";
//    }
    else if (![_txtStreetAddress.text isValidString])
    {
        [_txtStreetAddress becomeFirstResponder];
        message = @"Please enter address";
    }
    else if (![_txtCity.text isValidString])
    {
        [_txtCity becomeFirstResponder];
        message = @"Please enter city";
    }
    else if (![_txtState.text isValidString])
    {
        [_txtState becomeFirstResponder];
        message = @"Please enter state";
    }
    else if (![_txtCountry.text isValidString])
    {
        [_txtCity becomeFirstResponder];
        message = @"Please enter country";
    }
    else if (![_txtDob.text isValidString])
    {
        message = @"Please birth date";
    }
    else if (![_txtPersonalID.text isValidString])
    {
        message = @"Please upload personal id";
    }
    
    return message;
}

- (IBAction)btnPersonalIDPressed:(id)sender
{
    
    if (!hgImagePicker) {
        hgImagePicker = [[HGImagePicker alloc] init];
        hgImagePicker.typeOfPicker = kOnlyPhotos;
        hgImagePicker.typeOfCrop = kOriginalImage;
    }
    
    [hgImagePicker showImagePicker:self
               withNavigationColor:[UIColor blackColor]
                       imagePicked:^(NSDictionary *dictData) {
                           if (dictData[UIImagePickerControllerOriginalImage])
                           {
                               imgPersonalID = (UIImage *)dictData[UIImagePickerControllerOriginalImage];
                               _txtPersonalID.text = @"ID uploaded";
                           }
                       }
                     imageCanceled:^{
                     }
                      imageRemoved:nil];
}

- (IBAction)btnDobPressed:(id)sender
{
//    if (dictParam != nil)
//    {
//        return;
//    }
    NSDate *dateSet;
    if (_txtDob.text.length >0)
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MM/dd/yyyy"];
        dateSet = [df dateFromString:_txtDob.text];
//        dateSet = [LooperUtility dateFromString:_txtDob.text];
    }
    else
    {
        dateSet = [NSDate date];
    }
    [[LooperUtility sharedInstance] showActionSheetDatePickerInView:self.view setMinDate:nil setMaxDate:nil selectedDate:dateSet doneBlock:^(NSDate *selectedDate)
     {
         NSDateFormatter *df = [[NSDateFormatter alloc] init];
         [df setDateFormat:@"MM/dd/yyyy"];
         _txtDob.text = [df stringFromDate:selectedDate];
     }];
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
