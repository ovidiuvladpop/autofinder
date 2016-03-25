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


@interface LoginViewController(){
    NSManagedObjectContext *context;
}
@end


@implementation LoginViewController


-(IBAction)notButton:(id)sender{
    [self performSegueWithIdentifier:@"createAccountSegue" sender:self];
    
}
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    return NO;
}

- (IBAction)loginButtonPressed:(id)sender {
    
    //if ([[infoDictionary objectForKey:usernameField.text] isEqualToString:passwordField.text]) {
      //  HomeViewController *homeViewController = [[HomeViewController alloc] init];
      //  [self.navigationController pushViewController:homeViewController
                                         //    animated:YES];
  //  } else {
    //    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Warning"
                                               //        message:@"Incorrect username or password !"
                                                //      delegate:self
                                           //  cancelButtonTitle:@"Dismiss"
                                          //   otherButtonTitles:nil];
      //  [alert show];
   // }
    
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
            
            for(NSManagedObjectContext *obj in matchingData) {
                username = [obj valueForKey:@"username"];
                password = [obj valueForKey:@"password"];
            }
            [self performSegueWithIdentifier:@"loginSegue" sender:self];
        }
}




- (void)viewDidLoad{
    [super viewDidLoad];
    [[self usernameField] setDelegate:self];
    [[self passwordField] setDelegate:self];
    
    AppDelegate *appdelegate= [[UIApplication sharedApplication]delegate];
    context = [appdelegate managedObjectContext];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[[self navigationController] navigationBar] setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
