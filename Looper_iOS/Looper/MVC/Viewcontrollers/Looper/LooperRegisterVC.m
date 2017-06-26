//
//  LooperRegisterVC.m
//  Looper
//
//  Created by hardik on 4/15/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "LooperRegisterVC.h"
#import "HGImagePicker.h"
#import "FacebookHandler.h"
#import "CountryListViewController.h"
#import "IQUIView+Hierarchy.h"
#import "SelectLanguageVC.h"
#import "ExpertiseGalleryViewController.h"

@interface LooperRegisterVC () <UITextFieldDelegate>
{
    HGImagePicker *hgImagePicker;
    NSArray *cityArray;
    NSDictionary *cityDictionary;
    NSString *fbID;
    NSArray *arrLanguage;
}
@property (strong, nonatomic) IBOutlet UIButton *btnCountryCode;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constRegisterHeight;
@property (strong, nonatomic) IBOutlet UITextField *txtName;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UITextField *txtPhoneNumber;
@property (strong, nonatomic) IBOutlet UITextField *txtLanguage;

@property (strong, nonatomic) IBOutlet UITextField *txtSelectCity;
@property (strong, nonatomic) IBOutlet UITextField *txtLastName;

@property (strong, nonatomic) IBOutlet UIButton *btnRegister;
@property (strong, nonatomic) IBOutlet UIButton *btnFacebook;
@property (strong, nonatomic) IBOutlet UILabel *lblOr;
@property (strong, nonatomic) IBOutlet UILabel *lblLeftDash;
@property (strong, nonatomic) IBOutlet UILabel *lblRightDash;
@property (strong, nonatomic) IBOutlet UIButton *btnUserPhoto;

@end

@implementation LooperRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self preview];
    // Do any additional setup after loading the view.
}

-(void)preview
{
    fbID = @"";
    UIButton *btnMale = [self.view viewWithTag:100];
    
    btnMale.selected = TRUE;
    self.btnRegister.titleLabel.font =[UIFont fontAvenirNextCondensedMediumWithSize:FONT_MEDIUM_SIZE];
    self.btnFacebook.titleLabel.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_MEDIUM_SIZE];
    
    self.lblOr.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_NORMAL_SIZE];
    [self.btnRegister setBackgroundColor:[UIColor lightRedBackgroundColor]];
    
//    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[self class]];
    [[ServiceHandler sharedInstance].webService processGetCity:nil successBlock:^(NSDictionary *response)
     {
         DebugLog(@"Response %@",response);
         
         if ([response isKindOfClass:[NSArray class]])
         {
             cityArray = [[NSArray alloc] initWithArray:(NSArray *)response];
         }
         //        cityArray = [[NSArray alloc] initWithArray:response];
         
     } errorBlock:^(NSError *error)
     {
         DebugLog(@"error %@",error);
     }];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField == _txtEmail && textField.text.length > 0)
    {
        [self checkEmailExist:^(BOOL status, NSDictionary *dictionary) {
            
        } failure:^(NSError *error) {
            
        }];
    }
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return TRUE;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
//    if (textField == _txtDEateOfBirth)
//    {
//        if (textField.isAskingCanBecomeFirstResponder == NO)
//        {
//            NSDate *dateSet;
//            if (_txtDEateOfBirth.text.length >0)
//            {
//                dateSet = [LooperUtility dateFromString:_txtDEateOfBirth.text];
//            }
//            else
//            {
//                dateSet = [NSDate date];
//            }
//            [[LooperUtility sharedInstance] showActionSheetDatePickerInView:self.view setMaxDate:nil selectedDate:dateSet doneBlock:^(NSDate *selectedDate)
//             {
//                 _txtDEateOfBirth.text = [LooperUtility stringFromDate:selectedDate];
//             }];
//        }
//        return NO;
//    }
//    else {
        return YES;
//    }
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

- (IBAction)btnNextPressed:(id)sender
{
    if ([self continueRegister] != 0)
    {
        [self openUploadDocumentController];
    };
    
}

