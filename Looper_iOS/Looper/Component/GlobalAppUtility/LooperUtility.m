//
//  LooperUtility.m
//  Looper
//
//  Created by hardik on 1/30/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "LooperUtility.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "ActionSheetDatePicker.h"
#import "Reachability.h"
#import "LoginVC.h"
#import "CustomTabbarLooper.h"
#import "CustomTabbar.h"
#import <Looper-Swift.h>

@implementation LooperUtility
@synthesize navBarColor,appThemeColor,locationManager,localization,isLooper,looperSignupDict,isNoTrip,arrCity,arrRecentChat,badgeView;

- (id) init {
    self = [super init];
    if (self != nil) {
        badgeView = [GIBadgeView new];
//        badgeView = [CustomBadge customBadgeWithString:@""];
        navBarColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
        appThemeColor = [UIColor colorWithRed:1 green:0.2980 blue:0.3490 alpha:1];
        locationManager = [[GPSLocationListner alloc] init];
        [locationManager changeLocationUpdationStatus:TRUE];
        localization = [[LocalizeHelper alloc] init];
        isNoTrip = FALSE;
        [self getCityActionHandler:^(BOOL status)
        {
            
        }];
    }
    return self;
}

-(void)getCityActionHandler:(void (^)(BOOL status))actionHandler
{
    [[ServiceHandler sharedInstance].webService processGetCity:nil successBlock:^(NSDictionary *response)
     {
         DebugLog(@"Response %@",response);
         
         if ([response isKindOfClass:[NSArray class]])
         {
             arrCity = [[NSArray alloc] initWithArray:(NSArray *)response];
             actionHandler(true);
         }
         
     } errorBlock:^(NSError *error)
     {
         DebugLog(@"error %@",error);
     }];
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+(void)setNavigationBarTransparent:(UINavigationController *)navigation
{
    [navigation.navigationBar setBackgroundImage:[UIImage new]
                                   forBarMetrics:UIBarMetricsDefault];
    navigation.navigationBar.shadowImage = [UIImage new];
    navigation.navigationBar.translucent = YES;
    navigation.view.backgroundColor = [UIColor clearColor];
    navigation.navigationBar.backgroundColor = [UIColor clearColor];
}

+(void)removeNavBarTransparency:(UINavigationController *)navigation
{
    [navigation.navigationBar setBackgroundImage:nil
                                   forBarMetrics:UIBarMetricsDefault];
    navigation.navigationBar.shadowImage = nil;
    navigation.navigationBar.translucent = YES;
    navigation.view.backgroundColor = [UIColor clearColor];
    navigation.navigationBar.backgroundColor = [UIColor clearColor];
}

+(UIButton *)createBackButton
{
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"btnBack"] forState:UIControlStateNormal];
    btnBack.frame = CGRectMake(0, 0, 20, 25);
    return btnBack;
}

+(UIButton *)createBackButtonWithTitle
{
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(0, 0, 100, 25);
    return btnBack;
}

+(UIButton *)createPushButton
{
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"notification"] forState:UIControlStateNormal];
    btnBack.frame = CGRectMake(0, 0, 20, 20);
    return btnBack;
}


+(UIButton *)createCloseButton
{
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    btnBack.frame = CGRectMake(0, 0, 25, 25);
    return btnBack;
    
}

+(NSDate *)dateFromString:(NSString *)strDate
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:dateFormate];
    NSDate *date = [df dateFromString:strDate];
    return date;
}

+(NSString *)dateFBFromString:(NSString *)strDate
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy"];
    NSDate *date = [df dateFromString:strDate];
    [df setDateFormat:dateFormate];
    NSString *stringDate = [df stringFromDate:date];
    return stringDate;
}


+(NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:dateFormate];
    NSString *date1 = [df stringFromDate:date];
    return date1;
}

+ (id)checkNullAndNill:(id)object
{
    if (object == nil)
        return @"";
    else if (object == [NSNull null])
        return @"";
    else
        return object;
}

/**
 *  This method is use for rounding the imageview
 *
 *  @param imageView  the object which is going to be rounded
 */

+(void)roundUIImageView:(UIImageView *)imageView
{
    imageView.layer.cornerRadius = MAX(imageView.frame.size.width, imageView.frame.size.height)/2;// imageView.frame.size.width/2;
    imageView.layer.masksToBounds = YES;
}

/**
 *  This method is use for rounding the UIView with transparent background color and border color
 *
 *  @param view the object which is going to be bordered
 */
