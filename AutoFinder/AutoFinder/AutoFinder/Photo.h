//
//  Photo.h
//  AutoFinder
//
//  Created by webteam on 05/04/16.
//  Copyright © 2016 Basic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface Photo : NSObject

@property (nonnull, nonatomic, strong) NSData *photo;
@property (nonnull, nonatomic) NSNumber *latitude;
@property (nonnull, nonatomic) NSNumber *longitude;
@property (nonnull, nonatomic) NSDate *date;

@end

