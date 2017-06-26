//
//  LooperProfileVC.m
//  Looper
//
//  Created by hardik on 4/18/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "LooperProfileVC.h"
#import "ExpertiseGalleryViewController.h"
#import "LooperModel.h"
#import "UIImageView+AFNetworking.h"
#import "HGImagePicker.h"
#import "SelectLanguageVC.h"
#import "UIButton+AFNetworking.h"
#import "TPFloatRatingView.h"

@interface LooperProfileVC ()<UITextFieldDelegate,ExpertiseGalleryDelegate,SelectLanguageVCDelegate>
{
    LooperModel *looperProfile;
    HGImagePicker *hgImagePicker;
}
@property (strong, nonatomic) IBOutlet UILabel *lblLooperCity;
@property (strong, nonatomic) IBOutlet UITextView *txtAddressView;
@property (strong, nonatomic) IBOutlet UIImageView *imgBackground;
@property (strong, nonatomic) IBOutlet UIView *viewBack;
@property (strong, nonatomic) IBOutlet UIImageView *imgProfile;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtPhoneNumber;
@property (strong, nonatomic) IBOutlet UIButton *btnMale;
@property (strong, nonatomic) IBOutlet UIButton *btnFemale;
@property (strong, nonatomic) IBOutlet UITextField *txtMotto;
@property (strong, nonatomic) IBOutlet UITextView *txtViewAbout;
@property (strong, nonatomic) IBOutlet UITextField *txtRate;
@property (strong, nonatomic) IBOutlet UITextField *txtExpertise;
@property (strong, nonatomic) IBOutlet UIButton *btnEditProfile;
@property (strong, nonatomic) IBOutlet UIButton *btnDateOfBirth;
@property (strong, nonatomic) IBOutlet UIButton *btnLanguage;
@property (strong, nonatomic) IBOutlet UIButton *btnExpertise;
@property (strong, nonatomic) IBOutlet UITextField *txtLanguage;
@property (strong, nonatomic) IBOutlet UITextField *txtFirstName;
@property (strong, nonatomic) IBOutlet UITextField *txtLastName;
@property (strong, nonatomic) IBOutlet UISwitch *swAvailable;
@property (strong, nonatomic) IBOutlet UIButton *btnW9Form;
@property (strong, nonatomic) IBOutlet UIButton *btnUSResidenceProof;
@property (strong, nonatomic) IBOutlet TPFloatRatingView *rateView;

@end

@implementation LooperProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpView];
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self setUpView];
}

