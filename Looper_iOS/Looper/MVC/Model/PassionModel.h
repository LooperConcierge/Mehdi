//
//  PassionModel.h
//  Looper
//
//  Created by rakesh on 1/19/17.
//  Copyright © 2017 rakesh. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface PassionModel : JSONModel

@property (strong, nonatomic) NSString <Optional> *iExpertiseID;
@property (strong, nonatomic) NSString <Optional> *vName;
@property (strong, nonatomic) NSString <Optional> *isSelected;
@property (strong, nonatomic) NSString <Optional> *image;
@property (strong, nonatomic) NSArray <Optional> *passionModel;

@end