- (IBAction)btnLoginWithFBPressed:(id)sender
{
    if (_btnFacebook.selected)
    {
        int i = [self continueRegister];
        if (i != 0)
        {
//            _btnFacebook.selected = FALSE;
            [self openUploadDocumentController];
        }
        
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
                 _lblOr.hidden = TRUE;
                 _lblLeftDash.hidden = TRUE;
                 _lblRightDash.hidden = TRUE;
                 _constRegisterHeight.constant = 0;
                 _btnRegister.hidden = TRUE;
                 [UIView animateWithDuration:0.6 animations:^{
                     [self.view layoutIfNeeded];
                 }];
                 [self fillUserData:response];
                 _btnFacebook.selected = TRUE;
             }
         }];
    }
    
}

//- (IBAction)btnDateOfBirthPressed:(id)sender
//{
//    [self.view endEditing:YES];
//    
//    NSDate *dateSet;
//    if (_txtDEateOfBirth.text.length >0)
//    {
//        dateSet = [LooperUtility dateFromString:_txtDEateOfBirth.text];
//    }
//    else
//    {
//        dateSet = [NSDate date];
//    }
//    [[LooperUtility sharedInstance] showActionSheetDatePickerInView:self.view setMaxDate:nil selectedDate:dateSet doneBlock:^(NSDate *selectedDate)
//     {
//         _txtDEateOfBirth.text = [LooperUtility stringFromDate:selectedDate];
//     }];
//
//}
- (IBAction)btnSelectCityPressed:(id)sender {
    
    [self.view endEditing:YES];
    //        NSMutableArray *arrCity = [NSMutableArray ];
    NSMutableArray *cityNames = [(cityArray.count > 0 ?[cityArray valueForKey:@"vName"]:@[]) mutableCopy];
    if (cityNames.count == 0)
    {
        [AJNotificationView showNoticeInView:[[[UIApplication sharedApplication] delegate] window]
                                        type:AJNotificationTypeRed
                                       title:@"Internet connection is not available"
                             linedBackground:AJLinedBackgroundTypeDisabled
                                   hideAfter:2.5f];
        
        return;
    }
    
    [cityNames addObject:@"other"];
    
    [LooperUtility createActionsheetWithTitle:@"Select city" message:nil actions:cityNames style:UIAlertControllerStyleActionSheet controller:self actionHandler:^(UIAlertAction *action) {
        
        NSLog(@"Action %@",action);
        if ([[action.title lowercaseString] isEqualToString:@"cancel"])
        {
            
        }
        else if ([[action.title lowercaseString] isEqualToString:@"other"])
        {
            [self openOtherCityTextField];
        }
        else
        {
            _txtSelectCity.text = action.title;
            for (NSDictionary *dict in cityArray)
            {
                if ([[dict[@"vName"] lowercaseString] isEqualToString:[action.title lowercaseString]])
                {
                    cityDictionary = dict;
                }
            }
        }
        
    }];

    
}

-(void)openOtherCityTextField
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Provide city"
                                                                              message: @"Input city name"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"City name";
        textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
        textField.textColor = [UIColor blackColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action){
                                                   //Do Some action here
                                                   UITextField *textField = alertController.textFields[0];
                                                   NSLog(@"text was %@", textField.text);
                                                   _txtSelectCity.text = textField.text;
                                                   cityDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:@"0",@"iCityID",textField.text,@"vName", nil];
                                                   [LooperUtility createAlertWithTitle:@"Oops!" message:@"We haven’t made it there yet, fear not, we are working on it. As soon as we get there you will be the first to know! In the meantime, please continue your registration." style:UIAlertControllerStyleAlert controller:self actionHandler:^(UIAlertAction *action)
                                                   {
                                                       
                                                   }];
                                               }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       
                                                       NSLog(@"cancel btn");
                                                       
                                                       [alertController dismissViewControllerAnimated:YES completion:nil];
                                                       
                                                   }];
    
    [alertController addAction:ok];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
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
                           if (dictData[UIImagePickerControllerOriginalImage])
                           {
                               
                               [self.btnUserPhoto setImage:(UIImage *)dictData[UIImagePickerControllerOriginalImage] forState:UIControlStateNormal];
                               
                               [LooperUtility roundUIViewWithTransparentBackground:self.btnUserPhoto];
                               
                               if (!self.btnUserPhoto.layer.masksToBounds)
                               {
                                   self.btnUserPhoto.layer.masksToBounds = YES;
                                   
                               }
                           }
                       }
                     imageCanceled:^{
                     }
                      imageRemoved:([self isPhotoUploaded] ? ^{
        [self.btnUserPhoto setImage:[UIImage imageNamed:@"profilePic"] forState:UIControlStateNormal];
        // imgViewUserPhoto.image = [UIImage imageNamed:@"imgUserPhotoBlack"];
    } : nil)];
}

