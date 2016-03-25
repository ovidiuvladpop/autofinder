//
//  User.h
//  AutoFinder
//
//  Created by webteam on 24/03/16.
//  Copyright © 2016 Basic. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface User : NSObject

@property (nullable, nonatomic) NSString *username;
@property (nullable, nonatomic) NSString *password;
@property (nullable, nonatomic) NSString *email;
@property (nullable, nonatomic) NSString *phone;
@property (nullable, nonatomic) NSString *car;
@property (nullable, nonatomic) NSNumber *attempts;

@end


