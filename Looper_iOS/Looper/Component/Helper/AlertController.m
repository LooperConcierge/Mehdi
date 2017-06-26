//
//  AlertController.m
//  TipQuik
//
//  Created by Bharat Nakum on 10/23/15.
//  Copyright © 2015 OpenXCell Technolabs Pvt. Ltd. All rights reserved.
//

#import "AlertController.h"
#import "NYAlertViewController.h"
#import "NYAlertView.h"
#import "UIFont+CustomFont.h"
#import "AppDelegate.h"

#define STRING_REPORT @"Enter your report"

@interface AlertController () <UITextViewDelegate> {
    AppDelegate *appDelegate;
}

@property (nonatomic,readwrite) NSArray *arrTextFields;

@end

@implementation AlertController

+ (AlertController *)sharedInstance {
    static AlertController *alertController;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        alertController = [[AlertController alloc] init];
    });
    return alertController;
}

- (void)showAlertWithController:(UIViewController *)presentingController
                       andTitle:(NSString *)strTitle
                     andMessage:(NSString *)strMessage
         andArrayOfTotalActions:(NSArray *)arrTotalActions
                  andCompletion:(BlockCompletion)completionBlock
                withInputTextField:(BOOL)shouldAddTextField
              andTextFieldText:(NSString *)strTextFieldText {
    if (strTitle == nil) {
        strTitle = @"";
    }
    
    if (strMessage == nil) {
        strMessage = @"";
    }
    
    if (arrTotalActions == nil) {
        arrTotalActions = @[@"OK"];
    }
    
    NYAlertViewController *alertViewController = [[NYAlertViewController alloc] initWithNibName:nil bundle:nil];
    
    // Set a title and message
    alertViewController.title = NSLocalizedString(strTitle, nil);
    NSString *strForMessage = [NSString stringWithFormat:@"\n%@\n",strMessage];
    alertViewController.message = NSLocalizedString(strForMessage, nil);
    
    // Customize appearance as desired
    alertViewController.buttonCornerRadius = 2.0f;
    alertViewController.buttonColor = [UIColor colorWithRed:255.0f/255.0f green:112.0f/255.0f blue:43.0f/255.0f alpha:1.0f];
    alertViewController.view.tintColor = [UIColor whiteColor];
    alertViewController.alertViewCornerRadius = 2.0f;
    
    alertViewController.titleFont = [UIFont fontAvenirWithSize:14.0f];
    alertViewController.messageFont = [UIFont fontAvenirWithSize:12.0f];
    alertViewController.buttonTitleFont = [UIFont fontAvenirWithSize:14.0f];
    alertViewController.cancelButtonTitleFont = [UIFont fontAvenirWithSize:14.0f];
    
    //Add textField
    if (shouldAddTextField) {
        if ([UIScreen mainScreen].bounds.size.height == 480) {
            ((NYAlertView *)alertViewController.view).backgroundViewVerticalCenteringConstraint.constant = -90.0f;
        } else if ([UIScreen mainScreen].bounds.size.height == 568) {
            ((NYAlertView *)alertViewController.view).backgroundViewVerticalCenteringConstraint.constant = -50.0f;
        }
        
        [alertViewController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            if ([strMessage isEqualToString:@"Add your tip amount"]) {
                textField.keyboardType = UIKeyboardTypeDecimalPad;
                textField.keyboardAppearance = UIKeyboardAppearanceDark;
                if (strTextFieldText.length > 0) {
                    textField.text = strTextFieldText;
                }
                [textField becomeFirstResponder];
            }
            textField.placeholder = strMessage;
        }];
    }
    
    alertViewController.swipeDismissalGestureEnabled = NO;
    alertViewController.backgroundTapDismissalGestureEnabled = NO;
    
    
    // Present the alert view controller
    [presentingController presentViewController:alertViewController
                                       animated:YES
                                     completion:nil];
}

- (void)showErrorAlertForViewController:(UIViewController *)presentingController
                            withMessage:(NSString *)strMessage {
    
    if (!presentingController) {
        if ([self sharedAppDelegate].window.rootViewController.presentedViewController) {
            presentingController = [self sharedAppDelegate].window.rootViewController.presentedViewController;
        } else if ([self sharedAppDelegate].window.rootViewController.navigationController.viewControllers) {
            presentingController = [self sharedAppDelegate].window.rootViewController.navigationController.topViewController;
        } else {
            presentingController = [self sharedAppDelegate].window.rootViewController;
        }
    }
    
    [self showAlertWithController:presentingController
                         andTitle:nil
                       andMessage:strMessage
           andArrayOfTotalActions:nil
                    andCompletion:nil
               withInputTextField:NO
                 andTextFieldText:nil];
}

- (AppDelegate *)sharedAppDelegate {
    if (!appDelegate) {
        appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    }
    return appDelegate;
}

