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
#import <AssetsLibrary/AssetsLibrary.h>
#import <SKMaps/SKPositionerService.h>
#import "PersistenceController.h"

@interface TakePhotoViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate> {}

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UIButton *takePhotoButton;
@property (nonatomic, weak) IBOutlet UIButton *selectPhotoButton;
@property (nonatomic, weak) IBOutlet UIButton *sendPhotoButton;
@property (nonatomic, weak) SKPositionerService *positionerService;
@end

@implementation TakePhotoViewController 

#pragma mark - UIViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeRoundButtons:self.takePhotoButton];
    [self makeRoundButtons:self.selectPhotoButton];
    [self makeRoundButtons:self.sendPhotoButton];
    [self.sendPhotoButton setHidden:YES];
    
    self.positionerService = [SKPositionerService sharedInstance];
    [self.positionerService startLocationUpdate];
    
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
            previousViewController.selectedPhotoByUser = self.imageView.image;
            PersistenceController *instance = [PersistenceController sharedInstance];
            [instance sendPhotoToDatabase:self.imageView.image withCoordinates:self.positionerService.currentCoordinate];
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
    [self.sendPhotoButton setHidden:NO];
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end
