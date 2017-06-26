//
//  LooperUtility.h
//  Looper
//
//  Created by hardik on 1/30/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GPSLocationListner.h"
#import "LocalizeHelper.h"
#import "ServiceHandler.h"
#import "NSString+Hashes.h"
#import "UserModel.h"
#import "LooperModel.h"
#import "TravelerModel.h"
#import "FirebaseHelper.h"
#import "GIBadgeView.h"
//#import "CustomBadge.h"

//#define GOOGLE_MAP_KEY @"AIzaSyC1zGeCCJG1N64Maedzn7Bzd6mjRrd4tOY"
#define GOOGLE_MAP_KEY @"AIzaSyCvO2ccSYfz1tmDSuDgJ0IwBoXNOvFaeug"//LooperAccount
#define PAYPAL_URL_SCHEME @"com.Looper.payments"

@interface LooperUtility : NSObject

//@property (nonatomic, strong) CustomBadge *badgeView;
@property (nonatomic, strong) GIBadgeView *badgeView;
@property (strong,nonatomic) UIColor *navBarColor;
@property (strong,nonatomic) UIColor *appThemeColor;
@property (strong,nonatomic) LocalizeHelper *localization;
@property (strong,nonatomic) GPSLocationListner *locationManager;
@property (strong,nonatomic) NSMutableDictionary *looperSignupDict;
@property (strong,nonatomic) NSArray *arrCity;
@property (assign,nonatomic) BOOL isNoTrip; // varible is use when no trips on calendar and click on TRIP biutton to navigate to open city select screen.

@property (strong,nonatomic) NSArray *arrRecentChat;
@property BOOL isLooper;// is for checking wheather it is looper or traveler

+ (instancetype)sharedInstance;

+(void)setNavigationBarTransparent:(UINavigationController *)navigation;
+(void)setNavigationBarTransparent:(UINavigationController *)navigation alpha:(float)alpha;
+(void)removeNavBarTransparency:(UINavigationController *)navigation;

+(UIButton *)createBackButton;
+(UIButton *)createPushButton;
+(UIButton *)createCloseButton;
+(UIButton *)createBackButtonWithTitle;
+(UIImage *) screenshotOfWholeScreen;

+(NSDate *)dateFromString:(NSString *)strDate;

+(NSString *)stringFromDate:(NSDate *)date;

+(NSString *)dateFBFromString:(NSString *)strDate;

+ (id)checkNullAndNill:(id)object;

+(NSString *)deviceToken;

+(NSString *)serverDateString:(NSString *)dateString;

+(BOOL)isInternetAvailable;
/**
 *  This method is use for taking screen shot of particular UIView object
 *
 *  @param view is object which is going to be captured
 *
 *  @return the image screen shot
 */


+ (UIImage *) screenshot:(UIView *)view;

/**
 *  This method is use for rounding the imageview
 *
 *  @param imageView the object which is going to be rounded
 */

+(void )roundUIImageView:(UIImageView *)imageView;


/**
 *  This method is use for rounding the UIView with transparent background color and border color
 *
 *  @param view the object which is going to be bordered
 */

+(void)roundUIViewWithTransparentBackground:(UIView *)view;

/**
 *  This method is use for checking the email valid or not
 *
 *  @param checkString email to check
 *
 *  @return IF valie then yes else No
 */
+(BOOL) isValidEmail:(NSString *)checkString;


+(BOOL) isTextFieldEmpty:(UITextField *)textField;

/**
 *  This method open traveler screen if it is already login to app
 */
+(void)isAlreadyLoginTraveler;

/**
 *  This method open looper screen if it is already login to app
 */

+(void)isAlreadyLoginLooper:(BOOL)isFromSignup;

/**
 *  This method open login screen
 */

+(void)openLoginScreen;

/**
 *  This method is use for create alert view with title cancel and ok
 *
 *  @param title         Title of the alert
 *  @param message       is inside the text description
 *  @param style         style of alert
 *  @param controller1   name from where it called
 *  @param actionHandler action hadling mechanism for the controller
 */
+(void)createAlertWithTitle:(NSString *)title message:(NSString *)message style:(UIAlertControllerStyle)style controller:(UIViewController *)controller1 actionHandler:(void (^)(UIAlertAction *action))actionHandler;

+(void)createOkAndCancelAlertWithTitle:(NSString *)title message:(NSString *)message style:(UIAlertControllerStyle)style controller:(UIViewController *)controller1 actionHandler:(void (^)(UIAlertAction *action))actionHandler;


+(UIImage *)createDottedLine:(CGRect)sizeRect;

- (void)showActionSheetDatePickerInView: (UIView *)view setMinDate:(NSDate *)minDate setMaxDate:(NSDate *)maxDate  selectedDate: (NSDate *)selectedDate doneBlock: (void(^)(NSDate *selectedDate))doneBlock;

+(void)createActionsheetWithTitle:(NSString *)title message:(NSString *)message actions:(NSArray*)actions style:(UIAlertControllerStyle)style controller:(UIViewController *)controller actionHandler:(void(^)(UIAlertAction *action))actionHandler;

+(void)navigateToLoginScreen:(UINavigationController *)nav;

+(UserModel *)getCurrentUser;
+(void)settingCurrentUser:(UserModel *)user;
+(void)logoutCurrentUser;

+(void)setApiKeyFromUserDefaults:(NSString *)apiKey;

+(NSString *)getApiKeyUserDefaults;

+(NSString *)convertServerDateToAppString:(NSString *)dateString;

+(NSArray *)expertiseArray:(NSArray*)containsArray;

+(NSDictionary *)checkCityAvailableInAppOrNot:(NSString *)cityName;

+(NSArray *)expertiseArrayFromArray:(NSArray*)containsArray;

+(LooperModel *)getLooperProfile;

+(void)settingLooperProfile:(LooperModel *)user;

+(void)settingTravelerProfile:(TravelerModel *)user;

+(TravelerModel *)getTravelerProfile;

+ (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;

+(void)createDontShowAndOKAlertWithTitle:(NSString *)title message:(NSString *)message style:(UIAlertControllerStyle)style controller:(UIViewController *)controller1 actionHandler:(void (^)(UIAlertAction *action))actionHandler
;
-(void)getRecentChat;
+(NSString *)convertServerDateDesireAppString:(NSString *)dateString dateFormat:(NSString *)dateFormat1;
-(void)getCityActionHandler:(void (^)(BOOL status))actionHandler;
-(void)setbadgeViewCount;
@end
