//
//  NetworkHandler.h
//

//Default Key

#import <Foundation/Foundation.h>

@interface NetworkHandler : NSObject

- (void)GET:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(id responseObject))success
    failure:(void (^)(NSError *error))failure;

- (void)POST:(NSString *)URLString
  parameters:(id)parameters
     success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure;

- (void)PUT:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(id responseObject))success
    failure:(void (^)(NSError *error))failure;

- (void)DELETE:(NSString *)URLString
    parameters:(id)parameters
       success:(void (^)(id responseObject))success
       failure:(void (^)(NSError *error))failure;

- (void)POST:(NSString *)URLString
  parameters:(id)parameters
imageDictionary:(NSDictionary *)imageDict
     success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure;

- (void)POST:(NSString *)URLString
  parameters:(id)parameters
imageDictionary:(NSDictionary *)imageDict
    videoURL:(NSDictionary *)dictVideoURL
     success:(void (^)(id))success
     failure:(void (^)(NSError *))failure;


- (instancetype)initWithBaseUrl:(NSURL *)url;

@end
