//
//  RegisterFormVC.m
//  Looper
//
//  Created by hardik on 2/1/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "RegisterFormVC.h"
#import "ExpertiseGalleryViewController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "HGImagePicker.h"
#import "UIView+AutoLayoutHideView.h"
#import "FacebookHandler.h"
#import "SelectCityMapVC.h"
#import "SelectLanguageVC.h"
#import "CountryListViewController.h"

@interface RegisterFormVC ()<UITextFieldDelegate,SelectLanguageVCDelegate>
{
    HGImagePicker *hgImagePicker;
    NSString *fbID;
    NSArray *arrLanguage;
    __weak IBOutlet UIButton *btnUserPhoto;
    
}
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constRegisterHeight;
@property (strong, nonatomic) IBOutlet UITextField *txtName;
@property (strong, nonatomic) IBOutlet UIButton *btnRegister;
@property (strong, nonatomic) IBOutlet UIButton *btnFacebook;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UITextField *txtPhoneNumber;

@property (strong, nonatomic) IBOutlet UILabel *lblOr;
@property (strong, nonatomic) IBOutlet UITextField *txtLastName;
@property (strong, nonatomic) IBOutlet UILabel *lblLeftDash;
@property (strong, nonatomic) IBOutlet UILabel *lblRightDash;
@property (strong, nonatomic) IBOutlet UITextField * txtLanguage;
@property (strong, nonatomic) IBOutlet UIButton * btnCountryCode;
@property (strong, nonatomic) IBOutlet UIView *viewTerms;
@property (strong, nonatomic) IBOutlet UIButton *btnTerms;
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation RegisterFormVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareView];
    // Do any additional setup after loading the view.
}

-(void)prepareView
{
    self.title = @"REGISTER";
    fbID = @"";
    
    arrLanguage = [[NSArray alloc] init];
    UIButton *btnMale = [self.view viewWithTag:100];
    //    UIButton *btnFemale = [self.view viewWithTag:101];
    
    btnMale.selected = TRUE;
    self.btnRegister.titleLabel.font =[UIFont fontAvenirNextCondensedMediumWithSize:FONT_MEDIUM_SIZE];
    self.btnFacebook.titleLabel.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_MEDIUM_SIZE];
    self.lblOr.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_NORMAL_SIZE];
    [self.btnRegister setBackgroundColor:[UIColor lightRedBackgroundColor]];
    
    if (AppdelegateObject.looperGlobalObject.isLooper == true)
    {
        [self.btnRegister setTitle:@"NEXT" forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //Need to set title here back button issue (...)
    self.title = @"REGISTER";
}



-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.title = @"";
}


- (IBAction)btnRegisterWithFbPressed:(id)sender
{
    if (_btnFacebook.selected)
    {
        [self processRegister];
//        _btnFacebook.selected = FALSE;
    }
    else
    {
        [FacebookHandler loginFromViewController:self completion:^(NSError *error, id response)
         {
             if (error != nil)
             {
                 
             }
             else
             {
                 [self fillUserData:response];
                 _lblOr.hidden = TRUE;
                 _lblLeftDash.hidden = TRUE;
                 _lblRightDash.hidden = TRUE;
                 _constRegisterHeight.constant = 0;
                 _btnRegister.hidden = TRUE;
                 [UIView animateWithDuration:0.6 animations:^{
                     [self.view layoutIfNeeded];
                 }];
                 _btnFacebook.selected = TRUE;
             }
         }];
    }
}

- (IBAction)btnRegisterPressed:(id)sender
{
    NSString *mesg = [self validation];
    
        [self processRegister];
    
}


