//
//  CarIncidentDetailViewController.m
//  AutoFinder
//
//  Created by user on 4/6/16.
//  Copyright © 2016 Basic. All rights reserved.
//

#import "CarIncidentDetailViewController.h"

@interface CarIncidentDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UITextField *streetTextbox;
    
@end


@implementation CarIncidentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setHidden:NO];
    self.title = @"Details";
    
    self.streetTextbox.text = self.streetName;
    self.image.image = self.imageIncident;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
