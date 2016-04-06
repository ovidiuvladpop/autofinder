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
#import "CarIncidentDetailViewController.h"

@interface CarIncidentsViewController() <SKMapViewDelegate, SKCalloutViewDelegate> {
    NSManagedObjectContext *context;
    NSManagedObject *object;
}

@property (nonatomic, strong) IBOutlet SKMapView *mapView;
@property (nonatomic, assign) int count;

@end

@implementation CarIncidentsViewController

#pragma mark - Init methods

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
    self.mapView.calloutView.delegate = self;
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

- (void)showAnnotation:(CLLocation *)incidentLocation withObject:(NSManagedObject * )object{
    
    SKAnnotation *annotation =[SKAnnotation annotation] ;
    annotation.location = incidentLocation.coordinate;
    annotation.annotationType = 32;
    annotation.identifier = self.count;
    self.count++;
    
    UIImage *annotationImage = [UIImage imageNamed:@"iconcar.png"];
    UIImageView *annotationImageView = [[UIImageView alloc] initWithImage:annotationImage];
    SKAnnotationView *annotationView = [[SKAnnotationView alloc] initWithView:annotationImageView reuseIdentifier:@"id"];
    
    SKAnimationSettings *animationSettings = [SKAnimationSettings animationSettings];
    animationSettings.animationType = 3;
    annotation.annotationView = annotationView;
   
    [self.mapView addAnnotation:annotation withAnimationSettings:animationSettings];
}

- (void)mapView:(SKMapView *)mapView didSelectAnnotation:(SKAnnotation *)annotation {
    self.mapView.calloutView.titleLabel.text = @"Incident";
    self.mapView.calloutView.subtitleLabel.text = @"subtitle";
    [self.mapView showCalloutForAnnotation:annotation withOffset:CGPointMake(0, 42) animated:YES];
}

- (void)mapView:(SKMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    if ((coordinate.latitude != self.currentLocation.coordinate.latitude) && (coordinate.longitude != self.currentLocation.coordinate.longitude)) {
        self.mapView.calloutView.hidden = YES;
    }
}

- (void)calloutView:(SKCalloutView *)calloutView didTapRightButton:(UIButton *)rightButton {
    [self performSegueWithIdentifier:@"carIncidentDetailSegue" sender:self];
}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.currentLocation = [locations lastObject];
}

-(void)addIncidentToMap {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Photo" inManagedObjectContext:context]];
    
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    for (object in results) {
        
        CLLocationCoordinate2D incidentCoordinate;
        incidentCoordinate.latitude = (CLLocationDegrees)[[object valueForKey:@"latitude"] doubleValue];
        incidentCoordinate.longitude = (CLLocationDegrees)[[object valueForKey:@"longitude"] doubleValue];
        
        CLLocation *incidentLocation = [[CLLocation alloc] initWithLatitude:incidentCoordinate.latitude longitude:incidentCoordinate.longitude];
        [self showAnnotation:incidentLocation withObject:object];
    }
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"carIncidentDetailSegue"]){
        
        CarIncidentDetailViewController *carIncidentDetailViewController = (CarIncidentDetailViewController *)segue.destinationViewController;
        carIncidentDetailViewController.incidentDate = [object valueForKey:@"date"];
        NSData *data = [[NSData alloc] initWithData:[object valueForKey:@"photo"]];
        UIImage *image = [UIImage imageWithData:data];
        carIncidentDetailViewController.imageIncident=image;
        
    }
}

@end
