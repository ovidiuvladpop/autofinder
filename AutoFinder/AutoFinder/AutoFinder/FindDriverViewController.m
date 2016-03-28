//
//  FindDriverViewController.m
//  AutoFinder
//
//  Created by webteam on 23/03/16.
//  Copyright © 2016 Basic. All rights reserved.
//

#import "FindDriverViewController.h"
#import "AppDelegate.h"

@interface FindDriverViewController(){
    NSManagedObjectContext *context;
}
@end

@implementation FindDriverViewController

- (IBAction)recieveNumber:(id)sender {
    
    if ([[self photoName] isEqualToString:@"MyPhoto"]) {
        if([self checkCarNumbeField]) {
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
                NSString *phoneNumber;
        
                for(NSManagedObjectContext *obj in matchingData) {
                    phoneNumber = [obj valueForKey:@"phone"];
                }
       
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"We found the phone number" message:phoneNumber delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
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


-(void)decreaseAttempts{
    
}

- (BOOL)checkCarNumbeField {
    if ([[self carNumberField] text] == nil) {
        return NO;
    }
        return YES;
}

-(void)roundButton:(UIButton*)button {
    CALayer *btnLayer = [button layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:10.0f];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self roundButton:self.takePhotoButton];
    [self roundButton:self.sendButton];
    
    
    
    AppDelegate *appdelegate= [[UIApplication sharedApplication]delegate];
    context = [appdelegate managedObjectContext];
}
@end
