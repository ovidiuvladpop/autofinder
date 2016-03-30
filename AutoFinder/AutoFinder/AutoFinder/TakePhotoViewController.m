//
//  TakePhotoViewController.m
//  AutoFinder
//
//  Created by webteam on 23/03/16.
//  Copyright © 2016 Basic. All rights reserved.
//

#import "TakePhotoViewController.h"
#import "FindDriverViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface TakePhotoViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation TakePhotoViewController 

-(void)viewDidLoad{
    [super viewDidLoad];
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions

-(IBAction)selectPhotoButton:(id)sender{
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

-(IBAction)sendPhoto:(id)sender{
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
        if (buttonIndex == 1) {
            FindDriverViewController *previousViewController = [self previousViewController];
            previousViewController.photoName = @"MyPhoto";
            [self.navigationController popViewControllerAnimated:YES];
        }
}


#pragma mark - Image Picker Controller delegate methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image=chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end
