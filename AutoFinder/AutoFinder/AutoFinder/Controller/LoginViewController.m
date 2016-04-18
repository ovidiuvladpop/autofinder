//
//  LoginViewController.m
//  AutoFinder
//
//  Created by user117310 on 3/20/16.
//  Copyright © 2016 Basic. All rights reserved.
//

#import "LoginViewController.h"
#import "HomeViewController.h"
#import "CreateAccountViewController.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "PersistenceController.h"

@interface LoginViewController() {}

@property (nonatomic, weak) IBOutlet UIButton *loginButton;

@end

@implementation LoginViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[self usernameField] setDelegate:self];
    [[self passwordField] setDelegate:self];
    [self makeRoundButtons:self.loginButton];
    
    self.scrollView.contentSize = CGSizeMake(600, 800);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[[self navigationController] navigationBar] setHidden:YES];
    
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
    
    self.scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0, height, 0.0);
    self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset;
    
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillHideNotification:(NSNotification*)aNotification {
    
    if(![self.usernameField isFirstResponder]) {
        
        self.scrollView.contentOffset = CGPointZero;
    }
    
    self.scrollView.contentInset = UIEdgeInsetsZero;
    self.scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
    
}

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

- (void)unRegisterForKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
}

#pragma mark - Actions

//Method used for login the user in application.
- (IBAction)loginButtonPressed:(id)sender {
    
    PersistenceController *instance = [PersistenceController sharedInstance];
    if([instance loginUser:self.usernameField.text
               andPassword:self.passwordField.text]) {
        
        [self performSegueWithIdentifier:@"loginSegue"
                                  sender:self];
        
    } else {
        
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Warning"
                                                       message:@"Incorrect username or password !"
                                                      delegate:self
                                             cancelButtonTitle:@"Dismiss"
                                             otherButtonTitles:nil];
        [alert show];
    }
}

//Method used for making round buttons.
- (void)makeRoundButtons:(UIButton *)button {
    
    button.layer.cornerRadius = 10;
    button.clipsToBounds = YES;
    
}

//Method used for calling the UIViewController responsible for creating a new account.
-(IBAction)notHavingAccountButtonPressed:(id)sender {
    
    [self performSegueWithIdentifier:@"createAccountSegue" sender:self];
    
}

#pragma mark - UITextFieldDelegate's methods

-(void)textFieldDidBeginEditing:(UITextField *)textField {

    if (textField == self.passwordField){
        self.scrollView.contentOffset =  CGPointMake(0.0, self.autoLabel.frame.origin.y - 1.0);
    }
    
}

- (void)dismissKeyboard {
    
    [[self usernameField] resignFirstResponder];
    [[self passwordField] resignFirstResponder];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [[self usernameField] resignFirstResponder];
    [[self passwordField] resignFirstResponder];
    return NO;
    
}

#pragma mark - UINavigationController

//Method invoked when the segue with the specified identifier should be performed.
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
    return NO;
    
}

@end
