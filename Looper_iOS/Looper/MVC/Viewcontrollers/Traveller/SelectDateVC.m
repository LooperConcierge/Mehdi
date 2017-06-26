//
//  SelectDateVC.m
//  Looper
//
//  Created by hardik on 2/2/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "SelectDateVC.h"
#import "IQKeyboardManager.h"


typedef enum : NSUInteger {
    TEXTFIELD_ARRIVALDATE,
    TEXTFIELD_DEPARTUREDATE,
} SelectTextField;



@interface SelectDateVC ()<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *txtArriveDate;
@property (strong, nonatomic) IBOutlet UITextField *txtDepartDate;
@property (strong, nonatomic) IBOutlet UIButton *btnContinue;

@property SelectTextField selectTextField;

@end

@implementation SelectDateVC
@synthesize txtArriveDate,txtDepartDate,btnContinue,selectTextField,paramDictionary;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareView];
    // Do any additional setup after loading the view.
}

-(void) prepareView
{
    //For disable the tool bar in the class
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[SelectDateVC class]];
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[SelectDateVC class]];
    txtArriveDate.placeholder = @"End";
    txtDepartDate.placeholder = @"Start";
    //Ending disable toolbar code
    self.title = [[LooperUtility sharedInstance].localization localizedStringForKey:keySelectDate];
    txtArriveDate.font = [UIFont fontAvenirWithSize:FONT_MEDIUM_SIZE];
    txtDepartDate.font = [UIFont fontAvenirWithSize:FONT_MEDIUM_SIZE];
    btnContinue.titleLabel.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_MEDIUM_SIZE];
    
//    txtArriveDate.placeholder = [[LooperUtility sharedInstance].localization localizedStringForKey:keyArriveDate];
//    txtDepartDate.placeholder = [[LooperUtility sharedInstance].localization localizedStringForKey:keyDepartDate];
    [btnContinue setTitle:[[LooperUtility sharedInstance].localization localizedStringForKey:keyContinue] forState:UIControlStateNormal];
    [btnContinue setBackgroundColor:[UIColor lightRedBackgroundColor]];
    
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
#pragma Mark - Textfield delegate methods
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == txtDepartDate)
    {
        selectTextField = TEXTFIELD_DEPARTUREDATE;
        [self setTextfiledDate];
    }
    else if (textField == txtArriveDate)
    {
        selectTextField = TEXTFIELD_ARRIVALDATE;
        [self setTextfiledDate];
    }
    [textField resignFirstResponder];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

#pragma Mark - private methods


- (IBAction)btnCancelPressed:(id)sender {
    [self textFieldresignResponsers];
}

- (IBAction)btnContinuePressed:(id)sender {
    
    NSString  *message = [self validate];
    if (message.length > 0)
    {
        [AJNotificationView showNoticeInView:AppdelegateObject.window type:AJNotificationTypeRed title:message linedBackground:AJLinedBackgroundTypeDisabled hideAfter:2.5];
        return;
    }
    [self textFieldresignResponsers];
    
    if (_fromController == FROM_BOOK_LOOPERCONTROLLER)
    {
        paramDictionary = [[NSMutableDictionary alloc] init];
        [paramDictionary setObject:[LooperUtility serverDateString:txtDepartDate.text] forKey:@"dDepartureDate"];
        [paramDictionary setObject:[LooperUtility serverDateString:txtArriveDate.text] forKey:@"dArrivalDate"];
        
        [self performSegueWithIdentifier:@"segueUnwindDetail" sender:nil];
    }
    else{
        [self performSegueWithIdentifier:@"segueSelectInterest" sender:nil];
    }
    
}

-(NSString *)validate
{
    NSString *message;
    
    NSDate *arrivalDate = (txtArriveDate.text.length > 0 ?[LooperUtility dateFromString:txtArriveDate.text]:nil);
    
    NSDate *departDate = (txtDepartDate.text.length > 0?[LooperUtility dateFromString:txtDepartDate.text]: nil);
    
    if (txtArriveDate.text.length == 0)
    {
        message = @"Please select start date";
    }
    else if (txtDepartDate.text.length == 0)
    {
        message = @"Please select end date";
    }
    else if ([departDate compare:arrivalDate] == NSOrderedDescending)
    {
        message = @"Please select correct date";
    }
    return message;
}

-(void) textFieldresignResponsers
{
    [txtArriveDate resignFirstResponder];
    [txtDepartDate resignFirstResponder];
}

-(void)setTextfiledDate
{
    if (selectTextField == TEXTFIELD_ARRIVALDATE)
    {
        NSString *strArrivalDate = txtArriveDate.text;
        
        if (strArrivalDate.length > 0)
        {
            NSDate *dateForPicker = [LooperUtility dateFromString:strArrivalDate];
            [[LooperUtility sharedInstance] showActionSheetDatePickerInView:self.view setMinDate:[NSDate date] setMaxDate:nil selectedDate:dateForPicker doneBlock:^(NSDate *selectedDate)
            {
                txtArriveDate.text = [LooperUtility stringFromDate:selectedDate];
                
            }];
        }
        else
        {
            NSDate *date = [NSDate date];
            NSString *strDate = [LooperUtility stringFromDate:date];
            NSDate *dDate = [LooperUtility dateFromString:strDate];
            [[LooperUtility sharedInstance] showActionSheetDatePickerInView:self.view setMinDate:[NSDate date] setMaxDate:nil selectedDate:dDate doneBlock:^(NSDate *selectedDate)
             {
                 txtArriveDate.text = [LooperUtility stringFromDate:selectedDate];
             }];
        }
    }
    else if(selectTextField == TEXTFIELD_DEPARTUREDATE)
    {
        NSString *strDepartureDate = txtDepartDate.text;
        
        if (strDepartureDate.length > 0)
        {
        
            NSDate *dateForPicker = [LooperUtility dateFromString:strDepartureDate];
            [[LooperUtility sharedInstance] showActionSheetDatePickerInView:self.view setMinDate:[NSDate date] setMaxDate:nil selectedDate:dateForPicker doneBlock:^(NSDate *selectedDate)
             {
               txtDepartDate.text = [LooperUtility stringFromDate:selectedDate];
             }];
        }
        else
        {
            // Need to set like this way otherwise it gets error
            
            NSDate *date = [NSDate date];
            NSString *strDate = [LooperUtility stringFromDate:date];
            NSDate *dDate = [LooperUtility dateFromString:strDate];
            [[LooperUtility sharedInstance] showActionSheetDatePickerInView:self.view setMinDate:[NSDate date] setMaxDate:nil selectedDate:dDate doneBlock:^(NSDate *selectedDate)
             {
                 txtDepartDate.text = [LooperUtility stringFromDate:selectedDate];
             }];
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segueSelectInterest"])
    {
        if (paramDictionary == nil)
        {
            paramDictionary = [[NSMutableDictionary alloc] init];
        }
        SelectInterestVC *selectInterest = segue.destinationViewController;
        [paramDictionary setObject:[LooperUtility serverDateString:txtDepartDate.text] forKey:@"dDepartureDate"];
        [paramDictionary setObject:[LooperUtility serverDateString:txtArriveDate.text] forKey:@"dArrivalDate"];
        selectInterest.paramDictionary = [[NSMutableDictionary alloc] initWithDictionary:paramDictionary];
        selectInterest.isFromBookController = FALSE;
        if (_fromController == FROM_BOOK_LOOPERCONTROLLER)
        {
            selectInterest.isFromBookController = TRUE;
        }
        
    }
}
@end
