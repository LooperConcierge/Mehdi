//
//  CommentListModel.h
//  Looper
//
//  Created by hardik on 5/30/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface CommunityListModel : JSONModel


@property (strong, nonatomic) NSString *vFullName;
@property (strong, nonatomic) NSString * vProfilePic;
@property (assign, nonatomic) int  iCommunityID;
@property (assign, nonatomic) int iLooperID;
@property (strong, nonatomic) NSString *vQuestion;
@property (strong, nonatomic) NSString *vCity;
@property (strong, nonatomic) NSString *vState;
@property (strong, nonatomic) NSString *dCreatedDate;
@property (strong, nonatomic) NSString *eStatus;
@property (strong, nonatomic) NSString *created_format_date;
@property (assign, nonatomic) NSString *iTotalComments;


@end
