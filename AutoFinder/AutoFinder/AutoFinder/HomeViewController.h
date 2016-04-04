//
//  HomeViewController.h
//  AutoFinder
//
//  Created by user117310 on 3/20/16.
//  Copyright © 2016 Basic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <SKMaps/SKMaps.h>

@interface HomeViewController : UIViewController <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation* currentLocation;

-(IBAction)findDriverButonPressed:(id)sender;
-(IBAction)findParkingButtonPresse:(id)sender;
-(IBAction)improveMapButtonPressed:(id)sender;

@end
