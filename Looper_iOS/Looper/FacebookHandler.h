//
//  FacebookHandler.h
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^FBLoginCompletion) (NSError *error, id response);

@interface FacebookHandler : NSObject

+ (void)loginFromViewController: (UIViewController *)viewController completion: (FBLoginCompletion)completion;

+ (void)logout;

@end
