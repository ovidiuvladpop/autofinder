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
@property (nullable, nonatomic) UIImage *photo;
@property (nullable, nonatomic) NSNumber *latitude;
@property (nullable, nonatomic) NSNumber *longitude;
@property (nullable, nonatomic) NSData *date;
@end

