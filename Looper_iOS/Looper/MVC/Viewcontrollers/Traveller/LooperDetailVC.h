//
//  LooperDetailVC.h
//  Looper
//
//  Created by hardik on 2/3/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "BaseNavVC.h"
#import "LooperListModel.h"

@interface LooperDetailVC : BaseNavVC


@property (nonatomic,strong)LooperObjModel *looperDetailObj;
//@property (nonatomic,strong)LooperAllListModel *looperDetailObjAll;
@property (nonatomic,strong)NSDictionary *bookParameter;
@property (nonatomic)BOOL isFromChat;

@end
