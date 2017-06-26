//
//  LocalizeHelper.h
//

#import <Foundation/Foundation.h>

#define LocalizedString(key) [[LocalizeHelper sharedLocalizeHelper] localizedStringForKey:(key)]
//#define LocalizedString(key, comment) [[LocalizeHelper sharedLocalizeHelper] localizedStringForKey:(key)]

// "language" can be (for american english): "en", "en-US", "english". Analogous for other languages.
#define LocalizedLanguage(language) [[LocalizeHelper sharedLocalizeHelper] setLanguage:(language)]

@interface LocalizeHelper : NSObject

+ (LocalizeHelper *)sharedLocalizeHelper;

- (NSString *)localizedStringForKey: (NSString *)key;
- (void)setLanguage: (NSString *)language;

-(void)setDefaultLanguage;

-(NSString *)currentLanguage;
-(NSString *)displayNameForLanguage:(NSString *)language;
-(NSArray *)availableLanguages;
@end
