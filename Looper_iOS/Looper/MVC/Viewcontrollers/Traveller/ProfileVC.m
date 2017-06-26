
//
//  ProfileVC.m
//  Looper
//
//  Created by hardik on 3/23/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "ProfileVC.h"
#import "TravelerModel.h"
#import "UIImageView+AFNetworking.h"
#import "HGImagePicker.h"
#import "SelectLanguageVC.h"
@interface ProfileVC ()<SelectLanguageVCDelegate>
{
    HGImagePicker *hgImagePicker;
    TravelerModel *travelerProfile;
}
@property (strong, nonatomic) IBOutlet UIView *viewBackProfile;
@property (strong, nonatomic) IBOutlet UIImageView *imgProfile;
@property (strong, nonatomic) IBOutlet UIImageView *imgBlurProfile;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *viewConstHeaderHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imgProfileConstWidth;
@property (strong, nonatomic) IBOutlet UIButton *btnEdit;

@property (strong, nonatomic) IBOutlet UILabel *lblEmailAddress;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UILabel *lblPhoneNumber;
@property (strong, nonatomic) IBOutlet UITextField *txtPhoneNumber;
@property (strong, nonatomic) IBOutlet UILabel *lblDateOfBirth;
@property (strong, nonatomic) IBOutlet UIButton *btnBirthDate;
@property (strong, nonatomic) IBOutlet UILabel *lblGender;
@property (strong, nonatomic) IBOutlet UIButton *lblMale;
@property (strong, nonatomic) IBOutlet UIButton *lblFemale;
@property (strong, nonatomic) IBOutlet UITextField *txtFirstName;
@property (strong, nonatomic) IBOutlet UITextField *txtLastName;
@property (strong, nonatomic) IBOutlet UIButton *btnEditProfile;
@property (strong, nonatomic) IBOutlet UILabel *lblLanguage;

@end

@implementation ProfileVC
@synthesize imgProfile,viewBackProfile,imgBlurProfile,imgProfileConstWidth,viewConstHeaderHeight,btnEdit,lblDateOfBirth,lblEmailAddress,lblGender,lblPhoneNumber,txtEmail,txtPhoneNumber,lblFemale,lblMale;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareView];
    // Do any additional setup after loading the view.
}

-(void)prepareView
{
  
    self.title = @"MY PROFILE";
    
    [[ServiceHandler sharedInstance].travelerWebService processTravelerProfileWithSuccessBlock:^(NSDictionary *response)
     {
         NSError *error;
         travelerProfile = [[TravelerModel alloc] initWithDictionary:response[profile] error:&error];
         [self setTravelerProfile];
         
     } errorBlock:^(NSError *error) {
         
     }];
    
       [self setUpView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self setUpView];
}

