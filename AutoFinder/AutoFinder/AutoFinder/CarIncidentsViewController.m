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
#import <SKMaps/SKPositionerService.h>
#import "PersistenceController.h"

@interface CarIncidentsViewController() <SKMapViewDelegate, SKCalloutViewDelegate> {}

@property (nonatomic, strong) IBOutlet SKMapView *mapView;
@property (nonatomic, assign) int count;
@property (nonatomic, weak) NSManagedObjectContext *context;
@property (nonatomic, strong) CustomAnnotation *customTappedAnnotation;
@property (nonatomic, weak) SKPositionerService *positionerService;

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
    self.context = [appDelegate managedObjectContext];
    
    self.positionerService = [SKPositionerService sharedInstance];
    [self.positionerService startLocationUpdate];
    
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
    
    [super viewDidAppear:animated];
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
    
    self.customTappedAnnotation = [CustomAnnotation annotation];
    self.customTappedAnnotation.location = annotation.location;
    self.customTappedAnnotation.annotationType = annotation.annotationType;
    self.customTappedAnnotation.identifier = annotation.identifier;
    self.customTappedAnnotation.imageIncident = annotation.imageIncident;
    self.customTappedAnnotation.incidentDate = annotation.incidentDate;
    self.customTappedAnnotation.streetName=annotation.streetName;
    
    [self.mapView showCalloutForAnnotation:self.customTappedAnnotation withOffset:CGPointMake(0, 42) animated:YES];
}

- (void)mapView:(SKMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    
    if ((coordinate.latitude != self.positionerService.currentCoordinate.latitude) && (coordinate.longitude != self.positionerService.currentCoordinate.longitude)) {
        self.mapView.calloutView.hidden = YES;
    }
    
}

- (void)calloutView:(SKCalloutView *)calloutView didTapRightButton:(UIButton *)rightButton {
    
    [self performSegueWithIdentifier:@"carIncidentDetailSegue" sender:self];
    
}


-(void)addIncidentToMap {
    
    NSManagedObject *object;
    NSArray *results = [[PersistenceController sharedInstance] getAllIncidents];
    
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
        
        carIncidentDetailViewController.streetName = self.customTappedAnnotation.streetName;
        carIncidentDetailViewController.imageIncident = self.customTappedAnnotation.imageIncident;
    }
    
}

@end
