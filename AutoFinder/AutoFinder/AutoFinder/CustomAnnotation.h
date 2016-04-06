//
//  CustomAnnotation.h
//  AutoFinder
//
//  Created by user on 4/6/16.
//  Copyright © 2016 Basic. All rights reserved.
//

#import <SKMaps/SKMaps.h>

@interface CustomAnnotation : SKAnnotation

@property (nonnull, nonatomic, strong) UIImage *imageIncident;
@property (nonnull, nonatomic, strong) NSDate *incidentDate;

@end
