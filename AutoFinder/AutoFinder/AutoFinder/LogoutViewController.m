//
//  LogoutViewController.m
//  AutoFinder
//
//  Created by webteam on 28/03/16.
//  Copyright © 2016 Basic. All rights reserved.
//

#import "LogoutViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <QuartzCore/QuartzCore.h>

@interface LogoutViewController () <UIAlertViewDelegate> {
    __weak IBOutlet UIButton *logoutButton;
}

@end

@implementation LogoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeRoundButtons:logoutButton];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - Actions

- (IBAction)logout:(id)sender {
    
    [[[self navigationController] navigationBar] setHidden:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure you want to logout ?" message:nil delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    
    [alert show];
}

- (void)makeRoundButtons:(UIButton *)button {
    button.layer.cornerRadius = 10;
    button.clipsToBounds = YES;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
