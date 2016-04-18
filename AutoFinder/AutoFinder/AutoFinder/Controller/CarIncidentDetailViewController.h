//
//  CarIncidentDetailViewController.h
//  AutoFinder
//
//  Created by user on 4/6/16.
//  Copyright © 2016 Basic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SKMaps/SKAnnotation.h>
#import <SKMaps/SKMaps.h>
#import "PersistenceController.h"

@interface CarIncidentDetailViewController : UIViewController

@property (nonatomic, assign) CLLocationCoordinate2D location;

@end
