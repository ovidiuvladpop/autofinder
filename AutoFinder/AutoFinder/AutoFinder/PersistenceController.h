//
//  PersistenceController.h
//  AutoFinder
//
//  Created by admin on 16/04/16.
//  Copyright © 2016 Basic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface PersistenceController : NSObject

+ (id)sharedInstance;
-(BOOL)createAccountWithUsername:(NSString *)username password:(NSString *)password email:(NSString *)email phone:(NSString *)phone car:(NSString *)car;
@end
