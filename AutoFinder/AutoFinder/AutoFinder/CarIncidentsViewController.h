//
//  CarIncidentsViewController.h
//  AutoFinder
//
//  Created by webteam on 05/04/16.
//  Copyright © 2016 Basic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SKMaps/SKMaps.h>
#import <SKMaps/SKAnimationSettings.h>
#import <SKMaps/SKAnnotation.h>
#import <SKMaps/SKAnnotationView.h>

@interface CarIncidentsViewController : UIViewController
 <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation* currentLocation;

@end