-(void)setUpView
{
    
    self.title = @"MY PROFILE";
    
    [[ServiceHandler sharedInstance].looperWebService processLooperProfileWithSuccessBlock:^(NSDictionary *response)
    {
        NSDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:response[profile]];
        [dict setValue:response[@"languages"] forKey:@"languages"];
        [dict setValue:response[@"expertises"] forKey:@"expertises"];
        
        NSError *error;
        looperProfile = [[LooperModel alloc] initWithDictionary:dict error:&error];
        [self setLooperProfile];
        
    } errorBlock:^(NSError *error)
    {
        
    }];
    
    [_imgBackground setImageToBlur:_imgBackground.image blurRadius:8 completionBlock:^{
        
    }];
    
    _btnExpertise.titleLabel.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_MEDIUM_SIZE];
    _btnLanguage.titleLabel.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_MEDIUM_SIZE];
    _btnDateOfBirth.titleLabel.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_MEDIUM_SIZE];
    
    UIButton *btnMale = [self.view viewWithTag:100];
    UIButton *btnFemale = [self.view viewWithTag:101];
    btnMale.titleLabel.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_MEDIUM_SIZE];
    btnFemale.titleLabel.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_MEDIUM_SIZE];
    
    btnMale.selected = TRUE;
    [LooperUtility roundUIImageView:_imgProfile];
    [LooperUtility roundUIViewWithTransparentBackground:_viewBack];
    [self editItems:NO];
    
    _btnW9Form.layer.cornerRadius = 4;
    _btnUSResidenceProof.layer.cornerRadius = 4;
    _btnW9Form.layer.borderWidth = 0.5;
    _btnUSResidenceProof.layer.borderWidth = 0.5;
    _btnW9Form.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _btnUSResidenceProof.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _btnW9Form.layer.masksToBounds = YES;
    _btnUSResidenceProof.layer.masksToBounds = YES;
    _btnW9Form.titleLabel.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_MEDIUM_SIZE];
    _btnUSResidenceProof.titleLabel.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_MEDIUM_SIZE];
    
    [self setRate:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 

- (IBAction)btnBdatePressed:(id)sender
{
    [self.view endEditing:YES];

    NSDate *date = [LooperUtility dateFromString:_btnDateOfBirth.titleLabel.text];
    
    [[LooperUtility sharedInstance] showActionSheetDatePickerInView:self.view setMinDate:nil setMaxDate:nil selectedDate:date doneBlock:^(NSDate *selectedDate)
     {
         [_btnDateOfBirth setTitle:[LooperUtility stringFromDate:selectedDate] forState:UIControlStateNormal];
     }];
}

- (IBAction)btnEditPressed:(id)sender
{
    [self choosePhotoAsProfilePicture:sender];
}

- (IBAction)btnGenderPressed:(id)sender
{
    UIButton *btnMale = [self.view viewWithTag:100];
    UIButton *btnFemale = [self.view viewWithTag:101];
    
    NSArray *arrBtn = [NSArray arrayWithObjects:btnMale,btnFemale,nil];
    
    for (UIButton *btnSelection in arrBtn)
    {
        if (sender == btnSelection)
        {
            btnSelection.selected = TRUE;
        }
        else
        {
            btnSelection.selected = FALSE;
        }
    }
}

- (IBAction)btnExpertisePressed:(id)sender
{
//    return;
    UIStoryboard *Lopper = [UIStoryboard storyboardWithName:@"Looper" bundle:nil];
    //  self.ViewObj = [[ViewController alloc] init];
    ExpertiseGalleryViewController *vc = [Lopper instantiateViewControllerWithIdentifier:@"ExpertiseGalleryViewController"];
//    vc.arrContainsExpertise = [[NSMutableArray alloc] initWithArray:[LooperUtility expertiseArray:looperProfile.expertises]];
    vc.expertiseDelegate = self;
    [self.navigationController pushViewController:vc animated:YES];
 
}

- (IBAction)btnProfileEditPressed:(id)sender
{
    
    
    self.btnEditProfile.titleLabel.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_MEDIUM_SIZE];
    if (self.btnEditProfile.selected)
    {
        NSString *messageStr = [self validation];
        
        if (messageStr.length > 0)
        {
            [AJNotificationView showNoticeInView:AppdelegateObject.window type:AJNotificationTypeRed title:messageStr linedBackground:AJLinedBackgroundTypeDisabled hideAfter:2.5];
            return;
        }
//        [self addBackButton];
        NSDictionary *parameter = [self createProfileDictionary];
//        NSDictionary *imgDictionary = @{@"vProfilePic" :_imgProfile.image,
//                                        @"vWNineForm" : _btnW9Form.imageView.image,
//                                        @"vUSResProof" : _btnUSResidenceProof.imageView.image,
//                                        };
        NSDictionary *imgDictionary = @{@"vProfilePic" :_imgProfile.image
                                        };
        
        [[ServiceHandler sharedInstance].looperWebService processLooperEditProfileWithParameters:parameter profilePic:imgDictionary SuccessBlock:^(NSDictionary *response) {
            looperProfile.dDob = response[@"dDob"];
            
            self.btnEditProfile.selected = NO;
            [self editItems:self.btnEditProfile.selected];
            [self.btnEditProfile setTitle:@"EDIT" forState:UIControlStateNormal];
            [AJNotificationView showNoticeInView:AppdelegateObject.window type:AJNotificationTypeRed title:@"Profile updated succesfully" linedBackground:AJLinedBackgroundTypeDisabled hideAfter:2.5];
            
        } errorBlock:^(NSError *error)
        {
            
        }];
        
    }
    else
    {
//        [self setBackButtonTitle];
        self.btnEditProfile.selected = YES;
        [self editItems:self.btnEditProfile.selected];
        [self.btnEditProfile setTitle:@"DONE" forState:UIControlStateSelected];
        [self.txtFirstName becomeFirstResponder];
    }
    
}

