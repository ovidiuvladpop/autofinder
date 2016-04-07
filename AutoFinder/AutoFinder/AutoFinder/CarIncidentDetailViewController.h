//
//  CarIncidentDetailViewController.h
//  AutoFinder
//
//  Created by user on 4/6/16.
//  Copyright © 2016 Basic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarIncidentDetailViewController : UIViewController
@property (nonatomic, weak) NSDate *incidentDate;
@property (nonatomic, strong) UIImage *imageIncident;
@property (nonatomic, strong) NSString *streetName;

@end
