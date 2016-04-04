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

@interface FindDriverViewController() <UIAlertViewDelegate> {
    
    NSManagedObjectContext *context;
    NSString *phoneNumber;
    __weak IBOutlet UIButton *findDriverButton;
    __weak IBOutlet UIButton *sendPhotoButton;
    IBOutlet UIScrollView *scrollView;
    
}
@end

@implementation FindDriverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appdelegate= [[UIApplication sharedApplication]delegate];
    context = [appdelegate managedObjectContext];
    
    [[self carNumberField] setDelegate:self];
    
    [self makeRoundButtons:findDriverButton];
    [self makeRoundButtons:sendPhotoButton];
    
    //_scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, height);
    scrollView.contentSize = CGSizeMake(600, 800);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self registerForKeyboardNotifications];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [self unRegisterForKeyboardNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Keyboard Notifications

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWillShowNotification:(NSNotification*)aNotification {
    float height = [[aNotification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
    
    
    
    scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0, height, 0.0);
    scrollView.scrollIndicatorInsets = scrollView.contentInset;
    
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillHideNotification:(NSNotification*)aNotification {
    
    if(![_carNumberField isFirstResponder]) {
        scrollView.contentOffset = CGPointZero;
    }
    scrollView.contentInset = UIEdgeInsetsZero;
    scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
}


- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)unRegisterForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Actions

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (textField == _carNumberField){
        scrollView.contentOffset =  CGPointMake(0.0, _showParkingLabel2.frame.origin.y - 1.0);
    }
}

- (void)dismissKeyboard {
    [[self carNumberField] resignFirstResponder];
   
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [[self carNumberField] resignFirstResponder];
    return NO;
}

- (void)makeRoundButtons:(UIButton *)button {
    button.layer.cornerRadius = 10;
    button.clipsToBounds = YES;
}

- (IBAction)recieveNumber:(id)sender {
    
    if ([[self photoName] isEqualToString:@"MyPhoto"]) {
        if ([self checkCarNumbeField]) {
            if ([self checkAttempts]) {
                NSLog(@"%@", self.photoName);
                NSEntityDescription *entitydesc = [NSEntityDescription entityForName:@"User"
                                                              inManagedObjectContext:context];
                NSFetchRequest *request = [[NSFetchRequest alloc]init];
                [request setEntity:entitydesc];
    
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"car like %@", [[self carNumberField] text]];
                [request setPredicate:predicate];
    
                NSError *error;
                NSArray *matchingData=[context executeFetchRequest:request
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
                        phoneNumber = [obj valueForKey:@"phone"];
                    }
       
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"We found the phone number" message:phoneNumber delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Call", nil];
                    [alert show];
                    [self decreaseAttempts];
                }
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"You have no more attempts!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                [alert show];
            }
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Car number not found !" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Photo not selected !" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSString *phoneNumberToCall = [@"tel://" stringByAppendingString:phoneNumber];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumberToCall]];
    }
}


- (void)decreaseAttempts { 
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:context]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"email == %@", [defaults objectForKey:@"email"]];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    NSManagedObject* obj = [results objectAtIndex:0];
    NSNumber *numberOfAttempts = [NSNumber numberWithInt:([[obj valueForKey:@"attempts"] intValue] - 1)];

    [obj setValue:numberOfAttempts forKey:@"attempts"];
    [context save:&error];
    [self updateDefaultUser:numberOfAttempts];
}

- (BOOL)checkAttempts {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:@"attempts"] intValue] < 1) {
        return false;
    }
    return true;
}

- (void)updateDefaultUser:(NSNumber *)numberOfAttempts {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:numberOfAttempts forKey:@"attempts"];
    [defaults synchronize];
}


- (BOOL)checkCarNumbeField {
    if ([[self carNumberField] text] == nil) {
        return NO;
    }
        return YES;
}

@end
