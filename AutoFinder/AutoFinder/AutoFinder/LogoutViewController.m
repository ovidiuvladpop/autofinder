//
//  LogoutViewController.m
//  AutoFinder
//
//  Created by webteam on 28/03/16.
//  Copyright © 2016 Basic. All rights reserved.
//

#import "LogoutViewController.h"
#import "HomeViewController.h"

@interface LogoutViewController () <UIAlertViewDelegate>

@end

@implementation LogoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Actions

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[[self navigationController] navigationBar] setHidden:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure you want to logout ?" message:nil delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    
    [alert show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  
    if (buttonIndex == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

@end