-(void)setUpView
{
    UIButton *btnMale = [self.view viewWithTag:100];
    UIButton *btnFemale = [self.view viewWithTag:101];
    
    btnMale.titleLabel.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_HEADER_SIZE];
    btnFemale.titleLabel.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_HEADER_SIZE];
    
    btnMale.selected = TRUE;
    [LooperUtility roundUIImageView:imgProfile];
    [LooperUtility roundUIViewWithTransparentBackground:viewBackProfile];

    lblEmailAddress.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_HEADER_SIZE];
    lblPhoneNumber.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_HEADER_SIZE];
    lblDateOfBirth.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_HEADER_SIZE];
    lblGender.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_HEADER_SIZE];
    lblMale.titleLabel.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_MEDIUM_SIZE];
    lblFemale.titleLabel.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_MEDIUM_SIZE];
    _btnBirthDate.titleLabel.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_HEADER_SIZE];
    [self editItems:NO];
    self.btnEditProfile.titleLabel.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_MEDIUM_SIZE];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)btnEditProfilePressed:(id)sender
{
   
    if (self.btnEditProfile.selected)
    {
        NSString *message = [self validation];
        
        if (message.length > 0)
        {
            [AJNotificationView showNoticeInView:AppdelegateObject.window type:AJNotificationTypeRed title:message linedBackground:AJLinedBackgroundTypeDisabled hideAfter:2.5];
            return;
        }
        
        NSDictionary *parameter = [self createParamDictionary];
        
//        UIImage *sendImage = [LooperUtility imageWithImage:imgProfile.image scaledToSize:CGSizeMake(400, 400)];
        [[ServiceHandler sharedInstance].travelerWebService processTravelerEditProfileWithParameters:parameter profilePic:@{@"vProfilePic" :imgProfile.image} SuccessBlock:^(NSDictionary *response)
        {
            NSError *error;
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:response[profile]];
            
            [dict setObject:travelerProfile.vEmail forKey:@"vEmail"];
            
            travelerProfile = [[TravelerModel alloc]initWithDictionary:dict error:&error];
            [self setTravelerProfile];
//            [self addBackButton];
            self.btnEditProfile.selected = NO;
            [self editItems:self.btnEditProfile.selected];
            [self.btnEditProfile setTitle:@"EDIT" forState:UIControlStateNormal];
            [AJNotificationView showNoticeInView:AppdelegateObject.window type:AJNotificationTypeRed title:@"Profile updated succesfully" linedBackground:AJLinedBackgroundTypeDisabled hideAfter:2.5];
            [LooperUtility settingTravelerProfile:travelerProfile];
            
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
    else if (![txtEmail.text isValidString])
    {
        [txtEmail becomeFirstResponder];
        message = @"Please enter email address";
    }
    else if (![txtEmail.text isValidEmailAddress])
    {
        [txtEmail becomeFirstResponder];
        message = @"Please enter a valid email address";
    }
    else if (![txtPhoneNumber.text isValidPhoneNumber])
    {
        [txtPhoneNumber becomeFirstResponder];
        message = @"Please enter a valid phone number";
    }
    else if (![txtPhoneNumber.text isValidPhoneNumber])
    {
        [txtPhoneNumber becomeFirstResponder];
        message = @"Please enter a valid phone number";
    }
    
    return message;
}


- (IBAction)btnBirthDatePressed:(id)sender
{
    [self.view endEditing:YES];
    
    NSDate *date = [LooperUtility dateFromString:_btnBirthDate.titleLabel.text];
    
    [[LooperUtility sharedInstance] showActionSheetDatePickerInView:self.view setMinDate:nil setMaxDate:nil selectedDate:date doneBlock:^(NSDate *selectedDate)
    {
        [_btnBirthDate setTitle:[LooperUtility stringFromDate:selectedDate] forState:UIControlStateNormal];
    }];
}

-(void)editItems:(BOOL)isEdit
{
    UIButton *btnMale = [self.view viewWithTag:100];
    UIButton *btnFemale = [self.view viewWithTag:101];
    btnMale.userInteractionEnabled = isEdit;
    btnFemale.userInteractionEnabled = isEdit;
    _txtFirstName.userInteractionEnabled = isEdit;
    _txtLastName.userInteractionEnabled = isEdit;
    txtEmail.userInteractionEnabled = FALSE;
    txtPhoneNumber.userInteractionEnabled = isEdit;
//    btnEdit.userInteractionEnabled = isEdit;
    _btnBirthDate.userInteractionEnabled = isEdit;
}

-(void)setTravelerProfile
{
    UIButton *btnMale = [self.view viewWithTag:100];
    UIButton *btnFemale = [self.view viewWithTag:101];
    
    NSArray *arrFullName = [travelerProfile.vFullName componentsSeparatedByString:@" "];
    _txtFirstName.text = arrFullName[0];
    _txtLastName.text = arrFullName[1];
    txtEmail.text = travelerProfile.vEmail;
    txtPhoneNumber.text = travelerProfile.vPhone;
    [_btnBirthDate setTitle:[LooperUtility convertServerDateToAppString:travelerProfile.dDob] forState:UIControlStateNormal];
    if ([[travelerProfile.eGender lowercaseString] isEqualToString:[@"Male" lowercaseString]])
    {
        btnMale.selected = TRUE;
        btnFemale.selected = FALSE;
    }
    else
    {
        btnMale.selected = FALSE;
        btnFemale.selected = TRUE;
    }
    [self languageArray:travelerProfile.languages];
    [imgProfile setImageWithURL:[NSURL URLWithString:travelerProfile.vProfilePic] placeholderImage:imgProfile.image];
    
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:travelerProfile.vProfilePic]];
    
    __block UIImageView *tempImageview = imgBlurProfile;
    
    [imgBlurProfile setImageWithURLRequest:req placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        
        [tempImageview setImageToBlur:image blurRadius:8 completionBlock:^{
            DebugLog(@"The blurred image has been set");
        }];
        
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        
    }];
    
    
}

- (IBAction)btnEditImagePressed:(id)sender
{
    [self choosePhotoAsProfilePicture:sender];
}

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
                        
                               [imgProfile setImage:(UIImage *)dictData[UIImagePickerControllerOriginalImage]];
                               
                               [imgBlurProfile setImageToBlur:(UIImage *)dictData[UIImagePickerControllerOriginalImage] blurRadius:8 completionBlock:^{
                                   
                               }];
                               
                               [[ServiceHandler sharedInstance].travelerWebService processEditImage:@{@"vProfilePic" : imgProfile.image} SuccessBlock:^(NSDictionary *response)
                                {
                                    if ([response[success] intValue] == 1)
                                    {
                                        travelerProfile.vProfilePic = response[data][@"vProfilePic"];
                                        [LooperUtility settingTravelerProfile:travelerProfile];
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

-(NSDictionary *)createParamDictionary
{
    NSString *firstname = [_txtFirstName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *lastname = [_txtLastName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    NSString *phoneNumber = [txtPhoneNumber.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
   
    
    NSDictionary *dictionary = @{@"vFullName" : [NSString stringWithFormat:@"%@ %@",firstname,lastname],

                                 @"vPhone" : phoneNumber,
                                 @"iLanguageID": [[travelerProfile.languages valueForKey:@"iLanguageID"] componentsJoinedByString:@","]
                                 };
    
    return dictionary;
}


- (IBAction)btnLanguagePressed:(id)sender
{
    UIStoryboard *Lopper = [UIStoryboard storyboardWithName:@"Looper" bundle:nil];
    //  self.ViewObj = [[ViewController alloc] init];
    SelectLanguageVC *vc = [Lopper instantiateViewControllerWithIdentifier:@"SelectLanguageVCID"];
    vc.contaionsLanguage = [[NSMutableArray alloc] initWithArray:travelerProfile.languages];
    vc.selectLangDelegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(void)languageArray:(NSArray *)languages
{
    NSString *languaesName = [[languages valueForKey:@"vName"] componentsJoinedByString:@", "];
    travelerProfile.languages = [[NSArray alloc] initWithArray:languages];
    
    if (languaesName.length > 0)
        _lblLanguage.text = languaesName;
    
}
@end
