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
#import <SKMaps/SKPositionerService.h>

@interface HomeViewController() <SKMapViewDelegate, SKCalloutViewDelegate> {}

@property (nonatomic, weak) IBOutlet UIButton *findDriverButton;
@property (nonatomic, weak) IBOutlet UIButton *carIncidentsButton;
@property (nonatomic, strong) IBOutlet SKMapView *mapView;
@property (nonatomic, weak) SKPositionerService *positionerService;


@end

@implementation HomeViewController

#pragma mark - Actions

//Method used for showing annotations on the map.
- (void)showAnnotation {
    
    SKAnnotation *annotation =[SKAnnotation annotation];
    annotation.location = self.positionerService.currentCoordinate;
    annotation.annotationType = 32;
    
    SKAnimationSettings *animationSettings = [SKAnimationSettings animationSettings];
    animationSettings.animationType = 2;
    
    [self.mapView addAnnotation:annotation
          withAnimationSettings:animationSettings];
    
}

//Method used for making round buttons.
- (void)makeRoundButtons:(UIButton *)button {
    
    button.layer.cornerRadius = 10;
    button.clipsToBounds = YES;
    
}

#pragma mark - SKMapViewDelegate's methods

//Called when an annotation was tapped on the map.
- (void)mapView:(SKMapView *)mapView didSelectAnnotation:(SKAnnotation *)annotation {
    
    self.mapView.calloutView.titleLabel.text = @"You are here !";
    self.mapView.calloutView.subtitleLabel.text = @"Tap outside to hide me!";
    [self.mapView.calloutView.leftButton setImage:[UIImage imageNamed:@"userPosition.png"]
                                         forState:UIControlStateNormal];
    
    [self.mapView showCalloutForAnnotation:annotation
                                withOffset:CGPointMake(0, 42)
                                  animated:YES];
    
}

//Called when the map is tapped.
- (void)mapView:(SKMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    
    if ((coordinate.latitude != self.positionerService.currentCoordinate.latitude) && (coordinate.longitude != self.positionerService.currentCoordinate.longitude)) {
        
        self.mapView.calloutView.hidden = YES;
        
    }
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    self.positionerService = [SKPositionerService sharedInstance];
    [self.positionerService startLocationUpdate];
    
    self.mapView.settings.panningEnabled = NO;
    self.mapView.settings.rotationEnabled = NO;
    self.mapView.calloutView.rightButton.hidden = YES;
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self makeRoundButtons:self.findDriverButton];
    [self makeRoundButtons:self.carIncidentsButton];
    [self.navigationController.navigationBar setHidden:YES];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self.mapView animateToZoomLevel:14];
    [self.mapView centerOnCurrentPosition];
    [self showAnnotation];
    
}

@end