- (void)choosePhotoAsProfilePicture:(id)sender
{
    if (!hgImagePicker)
    {
        hgImagePicker = [[HGImagePicker alloc] init];
        hgImagePicker.typeOfPicker = kOnlyPhotos;
        hgImagePicker.typeOfCrop = kCropImage;
    }
    
    [hgImagePicker showImagePicker:self
               withNavigationColor:[UIColor blackColor]
                       imagePicked:^(NSDictionary *dictData) {
                           if (dictData[UIImagePickerControllerOriginalImage]) {
                               [btnUserPhoto setImage:(UIImage *)dictData[UIImagePickerControllerOriginalImage] forState:UIControlStateNormal];
                               [LooperUtility roundUIViewWithTransparentBackground:btnUserPhoto];
                               if (!btnUserPhoto.layer.masksToBounds) {
                                   btnUserPhoto.layer.masksToBounds = YES;
                                   
                               }
                           }
                       }
                     imageCanceled:^{
                     }
                      imageRemoved:([self isPhotoUploaded] ? ^{
        [btnUserPhoto setImage:[UIImage imageNamed:@"profilePic"] forState:UIControlStateNormal];
        // imgViewUserPhoto.image = [UIImage imageNamed:@"imgUserPhotoBlack"];
    } : nil)];
}

-(BOOL)isPhotoUploaded {
    NSData *firstData = UIImagePNGRepresentation([UIImage imageNamed:@"profilePic"]);
    NSData *secondData = UIImagePNGRepresentation(btnUserPhoto.imageView.image);
    
    if ([firstData isEqualToData:secondData]) {
        return NO;
    } else {
        return YES;
    }
}

- (IBAction)btnProfilePicPressed:(id)sender {
    [self choosePhotoAsProfilePicture:sender];
}

- (IBAction)btnSelectGenderPressed:(id)sender
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


#pragma MARK - Private methods

-(NSString *)validation
{
    NSString *message = @"";
    
    if (![self isPhotoUploaded])
    {
        message = @"Please upload a photo";
    }
    else if (![_txtName.text isValidString])
    {
        [_txtName becomeFirstResponder];
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
        message = @"Please enter a valid email address";
    }
    else if (![_txtPassword.text isValidString])
    {
        [_txtPassword becomeFirstResponder];
        message = @"Please enter password";
    }
    else if ([_txtPassword.text length] < 6)
    {
        [_txtPassword becomeFirstResponder];
        message = @"Password length should be 6 characters or more";
    }
    else if (![_txtPhoneNumber.text isValidString])
    {
        [_txtPhoneNumber becomeFirstResponder];
        message = @"Please enter phone number";
    }
    else if (![_txtPhoneNumber.text isValidPhoneNumber])
    {
        [_txtPhoneNumber becomeFirstResponder];
        message = @"Please enter a valid phone number";
    }
    else if (arrLanguage.count == 0)
    {
        message = @"Please select the language";
    }
    
    return message;
}