- (void)showReportAlertForViewController:(UIViewController *)presentingController
                                andTitle:(NSString *)strTitle
                              andMessage:(NSString *)strMessage
                  andArrayOfTotalActions:(NSArray *)arrTotalActions
                           andCompletion:(BlockCompletionTxtView)completionBlock
                      withInputTextField:(BOOL)shouldAddTextField
                        andTextFieldText:(NSString *)strTextFieldText {
    if (strTitle == nil) {
        strTitle = @"";
    }
    
    if (strMessage == nil) {
        strMessage = @"";
    }
    
    if (arrTotalActions == nil) {
        arrTotalActions = @[@"OK"];
    }
    
    NYAlertViewController *alertViewController = [[NYAlertViewController alloc] initWithNibName:nil bundle:nil];
    
    // Set a title and message
    alertViewController.title = NSLocalizedString(strTitle, nil);
    NSString *strForMessage = [NSString stringWithFormat:@"\n%@\n",strMessage];
    alertViewController.message = NSLocalizedString(strForMessage, nil);
    
    // Customize appearance as desired
    alertViewController.buttonCornerRadius = 2.0f;
    alertViewController.buttonColor = [UIColor colorWithRed:255.0f/255.0f green:112.0f/255.0f blue:43.0f/255.0f alpha:1.0f];
    alertViewController.view.tintColor = [UIColor whiteColor];
    alertViewController.alertViewCornerRadius = 2.0f;
    
    alertViewController.titleFont = [UIFont fontAvenirWithSize:14.0f];
    alertViewController.messageFont = [UIFont fontAvenirWithSize:12.0f];
    alertViewController.buttonTitleFont = [UIFont fontAvenirWithSize:14.0f];
    alertViewController.cancelButtonTitleFont = [UIFont fontAvenirWithSize:14.0f];
    
    
    if ([UIScreen mainScreen].bounds.size.height == 480) {
        ((NYAlertView *)alertViewController.view).backgroundViewVerticalCenteringConstraint.constant = -110.0f;
    } else if ([UIScreen mainScreen].bounds.size.height == 568) {
        ((NYAlertView *)alertViewController.view).backgroundViewVerticalCenteringConstraint.constant = -70.0f;
    }
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectZero];
    UITextView *txtView = [[UITextView alloc] initWithFrame:CGRectZero];
    txtView.font = [UIFont fontAvenirWithSize:12.0f];
    txtView.text = STRING_REPORT;
    txtView.returnKeyType = UIReturnKeyDone;
    txtView.delegate = self;
    [txtView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [contentView addSubview:txtView];
    
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[txtView(70)]|"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:NSDictionaryOfVariableBindings(txtView)]];
    
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[txtView]-|"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:NSDictionaryOfVariableBindings(txtView)]];
    alertViewController.alertViewContentView = contentView;
    
    
    //Add textField
    if (shouldAddTextField) {
        if ([UIScreen mainScreen].bounds.size.height == 480) {
            ((NYAlertView *)alertViewController.view).backgroundViewVerticalCenteringConstraint.constant = -90.0f;
        } else if ([UIScreen mainScreen].bounds.size.height == 568) {
            ((NYAlertView *)alertViewController.view).backgroundViewVerticalCenteringConstraint.constant = -50.0f;
        }
        
        [alertViewController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            if ([strMessage isEqualToString:@"Add your tip amount"]) {
                textField.keyboardType = UIKeyboardTypeDecimalPad;
                textField.keyboardAppearance = UIKeyboardAppearanceDark;
                if (strTextFieldText.length > 0) {
                    textField.text = strTextFieldText;
                }
                [textField becomeFirstResponder];
            }
            textField.placeholder = strMessage;
        }];
    }
    
    alertViewController.swipeDismissalGestureEnabled = NO;
    alertViewController.backgroundTapDismissalGestureEnabled = NO;
    
    for (NSString *strActions in arrTotalActions) {
        // Add alert actions
        [alertViewController addAction:[NYAlertAction actionWithTitle:NSLocalizedString(strActions, nil)
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(NYAlertAction *action) {
                                                                  [txtView resignFirstResponder];
                                                                  txtView.delegate = nil;
                                                                  
                                                                  if (completionBlock) {
                                                                      if (shouldAddTextField) {
                                                                          self.arrTextFields = [alertViewController textFields];
                                                                      }
                                                                      completionBlock(action.title,[self isValidTexts:txtView],txtView.text);
                                                                  } else {
                                                                      [presentingController dismissViewControllerAnimated:YES
                                                                                                               completion:^{}];
                                                                  }
                                                              }]];
    }
    
    
    // Present the alert view controller
    [presentingController presentViewController:alertViewController
                                       animated:YES
                                     completion:nil];
}

#pragma mark - Other Methods
- (BOOL)isValidTexts:(UITextView *)txtView {
    BOOL isValid = YES;
    
    if ([txtView.text isEqualToString:STRING_REPORT]) {
        return !isValid;
    } else {
        NSString *strTextView = [txtView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        txtView.text = strTextView;
        
        if (txtView.text.length == 0) {
            return !isValid;
        }
    }
    
    return isValid;
}

#pragma mark - UITextView Delegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:STRING_REPORT]) {
        textView.text = @"";
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    NSString *strTextView = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    textView.text = strTextView;
    
    if (textView.text.length == 0) {
        textView.text = STRING_REPORT;
    }
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