+(void)roundUIViewWithTransparentBackground:(UIView *)view
{
    view.backgroundColor= [UIColor clearColor];
    view.layer.cornerRadius = MAX(view.frame.size.width, view.frame.size.height)/2;//view.frame.size.width/2;
    view.layer.borderWidth = 1;
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view.layer.masksToBounds = YES;
}

/**
 *  This method is use for taking screen shot of particular UIView object
 *
 *  @param view is object which is going to be captured
 *
 *  @return the image screen shot
 */
+ (UIImage *) screenshot:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}


/**
 *  This method is for taking screen shot of whole screen
 *
 *  @return the image screen shot
 */
+(UIImage *) screenshotOfWholeScreen
{
    // create graphics context with screen size
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    UIGraphicsBeginImageContext(screenRect.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor blackColor] set];
    CGContextFillRect(ctx, screenRect);
    
    // grab reference to our window
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    // transfer content into our context
    [window.layer renderInContext:ctx];
    UIImage *screengrab = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screengrab;
}

+(void)setNavigationBarTransparent:(UINavigationController *)navigation alpha:(float)alpha
{
    [navigation.navigationBar setBackgroundImage:[UIImage new]
                                   forBarMetrics:UIBarMetricsDefault];
    navigation.navigationBar.shadowImage = [UIImage new];
    navigation.navigationBar.translucent = YES;
    navigation.view.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:alpha];
    navigation.navigationBar.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:alpha];
}


+(BOOL) isValidEmail:(UITextField *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}
//for sending date to server conver app date to server date
+(NSString *)serverDateString:(NSString *)dateString
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [LooperUtility dateFromString:dateString];
    NSString *dateStr = [df stringFromDate:date];
    return dateStr;
}

//for setting server date to app date
+(NSString *)convertServerDateToAppString:(NSString *)dateString
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *date = [df dateFromString:dateString];
    NSString *dateStr = [LooperUtility stringFromDate:date];
    
    return dateStr;
}

+(NSString *)convertServerDateDesireAppString:(NSString *)dateString dateFormat:(NSString *)dateFormat1
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *date = [df dateFromString:dateString];
    
    [df setDateFormat:dateFormat1];
    NSString *date1 = [df stringFromDate:date];
    return date1;
}

+(NSString *)deviceToken
{
    NSString *deviceToken = (![AppdelegateObject.deviceToken isEqualToString:@""])?AppdelegateObject.deviceToken:@"SIMULATOR";
    return deviceToken;
}

+(BOOL) isTextFieldEmpty:(UITextField *)textField
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *checkString = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (checkString.length == 0)
    {
        stricterFilter = YES;
    }
    else
    {
        stricterFilter  = NO;
    }
    return stricterFilter;
}

+(void)isAlreadyLoginTraveler
{
    UIStoryboard *st = [UIStoryboard storyboardWithName:@"Traveler" bundle:nil];
    CustomTabbar *tab = [st instantiateViewControllerWithIdentifier:@"CustomTabbarID"];
    AppdelegateObject.window.rootViewController = tab;
    
}

+(void)isAlreadyLoginLooper:(BOOL)isFromSignup
{
  
    UIStoryboard *Lopper = [UIStoryboard storyboardWithName:@"Looper" bundle:nil];
    CustomTabbarLooper *tab = [Lopper instantiateViewControllerWithIdentifier:@"CustomTabbarLooperID"];
    tab.isFromSignup = isFromSignup;
//    if (isFromSignup)
//    {
//        [self openLoginSuccessAlert];
//    }
    AppdelegateObject.window.rootViewController = tab;
    
        if (isFromSignup)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self openLoginSuccessAlert];
            });
        }
}

+(void)openLoginScreen
{
    UIStoryboard *st = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *mainViewController = [st instantiateInitialViewController];
    AppdelegateObject.window.rootViewController = mainViewController;
}


+(void)createAlertWithTitle:(NSString *)title message:(NSString *)message style:(UIAlertControllerStyle)style controller:(UIViewController *)controller1 actionHandler:(void (^)(UIAlertAction *action))actionHandler
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        actionHandler(action);
        
    }];
    
    [controller addAction:cancelAction];
    
    [controller1 presentViewController:controller animated:YES completion:^{
        
    }];
    
}

+(void)createOkAndCancelAlertWithTitle:(NSString *)title message:(NSString *)message style:(UIAlertControllerStyle)style controller:(UIViewController *)controller1 actionHandler:(void (^)(UIAlertAction *action))actionHandler
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        actionHandler(action);
        
    }];
    
    [controller addAction:cancelAction];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        actionHandler(action);
    }];
    
    [controller addAction:okAction];
    
    [controller1 presentViewController:controller animated:YES completion:^{
        
    }];
    
}

