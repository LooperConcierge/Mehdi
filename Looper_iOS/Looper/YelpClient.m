//
//  YelpClient.m
//  YelpDemo
//
//  Created by hardik on 4/14/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "YelpClient.h"
#import "Constants.h"
#import "LoaderView.h"
#import "LoaderView.h"

@implementation YelpClient
{
    NSString *clientID;
    NSString *clientSecret;
    AFHTTPSessionManager *sessionManager;
}


+(instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] initWithClientID:yelpClientID clientSecret:yelpClientSecret];
    });
    return sharedInstance;

}

-(id)initWithClientID:(NSString *)clientID1 clientSecret:(NSString*)clientSecret1
{
    clientID = clientID1;
    clientSecret = clientSecret1;
    
    NSURL *baseURL = [NSURL URLWithString:yelpAccessTokentURL];
    
    [self getAccessToken:^(BOOL success) {
        
    }];
    
    return self;
}

-(void)getAccessToken:(void (^)(BOOL success))successBlock
{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    NSMutableDictionary *dictParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:clientID, @"client_id", clientSecret, @"client_secret", @"client_credentials", @"grant_type", nil];
    
    [manager POST:yelpAccessTokentURL parameters:dictParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [LoaderView hideLoader];
        NSLog(@"%@", responseObject);
        NSLog(@"success!");
        NSMutableDictionary *dictResponse = responseObject;
        [[NSUserDefaults standardUserDefaults] setObject:[dictResponse objectForKey:@"access_token"] forKey:@"yelpAccessToken"];
        [[NSUserDefaults standardUserDefaults] setObject:[dictResponse objectForKey:@"token_type"] forKey:@"yelpTokenType"];
        successBlock(true);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        NSLog(@"error: %@", error);
        successBlock(false);
        [LoaderView hideLoader];
    }];
    
}

-(void)searchWithTerm:(NSString *)term sort:(YelpSortMode)sortmode
                deals:(BOOL)deal
             location:(NSString *)location
           startIndex:(int)startIndex
           categories:(NSArray *)categories
         successBlock:(void (^)(NSDictionary *response))successBlock
        errorBlock:(void (^)(NSError *error))errorBlock
{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"yelpAccessToken"])
    {
        [self getAccessToken:^(BOOL success)
         {
             if (success)
             {
                 NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
                 
                 if (term != nil)
                 {
                     [parameters setObject:term forKey:@"term"];
                 }
                 //    [parameters setObject:@"37.785771,-122.406165" forKey:@"ll"];
                 //    [parameters setObject:@"37.785771,-122.406165" forKey:@"ll"];
                 [parameters setObject:[NSNumber numberWithInt:startIndex] forKey:@"offset"];
                 
                 //    [parameters setObject:@"San Francisco, CA" forKey:@"location"];
                 [parameters setObject:location forKey:@"location"];
                 
                 if (sortmode == BestMatched)
                 {
                     [parameters setObject:[NSNumber numberWithInt:BestMatched] forKey:@"sort"];
                 }
                 else if (sortmode == Distance)
                 {
                     [parameters setObject:[NSNumber numberWithInt:Distance] forKey:@"sort"];
                 }
                 else
                     [parameters setObject:[NSNumber numberWithInt:HighestRated] forKey:@"sort"];
                 
                 if (categories.count >0)
                 {
                     [parameters setObject:[categories componentsJoinedByString:@","] forKey:@"category_filter"];
                     //        [parameters setObject:@"nightlife" forKey:@"category_filter"];
                 }
                 [parameters setObject:[NSNumber numberWithBool:0] forKey:@"deals"];
                 
                 AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                 manager.requestSerializer = [AFHTTPRequestSerializer serializer];
                 [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                 [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@ %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"yelpTokenType"], [[NSUserDefaults standardUserDefaults] objectForKey:@"yelpAccessToken"]] forHTTPHeaderField:@"Authorization"];
                 
                 [manager GET:[NSString stringWithFormat:@"%@businesses/search",yelpBaseURL] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     NSLog(@"%@", responseObject);
                     //        NSLog(@"success!");
                     successBlock(responseObject);
                 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     NSError* error1;
                     NSDictionary* json = [NSJSONSerialization JSONObjectWithData:error.userInfo[ALMOFIRE_ERRORKEY]
                                                                          options:kNilOptions
                                                                            error:&error1];
                     
                     
                     DebugLog(@"loans: %@", json);
                     errorBlock(error);
                     
                 }];
             }
         }];
    }
    else
    {
    
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    if (term != nil)
    {
        [parameters setObject:term forKey:@"term"];
    }
//    [parameters setObject:@"37.785771,-122.406165" forKey:@"ll"];
//    [parameters setObject:@"37.785771,-122.406165" forKey:@"ll"];
    [parameters setObject:[NSNumber numberWithInt:startIndex] forKey:@"offset"];
    
//    [parameters setObject:@"San Francisco, CA" forKey:@"location"];
    [parameters setObject:location forKey:@"location"];
    
    if (sortmode == BestMatched)
    {
        [parameters setObject:[NSNumber numberWithInt:BestMatched] forKey:@"sort"];
    }
    else if (sortmode == Distance)
    {
        [parameters setObject:[NSNumber numberWithInt:Distance] forKey:@"sort"];
    }
    else
        [parameters setObject:[NSNumber numberWithInt:HighestRated] forKey:@"sort"];
    
    if (categories.count >0)
    {
        [parameters setObject:[categories componentsJoinedByString:@","] forKey:@"category_filter"];
//        [parameters setObject:@"nightlife" forKey:@"category_filter"];
    }
    [parameters setObject:[NSNumber numberWithBool:0] forKey:@"deals"];

    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@ %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"yelpTokenType"], [[NSUserDefaults standardUserDefaults] objectForKey:@"yelpAccessToken"]] forHTTPHeaderField:@"Authorization"];
    
    [manager GET:[NSString stringWithFormat:@"%@businesses/search",yelpBaseURL] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
//        NSLog(@"success!");
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSError* error1;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:error.userInfo[ALMOFIRE_ERRORKEY]
                                                             options:kNilOptions
                                                               error:&error1];
        
        
        DebugLog(@"loans: %@", json);
        errorBlock(error);

    }];
    }
    /*
    [self.networkManager GET:@"search" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSError* error1;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:error.userInfo[ALMOFIRE_ERRORKEY]
                                                             options:kNilOptions
                                                               error:&error1];
        
        
        DebugLog(@"loans: %@", json);
        errorBlock(error);
    }];
     */
}

-(void)searchBusinessWithID:(NSString *)businessID successBlock:(void (^)(NSDictionary *))successBlock errorBlock:(void (^)(NSError *))errorBlock
{
    
    [LoaderView showLoader];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@ %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"yelpTokenType"], [[NSUserDefaults standardUserDefaults] objectForKey:@"yelpAccessToken"]] forHTTPHeaderField:@"Authorization"];
    
    [manager GET:[NSString stringWithFormat:@"%@businesses/%@",yelpBaseURL,businessID] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        [LoaderView hideLoader];
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error: %@", error);
        [LoaderView hideLoader];
        errorBlock(error);
    }];

}

@end
