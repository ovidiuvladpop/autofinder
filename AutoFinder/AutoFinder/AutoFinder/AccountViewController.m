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

@interface AccountViewController() {}

@property (nonatomic, weak) IBOutlet UIButton *buyAttemptsButton;
@property (nonatomic, weak) IBOutlet UIButton *editAccountButton;
@property (nonatomic, weak) IBOutlet UIButton *saveAccountButton;

@property (nonatomic, weak) IBOutlet UITextField *usernameField;
@property (nonatomic, weak) IBOutlet UITextField *emailField;
@property (nonatomic, weak) IBOutlet UITextField *phoneNumberField;
@property (nonatomic, weak) IBOutlet UITextField *carNumberField;
@property (nonatomic, weak) IBOutlet UITextField *attemptsField;

@property (nonatomic, weak) NSManagedObjectContext *context;

@end

@implementation AccountViewController

#pragma mark - UIViewController

-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.context = [appDelegate managedObjectContext];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    [self makeRoundButtons:self.buyAttemptsButton];
    [self makeRoundButtons:self.editAccountButton];
    [self makeRoundButtons:self.saveAccountButton];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [[[self navigationController] navigationBar] setHidden:YES];
    [self.saveAccountButton setHidden:YES];
    [self setUserProperties];
    
}

#pragma mark - Actions

- (void)dismissKeyboard {
    [self.usernameField resignFirstResponder];
    [self.emailField resignFirstResponder];
    [self.phoneNumberField resignFirstResponder];
    [self.carNumberField resignFirstResponder];
}

- (void)makeRoundButtons:(UIButton *)button {
    button.layer.cornerRadius = 10;
    button.clipsToBounds = YES;
}

- (IBAction)editButton:(id)sender {
    [self.saveAccountButton setHidden:NO];
    
    [self.usernameField setEnabled:YES];
    [self.emailField setEnabled:YES];
    [self.phoneNumberField setEnabled:YES];
    [self.carNumberField setEnabled:YES];
    
}

- (BOOL)checkForEmptyField {
    if (([self.usernameField.text isEqualToString:@""]) ||
        ([self.emailField.text isEqualToString:@""]) ||
        ([self.phoneNumberField.text isEqualToString:@""]) ||
        ([self.carNumberField.text isEqualToString:@""])) {
        return YES;
    }
    return NO;
}

- (IBAction)saveButton:(id)sender {
    if ([self checkForEmptyField]) {
        
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Warning"
                                                       message:@"Please fill in all fields !"
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
        
    } else {
        [self.saveAccountButton setHidden:YES];
    
        [self.usernameField setEnabled:NO];
        [self.emailField setEnabled:NO];
        [self.phoneNumberField setEnabled:NO];
        [self.carNumberField setEnabled:NO];
    
        [self updateUser];
        [self updateDefaultUser];
    }
    
}

- (IBAction)buyAttempts:(id)sender {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:self.context]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"email == %@", [defaults objectForKey:@"email"]];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *results = [self.context executeFetchRequest:request error:&error];
    
    NSManagedObject* obj = [results objectAtIndex:0];
    NSNumber *numberOfAttempts = [NSNumber numberWithInt:([[obj valueForKey:@"attempts"] intValue] +3 )];
    
    [obj setValue:numberOfAttempts forKey:@"attempts"];
    [self.context save:&error];
    
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
    
    [defaults setObject:self.usernameField.text       forKey:@"username"];
    [defaults setObject:self.emailField.text          forKey:@"email"];
    [defaults setObject:self.phoneNumberField.text    forKey:@"phone"];
    [defaults setObject:self.carNumberField.text      forKey:@"car"];
    
    [defaults synchronize];
}

-(void)updateUser {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:self.context]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"email == %@", [defaults objectForKey:@"email"]];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *results = [self.context executeFetchRequest:request error:&error];
    
    NSManagedObject* obj = [results objectAtIndex:0];
    [obj setValue:self.usernameField.text forKey:@"username"];
    [obj setValue:self.emailField.text forKey:@"email"];
    [obj setValue:self.phoneNumberField.text forKey:@"phone"];
    [obj setValue:self.carNumberField.text forKey:@"car"];
    [self.context save:&error];
}

-(void)setUserProperties {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.usernameField.text     = [defaults objectForKey:@"username"];
    self.emailField.text        = [defaults objectForKey:@"email"];
    self.phoneNumberField.text  = [defaults objectForKey:@"phone"];
    self.carNumberField.text    = [defaults objectForKey:@"car"];
    self.attemptsField.text     = [[defaults objectForKey:@"attempts"] stringValue];
}

#pragma mark - UITextFieldDelegate's methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.usernameField resignFirstResponder];
    [self.emailField resignFirstResponder];
    [self.phoneNumberField resignFirstResponder];
    [self.carNumberField resignFirstResponder];
    return NO;
    
}

@end