- (IBAction)btnLanguagePressed:(id)sender
{
    UIStoryboard *Lopper = [UIStoryboard storyboardWithName:@"Looper" bundle:nil];
    //  self.ViewObj = [[ViewController alloc] init];
    SelectLanguageVC *vc = [Lopper instantiateViewControllerWithIdentifier:@"SelectLanguageVCID"];
    vc.contaionsLanguage = [[NSMutableArray alloc] initWithArray:looperProfile.languages];
    vc.selectLangDelegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)switchAvailablityChanged:(id)sender
{
    UISwitch *switchv = (UISwitch *)sender;
    NSLog(@"Switch %d",switchv.isOn);
    
    NSString *isAvailable = @"y";
    
    if (switchv.isOn)
    {
        isAvailable = @"y";
    }
    else
    {
        isAvailable = @"n";
    }

    [[ServiceHandler sharedInstance].looperWebService processUpdateAvailability:@{@"isAvailable" : isAvailable} SuccessBlock:^(NSDictionary *response)
     {
         
     } errorBlock:^(NSError *error) {
         
     }];
}




#pragma mark - Private methods

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
    else if (![_txtEmail.text isValidString])
    {
        [_txtEmail becomeFirstResponder];
        message = @"Please enter email address";
    }
    else if (![_txtEmail.text isValidEmailAddress])
    {
        [_txtEmail becomeFirstResponder];
        message = @"Please enter a valid email address";
    }
    else if (![_txtPhoneNumber.text isValidPhoneNumber])
    {
        [_txtPhoneNumber becomeFirstResponder];
        message = @"Please enter a valid phone number";
    }
    else if (![_txtPhoneNumber.text isValidPhoneNumber])
    {
        [_txtPhoneNumber becomeFirstResponder];
        message = @"Please enter a valid phone number";
    }
    else if (![_txtMotto.text isValidString])
    {
        [_txtMotto becomeFirstResponder];
        message = @"Please enter Motto";
    }
    else if (![_txtViewAbout.text isValidString])
    {
        [_txtViewAbout becomeFirstResponder];
        message = @"Please enter about yourself";
    }
    else if (![_txtRate.text isValidString])
    {
        [_txtRate becomeFirstResponder];
        message = @"Please enter your daily rate";
    }
//    else if (_btnW9Form.imageView.image == nil)
//    {
//        message = @"Please upload form";
//    }
//    else if (_btnUSResidenceProof.imageView.image == nil)
//    {
//        message = @"Please upload id proof";
//    }
    else if (looperProfile.languages.count == 0)
    {
        message = @"Please select language";
    }
    
    return message;
}


-(void)editItems:(BOOL)isEdit
{
    _txtFirstName.userInteractionEnabled = isEdit;
    _txtLastName.userInteractionEnabled = isEdit;
    _txtEmail.userInteractionEnabled = FALSE;
    _txtPhoneNumber.userInteractionEnabled = isEdit;
    _btnMale.userInteractionEnabled = isEdit;
    _btnFemale.userInteractionEnabled = isEdit;
    _txtMotto.userInteractionEnabled = isEdit;
    _txtViewAbout.userInteractionEnabled = isEdit;
    _txtAddressView.userInteractionEnabled = isEdit;
    _txtRate.userInteractionEnabled = isEdit;
    _txtExpertise.userInteractionEnabled = false;
    _btnExpertise.userInteractionEnabled = isEdit;
    _txtLanguage.userInteractionEnabled = false;
    _btnLanguage.userInteractionEnabled = isEdit;
    _btnUSResidenceProof.userInteractionEnabled = isEdit;
    _btnW9Form.userInteractionEnabled = isEdit;
}

-(void)setRate:(float)rate
{
    _rateView.emptySelectedImage = [UIImage imageNamed:@"starEmpty"];
    _rateView.fullSelectedImage = [UIImage imageNamed:@"starFull"];
    _rateView.contentMode = UIViewContentModeScaleAspectFill;
    _rateView.maxRating = 5;
    _rateView.minRating = 1;
    _rateView.rating = looperProfile.iRating;
    _rateView.editable = NO;
    _rateView.halfRatings = YES;
    _rateView.floatRatings = NO;
}

