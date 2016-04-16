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
#import "LoginViewController.h"

@interface CreateAccountViewController () {}

@property (nonatomic, weak) IBOutlet UIButton *createAccountButton;
@property (nonatomic, weak) NSManagedObjectContext *context;

@end

@implementation CreateAccountViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.usernameField setDelegate:self];
    [self.passwordField setDelegate:self];
    [self.phoneNumberField setDelegate:self];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.context = [appDelegate managedObjectContext];
    
    CGRect frame = self.createAccountButton.frame;
    float height = CGRectGetMaxY(frame) + 20.0;
    
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, height);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [[[self navigationController] navigationBar] setHidden:NO];
    [self makeRoundButtons:self.createAccountButton];
    self.title = @"Create a new account";
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self registerForKeyboardNotifications];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    [self unRegisterForKeyboardNotifications];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Keyboard Notifications

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWillShowNotification:(NSNotification*)aNotification {
    float height = [[aNotification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
    
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
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
//Method used for handling the keyboard notifications
- (void)registerForKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShowNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHideNotification:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

//Method used for handling the keyboard notifications.
- (void)unRegisterForKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
}

#pragma mark - Actions

//Method used for creating a new account
-(IBAction)createAccountButtonPressed:(id)sender {
    
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"User"
                                                         inManagedObjectContext:appDelegate.managedObjectContext];
    NSManagedObject *newUser =[[NSManagedObject alloc] initWithEntity:entityDescription
                                       insertIntoManagedObjectContext:self.context];
    
    [newUser setValue:[[self usernameField] text]
               forKey:@"username"];
    [newUser setValue:[[self passwordField] text]
               forKey:@"password"];
    [newUser setValue:[[self emailField] text]
               forKey:@"email"];
    [newUser setValue:[[self phoneNumberField] text]
               forKey:@"phone"];
    [newUser setValue:[[self carNumberField] text]
               forKey:@"car"];
    [newUser setValue:[NSNumber numberWithInt:3]
               forKey:@"attempts"];
    
    if ([self checkForEmptyTextField]) {
        UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"Warning"
                                                           message:@"Please fill in all fields !"
                                                          delegate:nil
                                                 cancelButtonTitle:@"Ok"
                                                 otherButtonTitles:nil];
        [alertView show];
        
    } else {
        NSError *error;
        BOOL isSaved = [appDelegate.managedObjectContext save:&error];
        
        if (isSaved) {
            UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"Welcome"
                                                               message:@"Your account has been created !"
                                                              delegate:self
                                                     cancelButtonTitle:@"Login"
                                                     otherButtonTitles:nil];
            [alertView show];
        }
    }
}

//Method used for making round buttons.
- (void)makeRoundButtons:(UIButton *)button {
    button.layer.cornerRadius = 10;
    button.clipsToBounds = YES;
}

//Method used for checking empty text fields.
- (BOOL)checkForEmptyTextField {
    
    if (([self.usernameField.text isEqualToString:@""]) || ([self.passwordField.text isEqualToString:@""]) || ([self.emailField.text isEqualToString:@""]) ||
        ([self.phoneNumberField.text isEqualToString:@""]) || ([self.carNumberField.text isEqualToString:@""])) {
        return YES;
        
    } else {
            return NO;
        }
    
}

- (void)dismissKeyboard {
    
    [[self usernameField] resignFirstResponder];
    [[self passwordField] resignFirstResponder];
    [[self phoneNumberField] resignFirstResponder];
    [[self carNumberField] resignFirstResponder];
    [[self emailField] resignFirstResponder];
    
}

#pragma mark - UITextFieldDelegate's methods

//Tells the delegate that editing began in the specified text field.
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (textField == _emailField) {
        _scrollView.contentOffset =  CGPointMake(0.0, _passwordField.frame.origin.y + 10.0);
    }
    
    if (textField == _carNumberField) {
        _scrollView.contentOffset =  CGPointMake(0.0, _passwordField.frame.origin.y + 10.0);
    }
    
}

//Asks the delegate if the text field should process the pressing of the return button.
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [[self usernameField] resignFirstResponder];
    [[self passwordField] resignFirstResponder];
    [[self emailField] resignFirstResponder];
    [[self phoneNumberField] resignFirstResponder];
    [[self carNumberField] resignFirstResponder];
    
    return NO;
    
}

#pragma mark - UIAlertViewDelegate's method

//Sent to the delegate when the user clicks a button on an alert view.
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
#pragma mark - UINavigationController

//Called when the segue with the specified identifier should be performed.
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
    return NO;
    
}

@end