+(void)createDontShowAndOKAlertWithTitle:(NSString *)title message:(NSString *)message style:(UIAlertControllerStyle)style controller:(UIViewController *)controller1 actionHandler:(void (^)(UIAlertAction *action))actionHandler
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Dont show it again" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        actionHandler(action);
        
    }];
    
    [controller addAction:cancelAction];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        actionHandler(action);
    }];
    
    [controller addAction:okAction];
    
    [controller1 presentViewController:controller animated:YES completion:^{
        
    }];
    
}

+(void)createActionsheetWithTitle:(NSString *)title message:(NSString *)message actions:(NSArray*)actions style:(UIAlertControllerStyle)style controller:(UIViewController *)controller actionHandler:(void(^)(UIAlertAction *action))actionHandler
{
    UIAlertController *controller1 = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    
    for (NSString *str in actions)
    {
        UIAlertAction *action = [UIAlertAction actionWithTitle:str style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            actionHandler(action);
            
        }];
        [controller1 addAction:action];
        
    }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        actionHandler(action);
        
    }];
    
    [controller1 addAction:cancelAction];
    
    [controller presentViewController:controller1 animated:YES completion:^{
        
    }];
}

+(UIImage *)createDottedLine:(CGRect)sizeRect
{
    
    UIBezierPath * path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(sizeRect.size.width/2 , 0)];
    [path addLineToPoint:CGPointMake(sizeRect.size.width/2, sizeRect.size.height)];
    
    [path strokeWithBlendMode:kCGBlendModeNormal alpha:1];
    [path setLineWidth:5.0];
    CGFloat dashes[] = { path.lineWidth * 0, path.lineWidth * 5 }; //For making the line circle dash (0,here spacing bewtween dash)
    [path setLineDash:dashes count:2 phase:0];
    [path setLineCapStyle:kCGLineCapRound];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(20, sizeRect.size.height), false, 2);
    [path fill];
    [[UIColor darkGrayColor] setFill];//need to set the color here to set the stroke
    [[UIColor darkGrayColor] setStroke];//need to set the color here to set the stroke
    [path stroke];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


- (void)showActionSheetDatePickerInView: (UIView *)view setMinDate:(NSDate *)minDate setMaxDate:(NSDate *)maxDate  selectedDate: (NSDate *)selectedDate doneBlock: (void(^)(NSDate *selectedDate))doneBlock {
    ActionSheetDatePicker *actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"Select date" datePickerMode:UIDatePickerModeDate selectedDate:selectedDate doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
        doneBlock((NSDate *)selectedDate);
    } cancelBlock:^(ActionSheetDatePicker *picker) {
        
    } origin:view];
    
    if (maxDate != nil)
    {
        [(ActionSheetDatePicker *) actionSheetPicker setMaximumDate:maxDate];
    }
    
    if (minDate != nil)
    {
        [(ActionSheetDatePicker *) actionSheetPicker setMinimumDate:minDate];
    }
    actionSheetPicker.hideCancel = NO;
    [actionSheetPicker showActionSheetPicker];
}

+(BOOL)isInternetAvailable
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        DebugLog(@"There IS NO internet connection");
        return NO;
    } else {
        DebugLog(@"There IS internet connection");
        return YES;
    }
}

+(void)navigateToLoginScreen:(UINavigationController *)nav
{
    UIStoryboard *st = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginVC *mainViewController = [st instantiateViewControllerWithIdentifier:@"LoginVC"];
    mainViewController.isNotLogin = TRUE;
    mainViewController.hidesBottomBarWhenPushed = YES;
    [nav pushViewController:mainViewController animated:YES];
}

+(UserModel *)getCurrentUser
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [userDefault objectForKey:@"keyUser"];
    UserModel *userobject = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return userobject;
}

+(void)settingCurrentUser:(UserModel *)user
{
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:user];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:@"keyUser"];
    [defaults synchronize];
}

+(LooperModel *)getLooperProfile
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [userDefault objectForKey:@"looperUserProfile"];
    LooperModel *userobject = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return userobject;
}

+(void)settingLooperProfile:(LooperModel *)user
{
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:user];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:@"looperUserProfile"];
    [defaults synchronize];
}

+(TravelerModel *)getTravelerProfile
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [userDefault objectForKey:@"travelerUserProfile"];
    TravelerModel *userobject = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return userobject;
}

+(void)settingTravelerProfile:(TravelerModel *)user
{
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:user];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:@"travelerUserProfile"];
    [defaults synchronize];
}

