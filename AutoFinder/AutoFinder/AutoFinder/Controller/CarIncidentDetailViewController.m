//
//  CarIncidentDetailViewController.m
//  AutoFinder
//
//  Created by user on 4/6/16.
//  Copyright © 2016 Basic. All rights reserved.
//

#import "CarIncidentDetailViewController.h"

@interface CarIncidentDetailViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *image;
@property (nonatomic, weak) IBOutlet UITextField *streetTextbox;
@property (nonatomic, weak) IBOutlet UITextField *incidentDateField;
    
@end


@implementation CarIncidentDetailViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    self.title = @"Details";
    
    self.streetTextbox.text = [self streetName:self.location];
    self.image.image = [[PersistenceController sharedInstance] incidentImage:self.location];
    self.incidentDateField.text = [[PersistenceController sharedInstance] incidentDate:self.location];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

//Method used for getting the street name of incident location.
- (NSString *)streetName:(CLLocationCoordinate2D)incidentLocationCoordinates {
    
    CLLocation *incidentLocation = [[CLLocation alloc] initWithLatitude:incidentLocationCoordinates.latitude
                                                              longitude:incidentLocationCoordinates.longitude];
    SKReverseGeocoderService *reverseGeocoderService = [SKReverseGeocoderService sharedInstance];
    SKSearchResult *searchResult = [reverseGeocoderService reverseGeocodeLocation:incidentLocation.coordinate];
    
    return searchResult.name;
    
}

@end