-(void)setLooperProfile
{
    [self setRate:looperProfile.iRating];
    
    
    NSArray *containsExpertise = looperProfile.expertises;
    NSArray *containsLanguages = looperProfile.languages;
    
    NSArray *arrFullName = [looperProfile.vFullName componentsSeparatedByString:@" "];
    _txtFirstName.text = arrFullName[0];
    _txtLastName.text = arrFullName[1];
    _txtEmail.text = looperProfile.vEmail;
    _txtPhoneNumber.text = looperProfile.vPhone;

    
//    _lblLooperCity.text = [NSString stringWithFormat:@"Plantation,Florida"];
//    _lblLooperCity.text = [NSString stringWithFormat:@"%@,%@",looperProfile.vCity,looperProfile.vState];
    _lblLooperCity.text = [NSString stringWithFormat:@"Plantation"];
    _lblLooperCity.text = [NSString stringWithFormat:@"%@",looperProfile.vCity];

    if (looperProfile.vWNineForm != nil)
    {
    [_btnW9Form setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:looperProfile.vWNineForm]];
    }
    
    if (looperProfile.vWNineForm  != nil)
    {
    [_btnUSResidenceProof setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:looperProfile.vUSResProof]];
    }
    
    
    
    
    if([looperProfile.vMotto isEqualToString:@""])
    {
//        _txtMotto.placeholder = @"Please enter motto";
    }
    else
    {
        _txtMotto.text = looperProfile.vMotto;
    }
    
    if (![looperProfile.vAbout isEqualToString:@""])
        _txtViewAbout.text = looperProfile.vAbout;
    
    if (looperProfile.iRates != 0)
        _txtRate.text = [NSString stringWithFormat:@"%.0f",looperProfile.iRates];
    
    
    [_btnDateOfBirth setTitle:[LooperUtility convertServerDateToAppString:looperProfile.dDob] forState:UIControlStateNormal];
    
    
    NSString *expertiseName = [[containsExpertise valueForKey:@"vName"] componentsJoinedByString:@", "];
    NSString *languaesName = [[containsLanguages valueForKey:@"vName"] componentsJoinedByString:@", "];
    
    if (expertiseName.length != 0)
        _txtExpertise.text = expertiseName;
    
    if (languaesName.length != 0)
        _txtLanguage.text = languaesName;
    
    [_imgProfile setImageWithURL:[NSURL URLWithString:looperProfile.vProfilePic] placeholderImage:_imgProfile.image];
    
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:looperProfile.vProfilePic]];
    
    __block UIImageView *tempImageview = _imgBackground;
    
    [_imgBackground setImageWithURLRequest:req placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        
        [tempImageview setImageToBlur:image blurRadius:8 completionBlock:^{
            DebugLog(@"The blurred image has been set");
        }];
        
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        
    }];
    
    if ([[looperProfile.eAvailability lowercaseString] isEqualToString:@"available"])
        [_swAvailable setOn:TRUE];
    else
        [_swAvailable setOn:FALSE];

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)choosePhotoAsProfilePicture:(id)sender {
    if (!hgImagePicker) {
        hgImagePicker = [[HGImagePicker alloc] init];
        hgImagePicker.typeOfPicker = kOnlyPhotos;
        hgImagePicker.typeOfCrop = kCropImage;
    }
    
    [hgImagePicker showImagePicker:self
               withNavigationColor:[UIColor blackColor]
                       imagePicked:^(NSDictionary *dictData) {
                           if (dictData[UIImagePickerControllerOriginalImage]) {
                               
                               [_imgProfile setImage:(UIImage *)dictData[UIImagePickerControllerOriginalImage]];
                               
                               [_imgBackground setImageToBlur:(UIImage *)dictData[UIImagePickerControllerOriginalImage] blurRadius:8 completionBlock:^{
                                   
                               }];
                               [[ServiceHandler sharedInstance].travelerWebService processEditImage:@{@"vProfilePic" : _imgProfile.image} SuccessBlock:^(NSDictionary *response)
                                {
                                    if ([response[success] intValue] == 1)
                                    {
                                        looperProfile.vProfilePic = response[data][@"vProfilePic"];
                                    }
                                } errorBlock:^(NSError *error)
                                {
                                    
                                }];

                           }
                       }
                     imageCanceled:^{
                     }
                      imageRemoved:nil];
}


