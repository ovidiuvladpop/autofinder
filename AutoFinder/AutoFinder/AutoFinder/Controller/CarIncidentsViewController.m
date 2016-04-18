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
#import <SKMaps/SKPositionerService.h>
#import "PersistenceController.h"

@interface CarIncidentsViewController() <SKMapViewDelegate, SKCalloutViewDelegate> {}

@property (nonatomic, strong) IBOutlet SKMapView *mapView;
@property (nonatomic, assign) int count;
@property (nonatomic, weak) NSManagedObjectContext *context;
@property (nonatomic, strong) SKAnnotation *customTappedAnnotation;
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

//Method used for adding annotations to map.
- (void)showAnnotation:(CLLocation *)incidentLocation {
    
    SKAnnotation *annotation = [SKAnnotation annotation];
    annotation.location = incidentLocation.coordinate;
    annotation.annotationType = 32;
    annotation.identifier = self.count;
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

- (void)mapView:(SKMapView *)mapView didSelectAnnotation:(SKAnnotation *)annotation {
    
    self.mapView.calloutView.titleLabel.text = @"Incident";
    self.mapView.calloutView.subtitleLabel.text = @"Tap right button for details";
    [self.mapView.calloutView.leftButton setImage:[UIImage imageNamed:@"leftButton.png"] forState:UIControlStateNormal];
    
    self.customTappedAnnotation = [SKAnnotation annotation];
    self.customTappedAnnotation.location = annotation.location;
    self.customTappedAnnotation.annotationType = annotation.annotationType;
    self.customTappedAnnotation.identifier = annotation.identifier;
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
        
        CLLocation *incidentLocation = [[CLLocation alloc] initWithLatitude:incidentCoordinate.latitude
                                                                  longitude:incidentCoordinate.longitude];
        [self showAnnotation:incidentLocation];
        
    }
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"carIncidentDetailSegue"]){
        
        CarIncidentDetailViewController *carIncidentDetailViewController = (CarIncidentDetailViewController *)segue.destinationViewController;
        
        carIncidentDetailViewController.location = self.customTappedAnnotation.location;
    }
}

@end
