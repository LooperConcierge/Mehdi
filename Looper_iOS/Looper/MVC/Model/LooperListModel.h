//
//  LooperListModel.h
//  Looper
//
//  Created by hardik on 5/6/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "ExpertiseModel.h"
#import "LanguageModel.h"


@interface LooperObjModel : JSONModel
@property (assign, nonatomic) id <Optional> iTripID;
@property (assign, nonatomic) int iUserID;
@property (strong, nonatomic) NSString* vFullName;
@property (strong, nonatomic) NSString * vCity;
@property (strong, nonatomic) NSString * vEmail;
@property (strong, nonatomic) NSString * vAbout;
@property (assign, nonatomic) float iRates;
@property (strong, nonatomic) NSString * vProfilePic;
@property (assign, nonatomic) id<Optional> iRating;
@property (assign, nonatomic) id<Optional> iCityID;
@property (strong, nonatomic) NSArray <ExpertiseModel *> * expertises;
@property (strong, nonatomic) NSArray <LanguageModel *> * languages;
@property (strong, nonatomic) NSString * vMotto;
@end
