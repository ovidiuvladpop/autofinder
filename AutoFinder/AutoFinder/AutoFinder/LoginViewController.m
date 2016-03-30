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


@interface LoginViewController(){
    NSManagedObjectContext *context;
    __weak IBOutlet UIButton *loginButton;
    
}
@end


@implementation LoginViewController

#pragma mark - Actions

- (void)viewDidLoad{
    AppDelegate *appdelegate= [[UIApplication sharedApplication]delegate];
    context = [appdelegate managedObjectContext];
    
    [super viewDidLoad];
    [[self usernameField] setDelegate:self];
    [[self passwordField] setDelegate:self];
    [self makeRoundButtons:loginButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[[self navigationController] navigationBar] setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(IBAction)notButton:(id)sender{
    [self performSegueWithIdentifier:@"createAccountSegue" sender:self];
    
}
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    return NO;
}

- (IBAction)loginButtonPressed:(id)sender {
    NSEntityDescription *entitydesc = [NSEntityDescription entityForName:@"User"
                                                  inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entitydesc];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"username like %@ and password like %@", [[self usernameField] text], [[self passwordField] text]];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *matchingData=[context executeFetchRequest:request
                                                 error:&error];
    
    if(matchingData.count <= 0){
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Warning"
                                   message:@"Incorrect username or password !"
                                  delegate:self
                             cancelButtonTitle:@"Dismiss"
                              otherButtonTitles:nil];
        [alert show];
    } else
        {
            NSString *username;
            NSString *password;
            NSString *email;
            NSString *phone;
            NSString *car;
            NSNumber *attempts;
            
            for(NSManagedObjectContext *obj in matchingData) {
                username = [obj valueForKey:@"username"];
                password = [obj valueForKey:@"password"];
                email    = [obj valueForKey:@"email"];
                phone    = [obj valueForKey:@"phone"];
                car      = [obj valueForKey:@"car"];
                attempts = [obj valueForKey:@"attempts"];
            }
            
            [self saveUser:username withPassword:password email:email phoneNumber:phone carNumber:car andAttempts:attempts];
            [self performSegueWithIdentifier:@"loginSegue" sender:self];
        }
}

- (void)saveUser:(NSString *)username withPassword:(NSString *)password email:(NSString *)email phoneNumber:(NSString *)phone carNumber:(NSString *)car andAttempts:(NSNumber *)attempts{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:username forKey:@"username"];
    [defaults setObject:password forKey:@"password"];
    [defaults setObject:email    forKey:@"email"];
    [defaults setObject:phone    forKey:@"phone"];
    [defaults setObject:car      forKey:@"car"];
    [defaults setObject:attempts forKey:@"attempts"];
    
    [defaults synchronize];
}

- (void)makeRoundButtons:(UIButton *)button {
    button.layer.cornerRadius = 10;
    button.clipsToBounds = YES;
}

@end
