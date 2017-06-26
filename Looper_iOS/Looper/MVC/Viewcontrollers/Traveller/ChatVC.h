//
//  ChatVC.h
//  Looper
//
//  Created by hardik on 3/22/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "BaseNavVC.h"

#import <Looper-Swift.h>

@interface ChatVC : BaseNavVC

//@property(nonatomic,strong)NSDictionary * otherUser;
//@property(nonatomic,strong)NSString *messagePath;

@property(nonatomic,strong)MessageClass *messageObj;
@property double strlastTime;
@property(nonatomic)BOOL isFromMessageVC;

@end
