//
//  PersistenceController.h
//  AutoFinder
//
//  Created by admin on 16/04/16.
//  Copyright © 2016 Basic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SKMaps/SKPositionerService.h>
#import "AppDelegate.h"

@interface PersistenceController : NSObject

+ (id)sharedInstance;
- (BOOL)createAccountWithUsername:(NSString *)username password:(NSString *)password email:(NSString *)email phone:(NSString *)phone car:(NSString *)car;
- (BOOL)loginUser:(NSString*)username andPassword:(NSString*)password;
- (void)buyAttempts;
- (BOOL)updateUser:(NSString *)username email:(NSString *)email phone:(NSString *)phone andCar:(NSString *)car;
- (void)sendPhotoToDatabase:(UIImage *)image withCoordinates:(CLLocationCoordinate2D)coordinate;
- (NSArray *)getAllIncidents;
@end
