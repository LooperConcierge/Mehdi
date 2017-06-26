//
//  ExpertiseModel.h
//  Looper
//
//  Created by hardik on 5/5/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ExpertiseModel : JSONModel

@property (assign, nonatomic) int iExpertiseID;
@property (assign, nonatomic) NSString<Optional> * vName;
@property (assign, nonatomic) NSString<Optional> * image;
@end
