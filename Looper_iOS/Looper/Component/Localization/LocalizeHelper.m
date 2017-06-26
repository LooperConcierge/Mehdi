//
//  LocalizeHelper.m
//

#import "LocalizeHelper.h"

static LocalizeHelper *localizeHelperObj = nil;
// my Bundle (not the main bundle!)
static NSBundle* myBundle = nil;

//Current language key
static NSString * LCLCurrentLanguageKey = @"LCLCurrentLanguageKey";

/// Default language. English. If English is unavailable defaults to base localization.
static NSString * LCLDefaultLanguage = @"en";

#define LCLLanguageChangeNotification @"LCLLanguageChangeNotification"


@implementation LocalizeHelper

#pragma mark -
#pragma mark Singleton Methods
//-------------------------------------------------------------
// allways return the same singleton
//-------------------------------------------------------------
// Get the shared instance and create it if necessary.
+ (LocalizeHelper *)sharedLocalizeHelper {
    // lazy instantiation
    @synchronized(self) {
        if (localizeHelperObj == nil) {
            localizeHelperObj = [[LocalizeHelper alloc] init];
        }
    }
    return localizeHelperObj;
}

//-------------------------------------------------------------
// initiating
//-------------------------------------------------------------
- (id)init {
    if (self = [super init]) {
        // use systems main bundle as default bundle
        NSString *currentLang = [self currentLanguage];
        
        if (currentLang != nil)
        {
            NSString *path = [[NSBundle mainBundle] pathForResource:currentLang ofType:@"lproj"];
            myBundle = [NSBundle bundleWithPath:path];
        }
        else
        {

             myBundle = [NSBundle mainBundle];
        }
    }
    return self;
}

#pragma mark -
#pragma mark Get Localized String Methods
// you can use this macro: LocalizedString(@"Text");
- (NSString *)localizedStringForKey: (NSString *)key {
    return [myBundle localizedStringForKey:key value:@"" table:nil];
}

#pragma mark -
#pragma mark Set Language Methods
// you can use this macro: LocalizedLanguage(@"German") or LocalizedLanguage(@"de");
- (void)setLanguage: (NSString *)language {
    // path to this languages bundle
    NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj"];
    
    if (path == nil) {
        // there is no bundle for that language
        // use main bundle instead
        myBundle = [NSBundle mainBundle];
        [[NSUserDefaults standardUserDefaults] setObject:LCLDefaultLanguage forKey:LCLCurrentLanguageKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:LCLLanguageChangeNotification object:nil];
    } else {
        // use this bundle as my bundle from now on:
        myBundle = [NSBundle bundleWithPath:path];
        [[NSUserDefaults standardUserDefaults] setObject:language forKey:LCLCurrentLanguageKey];
        [[NSNotificationCenter defaultCenter] postNotificationName:LCLLanguageChangeNotification object:nil];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

-(void)setDefaultLanguage
{
    [self setLanguage:LCLDefaultLanguage];
}

-(NSString *)currentLanguage
{
    NSString *currentLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:LCLCurrentLanguageKey];
    if (currentLanguage != nil)
    {
        return currentLanguage;
    }
    else
    {
        return LCLDefaultLanguage;
    }
    
}
-(NSString *)displayNameForLanguage:(NSString *)language
{
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:[self currentLanguage]];
    NSString *str = [locale displayNameForKey:NSLocaleLanguageCode value:language];
    return str;
}

-(NSArray *)availableLanguages
{
    return [NSBundle mainBundle].localizations;
}

@end
