//
//  AccountViewController.m
//  AutoFinder
//
//  Created by webteam on 25/03/16.
//  Copyright © 2016 Basic. All rights reserved.
//

#import "AccountViewController.h"
#import "AppDelegate.h"

@interface AccountViewController(){
      NSManagedObjectContext *context;
    
    __weak IBOutlet UITextField *usernameField;
    __weak IBOutlet UITextField *passwordField;
    __weak IBOutlet UITextField *emailField;
    __weak IBOutlet UITextField *phoneField;
    __weak IBOutlet UITextField *carField;
    __weak IBOutlet UILabel *attemptsLabel;
    __weak IBOutlet UILabel *numberAttemptsLabel;
    
}

@end

@implementation AccountViewController

- (IBAction)buyAttepmts:(id)sender {
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    context = [appDelegate managedObjectContext];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [[[self navigationController] navigationBar] setHidden:NO];
    
}

-(void)completeFields{
    

    
    
}

@end
