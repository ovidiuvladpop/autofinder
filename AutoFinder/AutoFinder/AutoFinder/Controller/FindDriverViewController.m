//
//  FindDriverViewController.m
//  AutoFinder
//
//  Created by webteam on 23/03/16.
//  Copyright © 2016 Basic. All rights reserved.
//

#import "FindDriverViewController.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@interface FindDriverViewController() <UIAlertViewDelegate> {}

@property (nonatomic, weak) NSManagedObjectContext *context;
@property (nonatomic, weak) NSString *phoneNumber;
@property (nonatomic, weak) IBOutlet UIButton *findDriverButton;
@property (nonatomic, weak) IBOutlet UIButton *sendPhotoButton;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@end

@implementation FindDriverViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    AppDelegate *appdelegate= [[UIApplication sharedApplication]delegate];
    self.context = [appdelegate managedObjectContext];
    
    [[self carNumberField] setDelegate:self];
    
    [self makeRoundButtons:self.findDriverButton];
    [self makeRoundButtons:self.sendPhotoButton];
    
    self.scrollView.contentSize = CGSizeMake(600, 800);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
     self.title = @"Find driver";
    
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
    
    if(![self.carNumberField isFirstResponder]) {
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

- (IBAction)recieveNumber:(id)sender {
    
    if (self.selectedPhotoByUser) {
        
        if ([self isCarNumberFieldEmpty]) {
            
            if ([self checkAttempts]) {
                
                NSEntityDescription *entitydesc = [NSEntityDescription entityForName:@"User"
                                                              inManagedObjectContext:self.context];
                NSFetchRequest *request = [[NSFetchRequest alloc]init];
                [request setEntity:entitydesc];
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"car like %@", [[self carNumberField] text]];
                [request setPredicate:predicate];
                
                NSError *error;
                NSArray *matchingData=[self.context executeFetchRequest:request
                                                             error:&error];
                
                if(matchingData.count <= 0){
                    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"We are sorry"
                                                                   message:@"We have not found any number!"
                                                                  delegate:self
                                                         cancelButtonTitle:@"Dismiss"
                                                         otherButtonTitles:nil];
                    [alert show];
                    
                } else {
                    
                    for(NSManagedObjectContext *obj in matchingData) {
                        self.phoneNumber = [obj valueForKey:@"phone"];
                    }
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"We found the phone number"
                                                                    message:self.phoneNumber
                                                                   delegate:self
                                                          cancelButtonTitle:@"Cancel"
                                                          otherButtonTitles:@"Call", nil];
                    [alert show];
                    [self decreaseAttempts];
                }
                
            } else {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"You have no more attempts!"
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"Ok", nil];
                [alert show];
            }
            
        } else {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                            message:@"Please fill in car number !"
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Ok", nil];
            [alert show];
        }
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:@"Select a photo !"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"Ok", nil];
        [alert show];
    }
    
}

- (void)dismissKeyboard {
    
    [[self carNumberField] resignFirstResponder];
    
}

- (void)makeRoundButtons:(UIButton *)button {
    button.layer.cornerRadius = 10;
    button.clipsToBounds = YES;
}

//Method used for decrease attempts when user checks for car number.
- (void)decreaseAttempts { 
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:self.context]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"email == %@", [defaults objectForKey:@"email"]];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *results = [self.context executeFetchRequest:request error:&error];
    
    NSManagedObject* obj = [results objectAtIndex:0];
    NSNumber *numberOfAttempts = [NSNumber numberWithInt:([[obj valueForKey:@"attempts"] intValue] - 1)];

    [obj setValue:numberOfAttempts forKey:@"attempts"];
    [self.context save:&error];
    [self updateDefaultUser:numberOfAttempts];
}

//Method used for checking user's attempts.
- (BOOL)checkAttempts {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:@"attempts"] intValue] < 1) {
        return false;
    }
    return true;
}

//Method used for updating user on NSUserDefaults
- (void)updateDefaultUser:(NSNumber *)numberOfAttempts {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:numberOfAttempts forKey:@"attempts"];
    [defaults synchronize];
    
}

//Method used for checking emtpy fields.
- (BOOL)isCarNumberFieldEmpty {
    
    if ([self.carNumberField.text isEqualToString:@""]) {
        
        return NO;
        
    }
    
    return YES;
}

#pragma mark - UITextFieldDelegate's methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (textField == self.carNumberField){
        
        self.scrollView.contentOffset =  CGPointMake(0.0, self.showParkingLabel2.frame.origin.y - 1.0);
        
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [[self carNumberField] resignFirstResponder];
    
    return NO;
    
}

#pragma mark - UIAlertViewDelegate's methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        
        NSString *phoneNumberToCall = [@"tel://" stringByAppendingString:self.phoneNumber];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumberToCall]];
        
    }
    
}

@end
