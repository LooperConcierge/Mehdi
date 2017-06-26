//
//  AlertController.h
//  TipQuik
//
//  Created by Bharat Nakum on 10/23/15.
//  Copyright © 2015 OpenXCell Technolabs Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIViewController.h>

typedef void(^BlockCompletion)(NSString *strActions);
typedef void(^BlockCompletionTxtView)(NSString *strActions,BOOL shouldReport,NSString *strTxtViewText);

@interface AlertController : NSObject

@property (nonatomic,readonly) NSArray *arrTextFields;

+ (AlertController *)sharedInstance;

- (void)showAlertWithController:(UIViewController *)presentingController
                       andTitle:(NSString *)strTitle
                     andMessage:(NSString *)strMessage
         andArrayOfTotalActions:(NSArray *)arrTotalActions
                  andCompletion:(BlockCompletion)completionBlock
             withInputTextField:(BOOL)shouldAddTextField
               andTextFieldText:(NSString *)strTextFieldText;

- (void)showErrorAlertForViewController:(UIViewController *)presentingController
                            withMessage:(NSString *)strMessage;

- (void)showReportAlertForViewController:(UIViewController *)presentingController
                                andTitle:(NSString *)strTitle
                              andMessage:(NSString *)strMessage
                  andArrayOfTotalActions:(NSArray *)arrTotalActions
                           andCompletion:(BlockCompletionTxtView)completionBlock
                      withInputTextField:(BOOL)shouldAddTextField
                        andTextFieldText:(NSString *)strTextFieldText;

@end
