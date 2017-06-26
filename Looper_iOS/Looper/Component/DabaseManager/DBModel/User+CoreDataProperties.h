//
//  User+CoreDataProperties.h
//  FirebaseManager
//
//  Created by hardik on 2/13/16.
//  Copyright © 2016 looper. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *uName;
@property (nullable, nonatomic, retain) NSString *uEmail;
@property (nullable, nonatomic, retain) NSString *uID;
@property (nullable, nonatomic, retain) NSString *emailHash;
@property (nullable, nonatomic, retain) NSString *profilePic;

@end

NS_ASSUME_NONNULL_END
