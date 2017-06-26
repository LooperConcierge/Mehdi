//
//  UserModel.h
//  Looper
//
//  Created by hardik on 4/23/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface UserModel : JSONModel

@property (strong, nonatomic) NSString *accesstoken;
@property (assign, nonatomic) BOOL eIsLooper;
@property (assign, nonatomic) int iUserID;
@property (strong, nonatomic) NSString *vEmail;
@property (strong, nonatomic) NSString <Optional> *vCode;
@property (strong, nonatomic) NSString *vPhone;
@property (strong, nonatomic) NSString *vFullName;
@property (strong, nonatomic) NSString *vProfilePic;

@end
