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
@property (weak, nonatomic) IBOutlet UITextField *dateTextBox;
    
@end


@implementation CarIncidentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setHidden:NO];
    self.title = @"Details";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    
    NSString *stringFromDate = [formatter stringFromDate:self.incidentDate];
    
    self.dateTextBox.text= stringFromDate;
    self.image.image= self.imageIncident;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