-(NSDictionary *)createProfileDictionary
{
    NSString *firstname = [_txtFirstName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *lastname = [_txtLastName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    
    NSString *phoneNumber = [_txtPhoneNumber.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    
    
    
//    city & email not to pass as it is not chaged
    
    NSDictionary *dictionary = @{@"vFullName" : [NSString stringWithFormat:@"%@ %@",firstname,lastname],
                                 
                                 @"vPhone" : phoneNumber,
                                 @"vExpertises":[[looperProfile.expertises valueForKey:@"iExpertiseID"] componentsJoinedByString:@","],
                                 @"vLanguages":[[looperProfile.languages valueForKey:@"iLanguageID"] componentsJoinedByString:@","],
                                 @"vMotto":_txtMotto.text,
                                 @"vAbout":_txtViewAbout.text,
                                 @"iRates" : _txtRate.text,
                                 @"eAvailability" : (_swAvailable.isOn ? @"Available":@"NotAvailable"),
                                 @"vCode" : looperProfile.vCode
                                 };
    
    return dictionary;
}

-(void)expertiseArray:(NSArray *)expertiseArray1
{
    NSString *expertiseName = [[expertiseArray1 valueForKey:@"vName"] componentsJoinedByString:@","];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    for (PassionModel *dict in expertiseArray1)
    {
//        ExpertiseModel *model = [[ExpertiseModel alloc] init];
        NSDictionary *dict1 = @{@"iExpertiseID":dict.iExpertiseID};
        [arr addObject:dict1];
    }
    
    looperProfile.expertises = arr;
    
    if (expertiseName.length != 0)
        _txtExpertise.text = expertiseName;
    
}

-(void)languageArray:(NSArray *)languages
{
    NSString *languaesName = [[languages valueForKey:@"vName"] componentsJoinedByString:@", "];
    looperProfile.languages = [[NSArray alloc] initWithArray:languages];
    
    if (languaesName.length > 0)
        _txtLanguage.text = languaesName;
}

-(void)setLooperProfileObject:(NSDictionary *)response
{
    looperProfile.eAvailability = response[@"eAvailability"];
    looperProfile.iRates = [response[@"iRates"] intValue];
    looperProfile.vAbout = response[@"vAbout"];
    looperProfile.vFullName = response[@"vFullName"];
    looperProfile.vMotto = response[@"vMotto"];
    looperProfile.vPhone = response[@"vPhone"];
    looperProfile.vWNineForm = response[@"vWNineForm"];
    looperProfile.vUSResProof  = response[@"vUSResProof"];
    looperProfile.vIDProof  = response[@"vIDProof"];
    
    [self setLooperProfile];
}

- (IBAction)btnUploadDocumentPressed:(id)sender
{
    [self chooseDocument:sender];
}

-(void)chooseDocument:(id)sender {
    if (!hgImagePicker) {
        hgImagePicker = [[HGImagePicker alloc] init];
        hgImagePicker.typeOfPicker = kOnlyPhotos;
        hgImagePicker.typeOfCrop = kCropImage;
    }
    
    
    [hgImagePicker showImagePicker:self withNavigationColor:[UIColor blackColor] imagePicked:^(NSDictionary *dictData) {
        if (dictData[UIImagePickerControllerOriginalImage])
        {
            UIButton *btn = (UIButton *)sender;
            
            if (btn == _btnW9Form)
            {
                [_btnW9Form setTitle:@"" forState:UIControlStateNormal];
                [_btnW9Form setImage:(UIImage *)dictData[UIImagePickerControllerOriginalImage] forState:UIControlStateNormal];
            }
            else if(btn == _btnUSResidenceProof)
            {
                [_btnUSResidenceProof setTitle:@"" forState:UIControlStateNormal];
                [_btnUSResidenceProof setImage:(UIImage *)dictData[UIImagePickerControllerOriginalImage] forState:UIControlStateNormal];
            }
            
            
        }
        
    } imageCanceled:^{
        
    } imageRemoved:nil];
}


@end
