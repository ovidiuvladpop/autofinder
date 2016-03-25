//
//  CreateAccountViewController.m
//  AutoFinder
//
//  Created by user117310 on 3/20/16.
//  Copyright © 2016 Basic. All rights reserved.
//

#import "CreateAccountViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"


@interface CreateAccountViewController () {
    NSManagedObjectContext *context;
}

@end

@implementation CreateAccountViewController

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    CGPoint scrollPoint = CGPointMake(0, textField.frame.origin.y);
    [[self scrollView] setContentOffset:scrollPoint
                               animated:YES];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [[self scrollView] setContentOffset:CGPointZero
                               animated:YES];
    
}

-(void)dismissKeyboard{
    [[self usernameField] resignFirstResponder];
    [[self passwordField] resignFirstResponder];
    [[self emailField] resignFirstResponder];
    [[self phoneNumberField] resignFirstResponder];
    [[self carNumberField] resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
    
}

-(IBAction)createAccountButtonPressed:(id)sender{
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"User" inManagedObjectContext:appDelegate.managedObjectContext];
    NSManagedObject *newUser =[[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:context];
    [newUser setValue:[[self usernameField] text] forKey:@"username"];
    [newUser setValue:[[self passwordField] text] forKey:@"password"];
    [newUser setValue:[[self emailField] text] forKey:@"email"];
    [newUser setValue:[[self phoneNumberField] text] forKey:@"phone"];
    [newUser setValue:[[self carNumberField] text] forKey:@"car"];
    [newUser setValue:[NSNumber numberWithInt:3] forKey:@"attempts"];
    
    NSError *error;
    BOOL isSaved = [appDelegate.managedObjectContext save:&error];
    NSLog(@"Successfully saved flag: %d", isSaved);
    if (isSaved) {
        [[self navigationController] popViewControllerAnimated:YES];
    } else {
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Warning"
                                                       message:@"Incorrect username!"
                                                      delegate:self
                                             cancelButtonTitle:@"Dismiss"
                                             otherButtonTitles:nil];
        [alert show];    }
    
    //NSManagedObject *newUser = [[NSManagedObject alloc] initWithEntity:entityDescription
                                        //insertIntoManagedObjectContext:context];
    
    //[newUser setValue:[[self usernameField]text]
    //           forKey:@"username"];
    //[newUser setValue:[[self passwordField] text]
    //           forKey:@"password"];
    //[newUser setValue:[[self emailField] text]
    //           forKey:@"email"];
    //[newUser setValue:[[self phoneNumberField] text]
    //           forKey:@"phone"];
    //[newUser setValue:[[self carNumberField] text]
    //           forKey:@"car"];
    
    //NSError *error;
    //[context save:&error];
    
    [self dismissKeyboard];

}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    return NO;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    [[self usernameField] setDelegate:self];
    [[self passwordField] setDelegate:self];
    [[self emailField] setDelegate:self];
    [[self phoneNumberField] setDelegate:self];
    [[self carNumberField] setDelegate:self];
   
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    context = [appDelegate managedObjectContext];
    
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                         action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[[self navigationController] navigationBar] setHidden:NO];
}
@end
