//
//  LoginViewController.h
//  AutoFinder
//
//  Created by user117310 on 3/20/16.
//  Copyright © 2016 Basic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate> {
    NSDictionary *infoDictionary;
}

@property (nonatomic, weak) IBOutlet UITextField *usernameField;
@property (nonatomic, weak) IBOutlet UITextField *passwordField;

- (IBAction)loginButtonPressed:(id)sender;

- (IBAction)notButton:(id)sender;


@end
