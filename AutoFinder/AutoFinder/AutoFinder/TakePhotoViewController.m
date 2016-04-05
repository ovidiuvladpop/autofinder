//
//  TakePhotoViewController.m
//  AutoFinder
//
//  Created by webteam on 23/03/16.
//  Copyright © 2016 Basic. All rights reserved.
//

#import "TakePhotoViewController.h"
#import "AppDelegate.h"
#import "FindDriverViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface TakePhotoViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate> {
    
    __weak IBOutlet UIButton *takePhotoButton;
     NSManagedObjectContext *context;
    __weak IBOutlet UIButton *selectPhotoButton;
    __weak IBOutlet UIButton *sendPhotoButton;
}

@property (nonatomic, strong) IBOutlet UIImageView *imageView;

@end

@implementation TakePhotoViewController 

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeRoundButtons:takePhotoButton];
    [self makeRoundButtons:selectPhotoButton];
    [self makeRoundButtons:sendPhotoButton];
    [sendPhotoButton setHidden:YES];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    context = [appDelegate managedObjectContext];
    
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self.locationManager startUpdatingLocation];
    

}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.currentLocation = [locations lastObject];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     self.title = @"Choose photo";
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions

- (void)makeRoundButtons:(UIButton *)button {
    button.layer.cornerRadius = 10;
    button.clipsToBounds = YES;
}

-(IBAction)selectPhotoButton:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate=self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES
                     completion:NULL];
}

-(IBAction)takePhotoButton:(id)sender{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate=self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES
                     completion:NULL];
    
}

-(IBAction)sendPhoto:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:
                          @"Thank you" message:@"The photo is selected" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Send", nil];
    
    [alert show];
}

-(UIViewController *)previousViewController {
    NSInteger numberOfViewControllers = self.navigationController.viewControllers.count;
    
    if (numberOfViewControllers < 2) {
        return nil;
    } else {
        return [self.navigationController.viewControllers objectAtIndex:numberOfViewControllers - 2];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
        if (buttonIndex == 1) {
            FindDriverViewController *previousViewController = (FindDriverViewController *)[self previousViewController];
            previousViewController.photoName = @"MyPhoto";
            [self.navigationController popViewControllerAnimated:YES];
        }
}


#pragma mark - Image Picker Controller delegate methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.image = chosenImage;
    }];
    [sendPhotoButton setHidden:NO];
    
    [self sendToDatabase:chosenImage];
}




-(void)sendToDatabase:(UIImage *)image{
    
    NSNumber *latitude = [[NSNumber alloc] initWithFloat:self.currentLocation.coordinate.latitude];
    NSNumber *longitude = [[NSNumber alloc] initWithFloat:self.currentLocation.coordinate.longitude];
    
    NSLog(@"latitude is: %@",latitude);
    NSLog(@"longitude is: %@",longitude);
    
    
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Photo" inManagedObjectContext:appDelegate.managedObjectContext];
    NSManagedObject *newPhoto =[[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:context];
    
    NSData *dataWithImage = UIImagePNGRepresentation(image);
    [newPhoto setValue:dataWithImage forKey:@"photo"];
    [newPhoto setValue:[NSDate date] forKey:@"date"];
    [newPhoto setValue:latitude forKey:@"latitude"];
    [newPhoto setValue:longitude forKey:@"longitude"];
    NSLog(@"%@", [NSDate date]);
    
    NSError *error;
    BOOL isSaved = [appDelegate.managedObjectContext save:&error];
    NSLog(@"Successfully saved photo, flag: %d", isSaved);
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end
