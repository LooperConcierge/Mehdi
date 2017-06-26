//
//  UploadDocumentVC.m
//  Looper
//
//  Created by hardik on 4/18/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "UploadDocumentVC.h"
#import "ExpertiseGalleryViewController.h"
#import "HGImagePicker.h"
#import "SelectLanguageVC.h"

@interface UploadDocumentVC ()<SelectLanguageVCDelegate>
{
    HGImagePicker *hgImagePicker;
    NSArray * arrLanguage;
}
@property (strong, nonatomic) IBOutlet UIButton *btnW9Form;
@property (strong, nonatomic) IBOutlet UIButton *btnIDProof;
@property (strong, nonatomic) IBOutlet UILabel *lblVerificationText;
@property (strong, nonatomic) IBOutlet UITextView *txtView;


@end

@implementation UploadDocumentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareView];
    // Do any additional setup after loading the view.
}

-(void)prepareView
{
    _btnW9Form.layer.cornerRadius = 4;
    _btnIDProof.layer.cornerRadius = 4;
    _btnW9Form.layer.borderWidth = 0.5;
    _btnIDProof.layer.borderWidth = 0.5;
    _btnW9Form.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _btnIDProof.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _btnW9Form.layer.masksToBounds = YES;
    _btnIDProof.layer.masksToBounds = YES;
    _btnW9Form.titleLabel.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_MEDIUM_SIZE];
    _btnIDProof.titleLabel.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_MEDIUM_SIZE];
    _lblVerificationText.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_SMALL_SIZE];
    DebugLog(@"Looper signup dict %@ ",[LooperUtility sharedInstance].looperSignupDict);
    
    if ([LooperUtility sharedInstance].looperSignupDict != nil)
    {

        if ([[LooperUtility sharedInstance].looperSignupDict objectForKey:@"images"])
        {
            NSDictionary *dictImages = [[NSDictionary alloc] initWithDictionary:[[LooperUtility sharedInstance].looperSignupDict valueForKey:@"images"]];
            
            UIImage *w9Form = [dictImages objectForKey:@"vWNineForm"];
            
            UIImage *idProof = [dictImages objectForKey:@"vUSResProof"];
            
            if (w9Form !=nil)
            {
                [_btnW9Form setImage:w9Form forState:UIControlStateNormal];
                [_btnW9Form setTitle:@"" forState:UIControlStateNormal];
            }
            
            if (idProof != nil)
            {
                [_btnIDProof setImage:idProof forState:UIControlStateNormal];
                [_btnIDProof setTitle:@"" forState:UIControlStateNormal];
            }
        }
    }
    
    arrLanguage = [[NSArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnNextPressed:(id)sender
{
    NSString *message = [self valdiation];
    
    if (message.length > 0)
    {
        [AJNotificationView showNoticeInView:[[[UIApplication sharedApplication] delegate] window]
                                        type:AJNotificationTypeRed
                                       title:message
                             linedBackground:AJLinedBackgroundTypeDisabled
                                   hideAfter:2.5f];
        
        return;
    }
    
    [self createSignupDictionary];
    
    //Uncomment the above section for
    
    UIStoryboard *Lopper = [UIStoryboard storyboardWithName:@"Looper" bundle:nil];
    //  self.ViewObj = [[ViewController alloc] init];
    ExpertiseGalleryViewController *vc = [Lopper instantiateViewControllerWithIdentifier:@"ExpertiseGalleryViewController"];
    vc.isProfileController = UPLOAD_DOCUMENT;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnUploadDocumentPressed:(id)sender
{
    [self choosePhotoAsProfilePicture:sender];
}

- (void)choosePhotoAsProfilePicture:(id)sender {
    if (!hgImagePicker) {
        hgImagePicker = [[HGImagePicker alloc] init];
        hgImagePicker.typeOfPicker = kOnlyPhotos;
        hgImagePicker.typeOfCrop = kOriginalImage;
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
            else if (btn == _btnIDProof)
            {
                [_btnIDProof setTitle:@"" forState:UIControlStateNormal];
                [self.btnIDProof setImage:(UIImage *)dictData[UIImagePickerControllerOriginalImage] forState:UIControlStateNormal];
            }
           
        }
    
    } imageCanceled:^{
        
    } imageRemoved:nil];
}


-(BOOL)checkTitle:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    BOOL hasTitle;
    
    if (btn == _btnW9Form)
    {
        if( _btnW9Form.currentTitle.length > 0 )
            hasTitle = TRUE;
        else
            hasTitle = FALSE;
    }
    else if (btn == _btnIDProof)
    {
        if( _btnIDProof.currentTitle.length > 0 )
            hasTitle = TRUE;
        else
            hasTitle = FALSE;
     
    }
    
    return hasTitle;
}

-(NSString *)valdiation
{
    NSString *message = @"";
    
    if (_btnW9Form.imageView.image == nil)
    {
        message = @"Please upload form";
    }
    else if (_btnIDProof.imageView.image == nil)
    {
        message = @"Please upload id proof";
    }
    return message;
}

-(void)createSignupDictionary
{
    
    NSMutableDictionary *dictImages = [[NSMutableDictionary alloc] initWithDictionary:[[LooperUtility sharedInstance].looperSignupDict valueForKey:@"images"]];
    
    [dictImages setObject:_btnW9Form.imageView.image forKey:@"vWNineForm"];
    [dictImages setObject:_btnIDProof.imageView.image forKey:@"vUSResProof"];
    
    
    [[LooperUtility sharedInstance].looperSignupDict setValue:dictImages forKey:@"images"];
    
    NSLog(@"Looper signup dictionary %@",[LooperUtility sharedInstance].looperSignupDict);
    
}

- (IBAction)btnSkipPressed:(id)sender
{
    [LooperUtility createOkAndCancelAlertWithTitle:@"Looper" message:@"Please note that your account will not be active until you upload these documents." style:UIAlertControllerStyleAlert controller:self actionHandler:^(UIAlertAction *action)
    {
        if ([action.title isEqualToString:@"OK"])
        {
            UIStoryboard *Lopper = [UIStoryboard storyboardWithName:@"Looper" bundle:nil];
            //  self.ViewObj = [[ViewController alloc] init];
            ExpertiseGalleryViewController *vc = [Lopper instantiateViewControllerWithIdentifier:@"ExpertiseGalleryViewController"];
            vc.isProfileController = UPLOAD_DOCUMENT;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    
}


- (IBAction)btnFormPressed:(id)sender
{
    [LooperUtility createOkAndCancelAlertWithTitle:@"Looper" message:@"Do you want to open it in safari?" style:UIAlertControllerStyleAlert controller:self actionHandler:^(UIAlertAction *action) {
        
        if ([action.title isEqualToString:@"OK"])
        {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.irs.gov/forms-pubs"]];
        }
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
