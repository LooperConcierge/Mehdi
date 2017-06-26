//
//  TravelerModel.h
//  Looper
//
//  Created by hardik on 5/4/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "LanguageModel.h"

@interface TravelerModel : JSONModel

@property (strong, nonatomic) NSString <Optional> *  dDob;
@property (strong, nonatomic) NSString <Optional> * eGender;
@property (strong, nonatomic) NSString *vEmail;
@property (strong, nonatomic) NSString *vPhone;
@property (strong, nonatomic) NSString *vFullName;
@property (strong, nonatomic) NSString *vProfilePic;
@property (strong, nonatomic) NSArray <LanguageModel *> *languages;

@end
