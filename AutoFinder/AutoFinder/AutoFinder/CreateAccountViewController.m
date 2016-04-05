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
#import <QuartzCore/QuartzCore.h>

@interface CreateAccountViewController () {
    
    NSManagedObjectContext *context;
    __weak IBOutlet UIButton *createAccountButton;
    __weak UITextField *activeField;
    
}

@end

@implementation CreateAccountViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [[self usernameField] setDelegate:self];
    [[self passwordField] setDelegate:self];
    [[self phoneNumberField] setDelegate:self];
    
    CGRect frame = createAccountButton.frame;
    float height = CGRectGetMaxY(frame) + 20.0;
    
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, height);
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    context = [appDelegate managedObjectContext];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[[self navigationController] navigationBar] setHidden:NO];
     self.title = @"Create a new account";
}

- (void)viewDidAppear:(BOOL)animated
{
    [self registerForKeyboardNotifications];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self unRegisterForKeyboardNotifications];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Keyboard Notifications

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWillShowNotification:(NSNotification*)aNotification {
    float height = [[aNotification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
    
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))
    {
        height =  [[aNotification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.width;
    }
    
    _scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0, height, 0.0);
    _scrollView.scrollIndicatorInsets = _scrollView.contentInset;
    
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillHideNotification:(NSNotification*)aNotification {
    
    if(![_usernameField isFirstResponder]) {
        self.scrollView.contentOffset = CGPointZero;
    }
    if(![_passwordField isFirstResponder]) {
        self.scrollView.contentOffset = CGPointZero;
    }
    if(![_phoneNumberField isFirstResponder]) {
        self.scrollView.contentOffset = CGPointZero;
    }
        _scrollView.contentInset = UIEdgeInsetsZero;
    _scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
}

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)unRegisterForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Actions

- (void)makeRoundButtons:(UIButton *)button {
    button.layer.cornerRadius = 10;
    button.clipsToBounds = YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _emailField) {
        _scrollView.contentOffset =  CGPointMake(0.0, _passwordField.frame.origin.y + 10.0);
    }
    
    if (textField == _carNumberField) {
        _scrollView.contentOffset =  CGPointMake(0.0, _passwordField.frame.origin.y + 10.0);
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [[self usernameField] resignFirstResponder];
    [[self passwordField] resignFirstResponder];
    [[self emailField] resignFirstResponder];
    [[self phoneNumberField] resignFirstResponder];
    [[self carNumberField] resignFirstResponder];
    return NO;
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

    }
  }

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    return NO;
}

- (void)dismissKeyboard {
    [[self usernameField] resignFirstResponder];
    [[self passwordField] resignFirstResponder];
    [[self phoneNumberField] resignFirstResponder];
    [[self carNumberField] resignFirstResponder];
    [[self emailField] resignFirstResponder];
}

@end
