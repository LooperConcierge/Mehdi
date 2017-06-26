//
//  LooperModel.h
//  Looper
//
//  Created by hardik on 5/5/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "LanguageModel.h"
#import "ExpertiseModel.h"

@interface LooperModel : JSONModel

@property (strong, nonatomic) NSString <Optional> * dDob;

@property (strong, nonatomic) NSString *vEmail;
@property (strong, nonatomic) NSString *vPhone;
@property (strong, nonatomic) NSString *vFullName;
@property (strong, nonatomic) NSString *vProfilePic;

@property (strong, nonatomic) NSString *vCode;

@property (strong, nonatomic) NSString* vAbout;
@property (assign, nonatomic) float iRates;
@property (strong, nonatomic) NSString *vCity;
@property (strong, nonatomic) NSString *vState;

@property (strong, nonatomic) NSString *vMotto;

@property (strong, nonatomic) NSString* eAvailability;
@property (strong, nonatomic) NSString* vWNineForm;
@property (strong, nonatomic) NSString *vUSResProof;
@property (strong, nonatomic) NSString *vIDProof;
@property (strong, nonatomic) NSArray <LanguageModel *> * languages;
@property (strong, nonatomic) NSArray <ExpertiseModel *> * expertises;
@property (assign, nonatomic) float iRating;
//@property (strong, nonatomic) NSString *vSocialSecNo;
//@property (strong, nonatomic) NSString *vMotto;
@end
