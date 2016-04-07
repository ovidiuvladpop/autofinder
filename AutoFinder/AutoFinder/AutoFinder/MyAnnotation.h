//
//  MyAnnotation.h
//  AutoFinder
//
//  Created by webteam on 04/04/16.
//  Copyright © 2016 Basic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SKMaps/SKMaps.h>

@interface MyAnnotation : SKAnnotation <SKMapViewDelegate>

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord;

@end
