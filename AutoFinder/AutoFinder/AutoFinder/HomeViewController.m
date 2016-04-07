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
#import <SKMaps/SKAnimationSettings.h>
#import <SKMaps/SKAnnotation.h>
#import <SKMaps/SKMapViewDelegate.h>

@interface HomeViewController() <SKMapViewDelegate, SKCalloutViewDelegate> {
    
    __weak IBOutlet UIButton *findDriverButton;
    __weak IBOutlet UIButton *carIncidentsButton;
    
}

@property (nonatomic, strong) IBOutlet SKMapView *mapView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self.locationManager startUpdatingLocation];
    self.mapView.settings.panningEnabled=NO;
    self.mapView.settings.rotationEnabled=NO;
    self.mapView.calloutView.rightButton.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self makeRoundButtons:findDriverButton];
    [self makeRoundButtons:carIncidentsButton];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.mapView animateToZoomLevel:14];
    [self.mapView centerOnCurrentPosition];
    [self showAnnotation];
}

#pragma mark - Actions

-(void)showAnnotation {
    
    SKAnnotation *annotation =[SKAnnotation annotation];
    annotation.location = self.currentLocation.coordinate;
    annotation.annotationType = 32;
    
    SKAnimationSettings *animationSettings = [SKAnimationSettings animationSettings];
    animationSettings.animationType = 2;
    
    [self.mapView addAnnotation:annotation withAnimationSettings:animationSettings];
}

-(void)mapView:(SKMapView *)mapView didSelectAnnotation:(SKAnnotation *)annotation {
    
    self.mapView.calloutView.titleLabel.text = @"You are here !";
    self.mapView.calloutView.subtitleLabel.text = @"Tap outside to hide me!";
    
    [self.mapView showCalloutForAnnotation:annotation withOffset:CGPointMake(0, 42) animated:YES];
}

- (void)mapView:(SKMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    if ((coordinate.latitude != self.currentLocation.coordinate.latitude) && (coordinate.longitude != self.currentLocation.coordinate.longitude)) {
        self.mapView.calloutView.hidden = YES;
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.currentLocation = [locations lastObject];
}

- (void)makeRoundButtons:(UIButton *)button {
    button.layer.cornerRadius = 10;
    button.clipsToBounds = YES;
}

@end
