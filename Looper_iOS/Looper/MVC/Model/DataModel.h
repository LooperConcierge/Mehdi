//
//  DataModel.h
//  LeftRightContententScrollview
//
//  Created by hardik on 2/18/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject

@property(nonatomic,strong) NSString *strHeaderTitle;
@property(nonatomic,strong) NSMutableArray *arrContent;
@property (nonatomic, assign) BOOL displaLeftSide;


@end
