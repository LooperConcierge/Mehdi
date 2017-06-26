//
//  Constant.h
//

#import "AppDelegate.h"

#define ALMOFIRE_ERRORKEY @"com.alamofire.serialization.response.error.data"
#define PLATFORM @"ios"

//LandingVC

#define keyLandingLogin             @"KEY_LOGIN"
#define keyLandingRegister                 @"KEY_REGISTER"
#define keyLandingExplore                  @"KEY_EXPLORE"

//LoginVC

#define keyLoginEmailAddress               @"KEY_EMAIL_ADDRESS"
#define keyLoginPassword                   @"KEY_PASSWORD"
#define keyLoginForgotPassword             @"KEY_FORGOT_PASSWORD"

//ForgotPasswordVC

#define keySubmit                           @"KEY_SUBMIT"

//SelectCityVC
#define keySelectCity                       @"KEY_SELECT_CITY"
#define keySelectLocation                   @"KEY_SEARCH_LOCATION"
#define keyContinue                         @"KEY_CONTINUE"

//SelectDateVC

#define keySelectDate                       @"KEY_SELECT_DATE"
#define keyArriveDate                       @"KEY_ARRIVE"
#define keyDepartDate                       @"KEY_DEPART"

//SelectInterestVC

#define keySelectInterest                   @"KEY_SELECT_INTEREST"
#define keyStartSearching                   @"KEY_START_SEARCHING"
#define keySelectAtlease                   @"KEY_SELECT_ATLEASET"
//LooperDetailVC
#define keyAboutMe                          @"KEY_ABOUTME"
#define keyLanguages                        @"KEY_LANGUAGES"
#define keyExpertise                        @"KEY_EXPERTISE"
#define keyInquire                          @"KEY_INQUIRE"
#define keyBook                             @"KEY_BOOK"
#define keyDaily                             @"KEY_DAILY"

#define keyHowBigParty                      @"KEY_HOW_BIG_PARTY"
#define keyCall                             @"KEY_CALL"
#define keyMessage                          @"KEY_MESSAGE"
#define keyViewTrip                         @"KEY_VIEW_TRIP"
#define keyDay                              @"KEY_DAY"
#define keyPartyof                          @"KEY_PARTY_OF"
#define keyConfirmed                        @"KEY_CONFIRMED"

//Looper.Storyboard

#define keyTraveler                       @"KEY_TRAVELER"
#define keyRequest                        @"KEY_REQUEST"
#define keyHistory                        @"KEY_HISTORY"


#pragma mark - messages

#define keyLoginFirst           @"Please register/login first"

#pragma mark
/*  Check Version Compatibility
 */
#define _OS_Version    [[[UIDevice currentDevice] systemVersion] floatValue]

//Date formate

//#define dateFormate @"MMMM,dd yyyy"
#define dateFormate @"MMMM dd, yyyy"

/*  Check Device Compatibility
 */
#define _IS_IPAD       ([[[UIDevice currentDevice] model] isEqualToString:@"iPad"])
#define _IS_IPHONE     ([[[UIDevice currentDevice] model] isEqualToString:@"iPhone"])
#define _IS_IPOD       ([[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"])

/*  Check iPhone Device
 */
#define _IS_IPHONE_4   [[UIScreen mainScreen] bounds].size.height >= 480.0f && [[UIScreen mainScreen] bounds].size.height < 568.0f
#define _IS_IPHONE_5   [[UIScreen mainScreen] bounds].size.height >= 568.0f && [[UIScreen mainScreen] bounds].size.height < 667.0f
#define _IS_IPHONE_6   [[UIScreen mainScreen] bounds].size.height >= 667.0f && [[UIScreen mainScreen] bounds].size.height < 736.0f
#define _IS_IPHONE_6P  [[UIScreen mainScreen] bounds].size.height >= 736.0f && [[UIScreen mainScreen] bounds].size.height < 1024.0f

/*  Get Screen Size
 */
#define _ScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define _ScreenHeight [[UIScreen mainScreen] bounds].size.height

/*  Get View Size
 */
#define _ViewWidth(view)  view.frame.size.width
#define _ViewHeight(view) view.frame.size.height

/*  Color
 */
/*  Color
 */
#define _Color_Green _RGBA(109,183,68,1)
#define _RGBA(R, G, B, A)  [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]



// Fonts
#define Font_Roboto_Bold(s)     [UIFont fontWithName:@"Roboto-Bold" size:s]
#define Font_Roboto_Medium(s)   [UIFont fontWithName:@"Roboto-Medium" size:s]
#define Font_Roboto_Regular(s)  [UIFont fontWithName:@"Roboto-Regular" size:s]




// NSUserDefaults Key
#define UserDefault_isUserLogin     @"isUserLogin"
#define UserDefault_LoginUserData   @"LoginUserData"




// Fonts
#define Font_Helvetica_Regular(s)     [UIFont fontWithName:@"Helvetica" size:s]


// NSDictionary Key
#define g_Dict_key_         @""

// NSNotificationCenter Key
#define g_Notification_                @""

// Other
#define g_StringFormate(fmt, args...)   [NSString stringWithFormat:fmt, ##args]
#define _AppDelegate                   ((AppDelegate *)[[UIApplication sharedApplication] delegate])

#ifdef DEBUG
#define DebugLog(s, ...) NSLog(s, ##__VA_ARGS__)
#else
#define DebugLog(s, ...)
#endif

/*
 pod 'Mantle', '~> 2.0.5'
 */
