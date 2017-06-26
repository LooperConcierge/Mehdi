//
//  LooperAllListModel.h
//  Looper
//
//  Created by rakesh on 5/25/16.
//  Copyright © 2016 rakesh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExpertiseModel.h"
#import "LanguageModel.h"

@interface LooperAllListModel : JSONModel

//@property (assign, nonatomic) int iTripID;
@property (assign, nonatomic) int iUserID;
@property (strong, nonatomic) NSString* vFullName;
@property (strong, nonatomic) NSString * vCity;
@property (strong, nonatomic) NSString * vAbout;
@property (assign, nonatomic) float iRates;
@property (strong, nonatomic) NSString * vProfilePic;
//@property (assign, nonatomic) int iRating;
@property (strong, nonatomic) NSArray <ExpertiseModel *> * expertises;
@property (strong, nonatomic) NSArray <LanguageModel *> * languages;


@end
