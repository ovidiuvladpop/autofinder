//
//  AccountViewController.m
//  AutoFinder
//
//  Created by webteam on 25/03/16.
//  Copyright © 2016 Basic. All rights reserved.
//

#import "AccountViewController.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@interface AccountViewController(){
      NSManagedObjectContext *context;
    
    __weak IBOutlet UITextField *usernameField;
    __weak IBOutlet UITextField *emailField;
    __weak IBOutlet UITextField *phoneNumberField;
    __weak IBOutlet UITextField *carNumberField;
    __weak IBOutlet UITextField *attemptsField;
    __weak IBOutlet UIButton *save;
    
    __weak IBOutlet UIButton *buyAttemptsButton;
    __weak IBOutlet UIButton *editAccountButton;
    __weak IBOutlet UIButton *saveAccountButton;
}

@end

@implementation AccountViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    context = [appDelegate managedObjectContext];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    [self makeRoundButtons:buyAttemptsButton];
    [self makeRoundButtons:editAccountButton];
    [self makeRoundButtons:saveAccountButton];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [[[self navigationController] navigationBar] setHidden:YES];
    [save setHidden:YES];
    [self setUserProperties];
}

#pragma mark - Actions

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [usernameField resignFirstResponder];
    [emailField resignFirstResponder];
    [phoneNumberField resignFirstResponder];
    [carNumberField resignFirstResponder];
    return NO;
}

- (void)dismissKeyboard {
    [usernameField resignFirstResponder];
    [emailField resignFirstResponder];
    [phoneNumberField resignFirstResponder];
    [carNumberField resignFirstResponder];
}

- (void)makeRoundButtons:(UIButton *)button {
    button.layer.cornerRadius = 10;
    button.clipsToBounds = YES;
}

- (IBAction)editButton:(id)sender {
    [save setHidden:NO];
    
    [usernameField setEnabled:YES];
    [emailField setEnabled:YES];
    [phoneNumberField setEnabled:YES];
    [carNumberField setEnabled:YES];
    
}

- (IBAction)saveButton:(id)sender {
    
    [save setHidden:YES];
    
    [usernameField setEnabled:NO];
    [emailField setEnabled:NO];
    [phoneNumberField setEnabled:NO];
    [carNumberField setEnabled:NO];
    
    [self updateUser];
    [self updateDefaultUser];
}

- (IBAction)buyAttempts:(id)sender {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:context]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"email == %@", [defaults objectForKey:@"email"]];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    NSManagedObject* obj = [results objectAtIndex:0];
    NSNumber *numberOfAttempts = [NSNumber numberWithInt:([[obj valueForKey:@"attempts"] intValue] +3 )];
    
    [obj setValue:numberOfAttempts forKey:@"attempts"];
    [context save:&error];
    
    [self updateDefaultUser:numberOfAttempts];
    [self setUserProperties];
    
    
}
- (void)updateDefaultUser:(NSNumber *)numberOfAttempts {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:numberOfAttempts forKey:@"attempts"];
    [defaults synchronize];
}

- (void)updateDefaultUser {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:usernameField.text       forKey:@"username"];
    [defaults setObject:emailField.text          forKey:@"email"];
    [defaults setObject:phoneNumberField.text    forKey:@"phone"];
    [defaults setObject:carNumberField.text      forKey:@"car"];
    
    [defaults synchronize];
}

-(void)updateUser {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:context]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"email == %@", [defaults objectForKey:@"email"]];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    NSManagedObject* obj = [results objectAtIndex:0];
    [obj setValue: usernameField.text forKey:@"username"];
    [obj setValue:emailField.text forKey:@"email"];
    [obj setValue:phoneNumberField.text forKey:@"phone"];
    [obj setValue:carNumberField.text forKey:@"car"];
    [context save:&error];
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