-(void)fillUserData:(NSDictionary *)response
{
    //    {
    //        birthday = "10/31/1991";
    //        email = "hardik.jogi@openxcellinc.com";
    //        "first_name" = John;
    //        id = 110767945977404;
    //        "last_name" = King;
    //        location =     {
    //            id = 115440481803904;
    //            name = "Ahmedabad, India";
    //        };
    //        name = "John King";
    //    }
    fbID = response[@"id"];
    _txtEmail.text = response[@"email"];
    _txtName.text = response[@"first_name"];
    _txtLastName.text = response[@"last_name"];
    [btnUserPhoto setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=150&height=150",fbID]] placeholderImage:[UIImage imageNamed:@"profilePic"]];
    [LooperUtility roundUIViewWithTransparentBackground:btnUserPhoto];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(NSDictionary *)createParamDictionary
{
    NSString *firstname = [_txtName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *lastname = [_txtLastName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *email = [_txtEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [_txtPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *phoneNumber = [_txtPhoneNumber.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    
    NSDictionary *dictionary = @{@"vFullName" : [NSString stringWithFormat:@"%@ %@",firstname,lastname],
                                 @"vEmail" : email,
                                 @"vPassword" : [password md5],
                                 @"vCode" :[NSString stringWithFormat:@"%@",_btnCountryCode.titleLabel.text],
                                 @"vPhone" : [NSString stringWithFormat:@"%@",phoneNumber],
                                 @"ePlatform" : @"ios",
                                 @"vDeviceToken" : (![AppdelegateObject.deviceToken isEqualToString:@""])?AppdelegateObject.deviceToken:@"SIMULATOR",
                                 @"vFBID" : fbID,
                                 @"iLanguageID" : [[arrLanguage valueForKey:@"iLanguageID"] componentsJoinedByString:@","]};
    
    return dictionary;
}

-(void)processRegister
{
    NSString *message = [self validation];
    
    if (message.length > 0)
    {
        [AJNotificationView showNoticeInView:[[[UIApplication sharedApplication] delegate] window]
                                        type:AJNotificationTypeRed
                                       title:message
                             linedBackground:AJLinedBackgroundTypeDisabled
                                   hideAfter:2.5f];
        
        return;
    }
    
    NSDictionary *dict = [self createParamDictionary];
    
    [[ServiceHandler sharedInstance].webService processTravelerSignUp:dict imageData:@{@"vProfilePic" :btnUserPhoto.imageView.image} successBlock:^(NSDictionary *response)
     {
         UserModel *userObject = [[UserModel alloc] initWithDictionary:response error:nil];
         
         [AJNotificationView showNoticeInView:[[[UIApplication sharedApplication] delegate] window]
                                         type:AJNotificationTypeRed
                                        title:@"Sign-Up Successful"
                              linedBackground:AJLinedBackgroundTypeDisabled
                                    hideAfter:2.5f];
         
         [LooperUtility settingCurrentUser:userObject];
         AppdelegateObject.looperGlobalObject.isLooper = FALSE;
//         [self openSelectCity];

                [LooperUtility isAlreadyLoginTraveler];

     } errorBlock:^(NSError *error) {
         
     }];
    
}


-(void)languageArray:(NSArray *)languages
{
    NSString *languaesName = [[languages valueForKey:@"vName"] componentsJoinedByString:@", "];
    arrLanguage = [[NSArray alloc] initWithArray:languages];
    
    if (languaesName.length > 0)
        _txtLanguage.text = languaesName;
}


-(void)openSelectCity
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Traveler" bundle:nil];
    SelectCityMapVC *cityVC = [storyBoard instantiateViewControllerWithIdentifier:@"SelectCityMapVCID"];
    [self.navigationController pushViewController:cityVC animated:YES];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)btnLanguagePressed:(id)sender
{
    UIStoryboard *Lopper = [UIStoryboard storyboardWithName:@"Looper" bundle:nil];
    //  self.ViewObj = [[ViewController alloc] init];
    SelectLanguageVC *vc = [Lopper instantiateViewControllerWithIdentifier:@"SelectLanguageVCID"];
    vc.contaionsLanguage = [[NSMutableArray alloc] initWithArray:arrLanguage];
    vc.selectLangDelegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnAgreePressed:(id)sender
{
//    if (_btnTerms.selected)
//    {
        [UIView animateWithDuration:0.3 animations:^{
            _viewTerms.alpha = 0;
            [self processRegister];
        } completion: ^(BOOL finished) {//creates a variable (BOOL) called "finished" that is set to *YES* when animation IS completed.
            _viewTerms.hidden = finished;//if animation is finished ("finished" == *YES*), then hidden = "finished" ... (aka hidden = *YES*)
        }];
//    }
//    else
//    {
//        [AJNotificationView showNoticeInView:[[[UIApplication sharedApplication] delegate] window]
//                                        type:AJNotificationTypeRed
//                                       title:@"Please check terms & condition box"
//                             linedBackground:AJLinedBackgroundTypeDisabled
//                                   hideAfter:2.5f];
//    }
}
- (IBAction)btnDisAgreePressed:(id)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        _viewTerms.alpha = 0;
    } completion: ^(BOOL finished) {//creates a variable (BOOL) called "finished" that is set to *YES* when animation IS completed.
        _viewTerms.hidden = finished;//if animation is finished ("finished" == *YES*), then hidden = "finished" ... (aka hidden = *YES*)
    }];
}

- (IBAction)btnCountryCodePressed:(id)sender
{
    CountryListViewController *cv = [[CountryListViewController alloc] initWithNibName:@"CountryListViewController" delegate:self];
    [self presentViewController:cv animated:YES completion:NULL];
    
}

- (IBAction)btnTermsCheckBoxPressed:(id)sender
{
    _btnTerms.selected = !_btnTerms.selected;
}


- (void)didSelectCountry:(NSDictionary *)country
{
    NSLog(@"%@", country);
    [_btnCountryCode setTitle:country[@"dial_code"] forState:UIControlStateNormal];
}

@end