+(void)logoutCurrentUser
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"keyUser"];
    [defaults removeObjectForKey:@"apiKey"];
    [defaults removeObjectForKey:@"looperUserProfile"];
    [defaults removeObjectForKey:@"travelerUserProfile"];
    [defaults synchronize];
}

+(void)setApiKeyFromUserDefaults:(NSString *)apiKey
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:apiKey forKey:@"apiKey"];
    [defaults synchronize];
}

+(NSString *)getApiKeyUserDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *apiKey = [defaults objectForKey:@"apiKey"];
    return apiKey;
}

+(NSArray *)expertiseArray:(NSArray*)containsArray
{
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"ExpertiseList" ofType:@"plist"];
    NSDictionary * values=[[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSArray *arrayValues=[[NSArray alloc] initWithArray:[values valueForKey:@"arrItem"]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"expertiseID IN %@", [containsArray valueForKey:@"iExpertiseID"]];
    arrayValues = [arrayValues filteredArrayUsingPredicate:predicate];
    
    return arrayValues;
}

+(NSArray *)expertiseArrayFromArray:(NSArray*)containsArray
{
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"ExpertiseList" ofType:@"plist"];
    NSDictionary * values=[[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSArray *arrayValues=[[NSArray alloc] initWithArray:[values valueForKey:@"arrItem"]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"expertiseID IN %@", containsArray];
    arrayValues = [arrayValues filteredArrayUsingPredicate:predicate];
    
    return arrayValues;
}

+(NSDictionary *)checkCityAvailableInAppOrNot:(NSString *)cityName
{
    
    NSDictionary *returnDict;
    NSArray *component = [cityName componentsSeparatedByString:@","];
    NSString *cityName1 = [[component objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    for (NSDictionary *dict in [LooperUtility sharedInstance].arrCity)
    {
        NSString *string = dict[@"vName"];
        if ([string rangeOfString:cityName1].location == NSNotFound)
        {
            NSLog(@"string does not contain bla");
        } else {
            NSLog(@"string contains bla!");
            returnDict = dict;
            break;
        }
    }
    return returnDict;
}

+ (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+(void)openLoginSuccessAlert
{
    
    [LooperUtility createAlertWithTitle:@"SUCCESS" message:@"You have successfully signup, we will verify your application and activate your account soon." style:UIAlertControllerStyleAlert controller:AppdelegateObject.window.rootViewController actionHandler:^(UIAlertAction *action)
     {

     }];
}


-(void)getRecentChat
{
    UserModel *user = [LooperUtility getCurrentUser];
    NSString *userID = [NSString stringWithFormat:@"%d",user.iUserID];
    [[FirebaseChatManager sharedInstance] getRecentChatListForUserWithStrUserId:userID completionHandler:^(BOOL sucess, NSArray * response)
    {
        [LooperUtility sharedInstance].arrRecentChat = response;
        for (NSDictionary *chatDict in arrRecentChat)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHRECENTCHAT" object:nil];
            
            [[FirebaseChatManager sharedInstance] addObserverForUserWithStrUserId:chatDict[@"userid"] completionHandler:^(NSString *strValue, NSDictionary *dictionary)
            {
                NSDictionary *tempDict = dictionary;
                for (NSMutableDictionary *dict in arrRecentChat)
                {
                    if ([dict[@"userid"] intValue] == [tempDict[@"userid"] intValue])
                    {
                        [dict setValue:tempDict[@"isonline"] forKey:@"isonline"];
                        [dict setValue:tempDict[@"photo"] forKey:@"photo"];
                        [dict setValue:tempDict[@"lastseen"] forKey:@"lastseen"];
                        [dict setValue:tempDict[@"name"] forKey:@"name"];
//                        if(dict["isonline"] as! String == "") {
//                            dict.setValue("\(tempDict["members"]!)", forKey: "members")
//                        }
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHRECENTCHATPROFILE" object:dict];
                        break;
                    }
                }
            }];
        }
    }];
}

-(void)setbadgeViewCount
{
    badgeView.textColor = [UIColor whiteColor];
    badgeView.font = [UIFont fontAvenirLightWithSize:11];
    badgeView.backgroundColor = [UIColor redColor];
    [badgeView setBadgeValue:[UIApplication sharedApplication].applicationIconBadgeNumber];
//    [badgeView.badgeStyle setBadgeTextColor:[UIColor blackColor]];
//    [badgeView setBadgeText:[NSString stringWithFormat:@"%ld",(long)[UIApplication sharedApplication].applicationIconBadgeNumber]];
}


@end
