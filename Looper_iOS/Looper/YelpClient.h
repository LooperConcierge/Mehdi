//
//  YelpClient.h
//  YelpDemo
//
//  Created by hardik on 4/14/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

typedef enum
{
    BestMatched = 0,
    Distance,
    HighestRated
    
}YelpSortMode;

//static NSString *yelpConsumerKey = @"Ms9ffVU8wsgzrvkkbjcebA";
//static NSString *yelpConsumerSecret = @"seHGVFHXzIR6sL_n8p8ayd4p6i8";
//static NSString *yelpToken  = @"XxHq21SOS0C-U9zuAhMTZ21JLPXdgUoJ";
//static NSString *yelpTokenSecret = @"FGadqdReeMM_IPmI9TOl9ZwCA34";

static NSString *yelpClientID = @"hX-6AhIGPNPTdbzjH5mwnQ";
static NSString *yelpClientSecret = @"8Bt3oSECV0rEHykF5CPGbeznPVdZDfhgzxmCrxwcHOhQcLeIl39e1PnMLmZ9VuDQ";

//static NSString *yelpBaseURL = @"https://api.yelp.com/v2/";
static NSString *yelpBaseURL = @"https://api.yelp.com/v3/";
static NSString *yelpAccessTokentURL = @"https://api.yelp.com/oauth2/token";

@interface YelpClient : NSObject

//@property YelpSortMode sortMode;

+ (instancetype)sharedInstance;
-(void)searchWithTerm:(NSString *)term sort:(YelpSortMode)sortmode
                deals:(BOOL)deal
             location:(NSString *)location
           startIndex:(int)startIndex
           categories:(NSArray *)categories
         successBlock:(void (^)(NSDictionary *response))successBlock
           errorBlock:(void (^)(NSError *error))errorBlock;

-(void)getAccessToken:(void (^)(BOOL success))successBlock;

-(void)searchBusinessWithID:(NSString *)businessID
         successBlock:(void (^)(NSDictionary *response))successBlock
           errorBlock:(void (^)(NSError *error))errorBlock;
@end
