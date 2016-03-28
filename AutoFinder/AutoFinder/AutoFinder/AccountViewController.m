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
    __weak IBOutlet UITextField *emailField;
    __weak IBOutlet UITextField *phoneNumberField;
    __weak IBOutlet UITextField *carNumberField;
    __weak IBOutlet UITextField *attemptsField;
}

@end

@implementation AccountViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    context = [appDelegate managedObjectContext];
    
    [self setUserProperties];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [[[self navigationController] navigationBar] setHidden:YES];
    
}

-(void)setUserProperties {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    usernameField.text     = [defaults objectForKey:@"username"];
    emailField.text        = [defaults objectForKey:@"email"];
    phoneNumberField.text  = [defaults objectForKey:@"phone"];
    carNumberField.text    = [defaults objectForKey:@"car"];
    attemptsField.text     = [[defaults objectForKey:@"attempts"] stringValue];
    
}

@end
