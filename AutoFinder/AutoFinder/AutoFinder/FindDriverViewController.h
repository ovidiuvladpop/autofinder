//
//  FindDriverViewController.h
//  AutoFinder
//
//  Created by webteam on 23/03/16.
//  Copyright © 2016 Basic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindDriverViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *showParkingLabel;
@property (strong, nonatomic) IBOutlet UILabel *showParkingLabel2;

@property (weak, nonatomic) IBOutlet UIButton *takePhotoButton;
@property (weak, nonatomic) IBOutlet UITextField *carNumberField;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property (weak, nonatomic) NSString *photoName;

- (IBAction)recieveNumber:(id)sender;

@end
