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
#import "CustomAnnotation.h"

@interface CarIncidentsViewController() <SKMapViewDelegate, SKCalloutViewDelegate> {
    
    NSManagedObjectContext *context;
    CustomAnnotation *customTappedAnnotation;
    
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

#pragma mark - UIViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    context = [appDelegate managedObjectContext];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    self.mapView.settings.showCompass=YES;
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

//Method used for getting the street name of incident location.
- (NSString *)streetName:(CLLocation *)incidentLocation {
    
    SKReverseGeocoderService *reverseGeocoderService = [SKReverseGeocoderService sharedInstance];
    SKSearchResult *searchResult = [reverseGeocoderService reverseGeocodeLocation:incidentLocation.coordinate];
    
    return searchResult.name;
    
}

//Method used for adding annotations to map.
- (void)showAnnotation:(CLLocation *)incidentLocation withObject:(NSManagedObject *)managedObject {
    
    CustomAnnotation *annotation = [CustomAnnotation annotation];
    annotation.location = incidentLocation.coordinate;
    annotation.annotationType = 32;
    annotation.identifier = self.count;
    NSData *data = [[NSData alloc] initWithData:[managedObject valueForKey:@"photo"]];
    UIImage *image = [UIImage imageWithData:data];
    annotation.imageIncident = image;
    annotation.incidentDate = [managedObject valueForKey:@"date"];
    annotation.streetName = [self streetName:incidentLocation];
    self.count++;
    
    UIImage *annotationImage = [UIImage imageNamed:@"incidentIcon.png"];
    UIImageView *annotationImageView = [[UIImageView alloc] initWithImage:annotationImage];
    SKAnnotationView *annotationView = [[SKAnnotationView alloc] initWithView:annotationImageView reuseIdentifier:@"id"];
    
    SKAnimationSettings *animationSettings = [SKAnimationSettings animationSettings];
    animationSettings.animationType = 3;
    annotation.annotationView = annotationView;
   
    [self.mapView addAnnotation:annotation withAnimationSettings:animationSettings];
    
}

#pragma mark - SKMapViewDelegate's methods

- (void)mapView:(SKMapView *)mapView didSelectAnnotation:(CustomAnnotation *)annotation {
    
    self.mapView.calloutView.titleLabel.text = @"Incident";
    [self.mapView.calloutView.leftButton setImage:[UIImage imageNamed:@"leftButton.png"] forState:UIControlStateNormal];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    
    NSString *stringFromDate = [formatter stringFromDate:annotation.incidentDate];
    self.mapView.calloutView.subtitleLabel.text = stringFromDate;
    
    customTappedAnnotation = [CustomAnnotation annotation];
    customTappedAnnotation.location = annotation.location;
    customTappedAnnotation.annotationType = annotation.annotationType;
    customTappedAnnotation.identifier = annotation.identifier;
    customTappedAnnotation.imageIncident = annotation.imageIncident;
    customTappedAnnotation.incidentDate = annotation.incidentDate;
    customTappedAnnotation.streetName=annotation.streetName;
    
    [self.mapView showCalloutForAnnotation:customTappedAnnotation withOffset:CGPointMake(0, 42) animated:YES];
}

- (void)mapView:(SKMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    
    if ((coordinate.latitude != self.currentLocation.coordinate.latitude) && (coordinate.longitude != self.currentLocation.coordinate.longitude)) {
        self.mapView.calloutView.hidden = YES;
    }
    
}

- (void)calloutView:(SKCalloutView *)calloutView didTapRightButton:(UIButton *)rightButton {
    
    [self performSegueWithIdentifier:@"carIncidentDetailSegue" sender:self];
    
}


-(void)addIncidentToMap {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Photo" inManagedObjectContext:context]];
    
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    NSManagedObject *object;
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
        
        carIncidentDetailViewController.streetName = customTappedAnnotation.streetName;
        carIncidentDetailViewController.imageIncident = customTappedAnnotation.imageIncident;
    }
    
}

#pragma mark - CLLocationManagerDelegate's methods

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    self.currentLocation = [locations lastObject];
    
}

@end
