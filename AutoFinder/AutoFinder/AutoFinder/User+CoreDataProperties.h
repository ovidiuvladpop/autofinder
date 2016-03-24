//
//  User+CoreDataProperties.h
//  AutoFinder
//
//  Created by webteam on 24/03/16.
//  Copyright © 2016 Basic. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *username;
@property (nullable, nonatomic, retain) NSString *password;
@property (nullable, nonatomic, retain) NSString *email;
@property (nullable, nonatomic, retain) NSString *phone;
@property (nullable, nonatomic, retain) NSString *car;
@property (nullable, nonatomic, retain) NSNumber *attempts;

@end

NS_ASSUME_NONNULL_END
