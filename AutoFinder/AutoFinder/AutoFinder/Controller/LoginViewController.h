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
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *autoLabel;

- (IBAction)loginButtonPressed:(id)sender;
- (IBAction)notHavingAccountButtonPressed:(id)sender;

@end
