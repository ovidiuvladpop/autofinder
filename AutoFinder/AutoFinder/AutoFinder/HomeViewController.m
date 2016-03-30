//
//  HomeViewController.m
//  AutoFinder
//
//  Created by user117310 on 3/20/16.
//  Copyright © 2016 Basic. All rights reserved.
//

#import "HomeViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface HomeViewController() {
    __weak IBOutlet UIButton *findDriverButton;
    __weak IBOutlet UIButton *findParkingButton;
    __weak IBOutlet UIButton *improveMapButton;
}

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeRoundButtons:findDriverButton];
    [self makeRoundButtons:findParkingButton];
    [self makeRoundButtons:improveMapButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

- (IBAction)findDriverButonPressed:(id)sender {
    
}

- (IBAction)findParkingButtonPresse:(id)sender {
    
}

- (IBAction)improveMapButtonPressed:(id)sender {
    
}

- (void)makeRoundButtons:(UIButton *)button {
    button.layer.cornerRadius = 10;
    button.clipsToBounds = YES;
}

@end
