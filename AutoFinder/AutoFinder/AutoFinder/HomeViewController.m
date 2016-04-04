//
//  HomeViewController.m
//  AutoFinder
//
//  Created by user117310 on 3/20/16.
//  Copyright © 2016 Basic. All rights reserved.
//

#import "HomeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <SKMaps/SKMaps.h>


@interface HomeViewController() <SKMapViewDelegate> {
    
    __weak IBOutlet UIButton *findDriverButton;
    __weak IBOutlet UIButton *findParkingButton;
    __weak IBOutlet UIButton *improveMapButton;
    
}
@property (nonatomic, strong) IBOutlet SKMapView *mapView;



@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeRoundButtons:findDriverButton];
    [self makeRoundButtons:findParkingButton];
    [self makeRoundButtons:improveMapButton];
    
    self.mapView = [[SKMapView alloc] initWithFrame:CGRectMake( self.mapView.frame.origin.x, self.mapView.frame.origin.y, CGRectGetWidth(self.mapView.frame), CGRectGetHeight(self.mapView.frame) )];
    [self.view addSubview:self.mapView];
    self.mapView.delegate = self;
    [self.mapView animateToZoomLevel:14];
    [self.mapView centerOnCurrentPosition];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self.locationManager startUpdatingLocation];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

#pragma mark - Actions

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.currentLocation = [locations lastObject];
    // here we get the current location
}

- (IBAction)findDriverButonPressed:(id)sender {
    
}

- (IBAction)findParkingButtonPresse:(id)sender {
    
}

- (IBAction)improveMapButtonPressed:(id)sender {
    
}

- (void)makeRoundButtons:(UIButton *)button {
    button.layer.cornerRadius = 10;
    button.clipsToBounds = YES;
}

@end
