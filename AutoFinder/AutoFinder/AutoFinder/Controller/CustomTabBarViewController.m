//
//  CustomTabBarViewController.m
//  AutoFinder
//
//  Created by webteam on 08/04/16.
//  Copyright © 2016 Basic. All rights reserved.
//

#import "CustomTabBarViewController.h"

@interface CustomTabBarViewController ()

@property (nonatomic, assign) int tabBarItemIndex;

@end

@implementation CustomTabBarViewController

#pragma mark - Init methods

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.tabBarItemIndex = 0;
        
    }
    
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setTabBarItemPhoto:@"homeLogo"];
    [self setTabBarItemPhoto:@"userLogo"];
    [self setTabBarItemPhoto:@"logoutLogo"];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];

}

//Method used for setting UITabBarNavigationItems's image.
- (void)setTabBarItemPhoto:(NSString *)imageName {
    
    UIImage *image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem * tabItem = [self.tabBar.items objectAtIndex:self.tabBarItemIndex];
    tabItem.image = image;
    tabItem.selectedImage = image;
    self.tabBarItemIndex++;
    
}

@end
