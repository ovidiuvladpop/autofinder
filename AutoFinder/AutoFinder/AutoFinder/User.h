//
//  User.h
//  AutoFinder
//
//  Created by webteam on 24/03/16.
//  Copyright © 2016 Basic. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface User : NSObject

@property (nullable, nonatomic, retain) NSString *username;
@property (nullable, nonatomic, retain) NSString *password;
@property (nullable, nonatomic, retain) NSString *email;
@property (nullable, nonatomic, retain) NSString *phone;
@property (nullable, nonatomic, retain) NSString *car;
@property (nullable, nonatomic, retain) NSNumber *attempts;

@end