-(BOOL)isPhotoUploaded {
    NSData *firstData = UIImagePNGRepresentation([UIImage imageNamed:@"profilePic"]);
    NSData *secondData = UIImagePNGRepresentation(self.btnUserPhoto.imageView.image);
    
    if ([firstData isEqualToData:secondData]) {
        return NO;
    } else {
        return YES;
    }
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
    
    [_btnUserPhoto setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=150&height=150",fbID]] placeholderImage:[UIImage imageNamed:@"profilePic"]];
    [LooperUtility roundUIViewWithTransparentBackground:_btnUserPhoto];
    
}

- (IBAction)btnProfilePicPressed:(id)sender {
    [self choosePhotoAsProfilePicture:sender];
}

#pragma MARK - Private methods

-(NSString *)validation
{
    NSString *message = @"";
    
    if (![_txtName.text isValidString])
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
    else if (![_txtPhoneNumber.text isValidPhoneNumber])
    {
        [_txtPhoneNumber becomeFirstResponder];
        message = @"Please enter phone number";
    }
//    else if (![_txtDEateOfBirth.text isValidString])
//    {
//        [_txtDEateOfBirth becomeFirstResponder];
//        message = @"Please enter date of birth";
//    }
    else if (![_txtSelectCity.text isValidString])
    {
        [_txtSelectCity becomeFirstResponder];
        message = @"Please select city";
    }
    else if (![self isPhotoUploaded])
    {
        message = @"Please upload a photo";
    }
    else if (![_txtLanguage.text isValidString])
    {
        message = @"Please select the language";
    }
    
    return message;
}

#pragma mark
-(NSDictionary *)signUpParameter
{
    NSString *strFirstName = [_txtName.text stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    NSString *strLastName = [_txtLastName.text stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    NSString *strEmail = [_txtEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    NSString *strPassword = [_txtPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    NSString *strPhoneNumber = [_txtPhoneNumber.text stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
//    NSString *strbDate = [_txtDEateOfBirth.text stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
//    NSString *strGender = @"";
//    NSString *strSelectCity = [_txtSelectCity.text stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
//    
//    UIButton *btnMale = [self.view viewWithTag:100];
//    
//    if (btnMale.selected)
//    {
//        strGender = @"Male";
//    }
//    else
//    {
//        strGender = @"Female";
//    }
    
    NSDictionary *dictParam = @{@"vFullName" : [NSString stringWithFormat:@"%@ %@",strFirstName,strLastName],
                                @"vEmail" : strEmail,
                                @"vPassword" : [strPassword md5],
                                @"vPhone" : strPhoneNumber,
                                @"ePlatform" : PLATFORM,
                                @"vDeviceToken" : [LooperUtility deviceToken],
                                @"images" :@{@"vProfilePic" : self.btnUserPhoto.imageView.image},
                                @"iCityID" : [NSNumber numberWithInt:[cityDictionary[@"id"] intValue]],
                                @"vCityName" : cityDictionary[@"vName"],
                                @"vFBID" : fbID,
                                @"isDefaultCity" : ([cityDictionary[@"id"] intValue] > 0 ? @"0" : @"1"),
                                @"vCode" : _btnCountryCode.titleLabel.text,
                                @"vPhone" : strPhoneNumber,
                                @"iLanguageID" : [[arrLanguage valueForKey:@"iLanguageID"] componentsJoinedByString:@","]
                                };
    
    if ([LooperUtility sharedInstance].looperSignupDict != nil)
    {
        for (NSString *keys in dictParam.allKeys)
        {
            if ([keys isEqualToString:@"images"])
            {
                NSDictionary *dictImage = [[LooperUtility sharedInstance].looperSignupDict valueForKey:@"images"];
                NSMutableDictionary *newDictionary = [[NSMutableDictionary alloc] initWithDictionary:[[LooperUtility sharedInstance].looperSignupDict valueForKey:@"images"]];
                
                for (NSString *newKey in dictImage.allKeys)
                {
                    if ([newKey isEqualToString:@"vProfilePic"])
                    {
                        [newDictionary setValue:self.btnUserPhoto.imageView.image forKey:@"vProfilePic"];
                    }
                }
                [[LooperUtility sharedInstance].looperSignupDict setValue:newDictionary forKey:keys];
            }
            else
                [[LooperUtility sharedInstance].looperSignupDict setValue:dictParam[keys] forKey:keys];
        }
    }
    return dictParam;
}

-(int)continueRegister
{
    NSString *message = [self validation];
    
    if (message.length > 0)
    {
        [AJNotificationView showNoticeInView:[[[UIApplication sharedApplication] delegate] window]
                                        type:AJNotificationTypeRed
                                       title:message
                             linedBackground:AJLinedBackgroundTypeDisabled
                                   hideAfter:2.5f];
        return 0;
    }
    else
    {
        return 1;
    }
    
}

-(void)openUploadDocumentController
{
    if ([LooperUtility sharedInstance].looperSignupDict != nil)
    {
        [self signUpParameter];
    }
    else
    {
        [LooperUtility sharedInstance].looperSignupDict = [[NSMutableDictionary alloc] initWithDictionary:[self signUpParameter]];
    }
    //
    [self checkEmailExist:^(BOOL status, NSDictionary *dictionary) {
        if (status == NO && [dictionary[@"emailExist"] intValue] == 0)
        {
            UIStoryboard *Lopper = [UIStoryboard storyboardWithName:@"Looper" bundle:nil];
            //  self.ViewObj = [[ViewController alloc] init];
            ExpertiseGalleryViewController *vc = [Lopper instantiateViewControllerWithIdentifier:@"ExpertiseGalleryViewController"];
            vc.isProfileController = UPLOAD_DOCUMENT;
            [self.navigationController pushViewController:vc animated:YES];
//            [self performSegueWithIdentifier:@"segueUploadDoc" sender:nil];
        }
    } failure:^(NSError *error) {
        
    }];

}

-(void)checkEmailExist:(void (^) (BOOL status, NSDictionary *dictionary))successBlock failure:(void (^)(NSError *error))errorBlock
{
    [[ServiceHandler sharedInstance].webService processCheckEmail:[_txtEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] successBlock:^(NSDictionary * response)
     {
         if ([response[@"emailExist"] intValue] == 1)
         {
             [AJNotificationView showNoticeInView:[[[UIApplication sharedApplication] delegate] window]
                                             type:AJNotificationTypeRed
                                            title:@"Email is already exist.\n please provide new email id"
                                  linedBackground:AJLinedBackgroundTypeDisabled
                                        hideAfter:2.5f];
             successBlock(YES,response);
         }
         else
         {
             successBlock(NO,response);
         }
     } errorBlock:^(NSError *error)
     {
         errorBlock(error);
     }];
}


- (IBAction)btnCountryCodePressed:(id)sender
{
    CountryListViewController *cv = [[CountryListViewController alloc] initWithNibName:@"CountryListViewController" delegate:self];
    [self presentViewController:cv animated:YES completion:NULL];
    
}


- (void)didSelectCountry:(NSDictionary *)country
{
    NSLog(@"%@", country);
    [_btnCountryCode setTitle:country[@"dial_code"] forState:UIControlStateNormal];
}


-(void)languageArray:(NSArray *)languages
{
    NSString *languaesName = [[languages valueForKey:@"vName"] componentsJoinedByString:@", "];
    arrLanguage = [[NSArray alloc] initWithArray:languages];
    
    if (languaesName.length > 0)
        _txtLanguage.text = languaesName;
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
