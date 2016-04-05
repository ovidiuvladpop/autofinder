//
//  CarIncidentsViewController.m
//  AutoFinder
//
//  Created by webteam on 05/04/16.
//  Copyright © 2016 Basic. All rights reserved.
//

#import "CarIncidentsViewController.h"
#import <SKMaps/SKMaps.h>
#import <SKMaps/SKAnimationSettings.h>
#import <SKMaps/SKAnnotation.h>
#import <SKMaps/SKAnnotationView.h>
#import "AppDelegate.h"

@interface CarIncidentsViewController() <SKMapViewDelegate, SKCalloutViewDelegate> {
    NSManagedObjectContext *context;
    
}

@property (nonatomic, strong) IBOutlet SKMapView *mapView;
@property (nonatomic, assign) int count;

@end

@implementation CarIncidentsViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.count = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    context = [appDelegate managedObjectContext];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self.locationManager startUpdatingLocation];
    self.mapView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:NO];
    self.title = @"Car incidents";
}

- (void)viewDidAppear:(BOOL)animated {
    [self.mapView animateToZoomLevel:14];
    [self.mapView centerOnCurrentPosition];
    [self addIncidentToMap];
}

#pragma mark - Actions

- (void)showAnnotation:(CLLocation *)incidentLocation {
    SKAnnotation *annotation =[SKAnnotation annotation] ;
    annotation.location = incidentLocation.coordinate;
    annotation.annotationType = 32;
    annotation.identifier = self.count;
    self.count++;
    
    SKAnimationSettings *animationSettings = [SKAnimationSettings animationSettings];
    animationSettings.animationType = 3;
    
    [self.mapView addAnnotation:annotation withAnimationSettings:animationSettings];
    NSLog(@"Map view annotations: %lu", [self.mapView.annotations count]);
}

- (void)mapView:(SKMapView *)mapView didSelectAnnotation:(SKAnnotation *)annotation {
    self.mapView.calloutView.titleLabel.text = @"Incident";
    self.mapView.calloutView.subtitleLabel.text = @"Subtitle";
    
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
//    NSLog(@"lat  %f",self.currentLocation.coordinate.latitude);
//    NSLog(@"long  %f",self.currentLocation.coordinate.longitude);
//    
//    UIImage *image1 = [UIImage imageNamed:@"camera.png"];
//    
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:image1];
//    SKAnnotationView *view = [[SKAnnotationView alloc] initWithView:imageView reuseIdentifier:@"id"];
}


-(void)addIncidentToMap{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Photo" inManagedObjectContext:context]];
    
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    
    NSManagedObject* obj = [results objectAtIndex:0];
    
    CLLocationCoordinate2D coord;
    coord.latitude = (CLLocationDegrees)[[obj valueForKey:@"latitude"] doubleValue];
    coord.longitude = (CLLocationDegrees)[[obj valueForKey:@"longitude"] doubleValue];
    
    CLLocation *incidentLocation = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
    
    [self showAnnotation:incidentLocation];
    
    CLLocationCoordinate2D coord2 = CLLocationCoordinate2DMake(50.0, 28.0);
    CLLocation *anotherLocation = [[CLLocation alloc] initWithLatitude:coord2.latitude longitude:coord2.longitude];
    [self showAnnotation:anotherLocation];
}


@end
