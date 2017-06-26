//
//  DataModel.m
//  LeftRightContententScrollview
//
//  Created by hardik on 2/18/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel
@synthesize arrContent,strHeaderTitle,displaLeftSide;

-(instancetype)init
{
    DataModel *model = [super init];
    
    arrContent = [[NSMutableArray alloc] init];
    
    return model;
}

@end
