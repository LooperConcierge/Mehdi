//
//  PaymentVC.m
//  Looper
//
//  Created by rakesh on 2/9/17.
//  Copyright © 2017 rakesh. All rights reserved.
//

#import "PaymentVC.h"
#import "BKCardNumberField.h"
#import "BKCardExpiryField.h"
#import "BKCurrencyTextField.h"

@interface PaymentVC ()
{
    NSString *month;
    NSString *year;
}
@property (strong, nonatomic) IBOutlet BKCardExpiryField *cardExpiryField;
@property (strong, nonatomic) IBOutlet BKCardNumberField *cardNumberField;

@property (strong, nonatomic) IBOutlet BKCurrencyTextField *amount;
@property (strong, nonatomic) IBOutlet UITextField *txtCVV;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalCharge;

@end

@implementation PaymentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _txtCVV.userInteractionEnabled = true;
    _txtCVV.secureTextEntry = true;
    self.cardNumberField.showsCardLogo = YES;
    [self.cardNumberField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.cardExpiryField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    self.amount.numberFormatter.currencySymbol = @"$";
    self.amount.numberFormatter.currencyCode = @"USD";
    self.amount.userInteractionEnabled = false;
    self.txtCVV.placeholder = @"CVV/CVC";
    self.txtCVV.keyboardType = UIKeyboardTypeNumberPad;
    
    if (self.txtCVV.placeholder != nil)
    {
        
        self.txtCVV.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.self.txtCVV.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
    }
    self.amount.text = [NSString stringWithFormat:@"%@ %.2f",self.amount.numberFormatter.currencySymbol,(_tripCharge + _serviceCharge)];
    _lblTotalCharge.text = [NSString stringWithFormat:@"Looper charge (%@%.2f) + Service fee (%@%.2f)",self.amount.numberFormatter.currencySymbol,_tripCharge,self.amount.numberFormatter.currencySymbol,_serviceCharge];
    // Do any additional setup after loading the view.
}

- (void)textFieldEditingChanged:(id)sender
{
    if (sender == self.cardExpiryField) {
        
        NSDateComponents *dateComp = self.cardExpiryField.dateComponents;
//        self.cardExpiryLabel.text = [NSString stringWithFormat:@"month=%ld, year=%ld", dateComp.month, dateComp.year];
        
        month =  [NSString stringWithFormat:@"%ld",(long)dateComp.month];
        year =  [NSString stringWithFormat:@"%ld",(long)dateComp.year];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnPayPressed:(id)sender
{
    NSString *message = @"";
    
    NSString *cardCompany = self.cardNumberField.cardCompanyName;
    if (nil == cardCompany) {
        message = @"Card number invalid";
    }
    else if (_cardNumberField.text.length == 0)
    {
        message = @"Please enter card number";
    }
    else if (_cardExpiryField.text.length == 0)
    {
        message = @"Please enter expiration date";
    }
    else if (_txtCVV.text.length == 0)
    {
        message = @"Please enter cvv/cvc number";
    }
    
    if (message.length > 0)
    {
        [AJNotificationView showNoticeInView:[[[UIApplication sharedApplication] delegate] window] type:AJNotificationTypeRed title:message linedBackground:AJLinedBackgroundTypeDisabled hideAfter:2.5];
        return;
    }
    
    NSDictionary *param = @{@"vCardNumber" : self.cardNumberField.cardNumber,
                            @"dExpiryMonth" : month,
                            @"dExpiryYear" : year,
                            @"iCvv" : [_txtCVV.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],
                            @"vCardName" : @"",
                            @"iTotalCharge" : [NSString stringWithFormat:@"%.2f",_tripCharge],
                            @"iOwnerCharge" : [NSString stringWithFormat:@"%.2f",_serviceCharge],
                            @"iTripID" : [NSString stringWithFormat:@"%d",self.reqObj.iTripID],
                            @"iLooperID" : self.looperDict[@"iLooperID"]
                            };
    
    
    [[ServiceHandler sharedInstance].travelerWebService processPaymentTripWithParam:param SuccessBlock:^(NSDictionary *response)
     {
         if ([response[@"SUCCESS"] intValue] == 1)
         {
             [LooperUtility createAlertWithTitle:@"Looper" message:response[data][@"MESSAGE"] style:UIAlertControllerStyleAlert controller:self actionHandler:^(UIAlertAction *action)
             {
                 [self.navigationController popViewControllerAnimated:true];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
