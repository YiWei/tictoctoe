//
//  TTTAppDelegate.m
//  TicTacToe
//
//  Created by Chia, Yi-Wei on 8/25/14.
//  Copyright (c) 2014 yiweic. All rights reserved.
//

#import "TTTAppDelegate.h"
#import "TTTNavigationController.h"
#import "TTTMainViewController.h"

@implementation TTTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    TTTNavigationController * navController = [[TTTNavigationController alloc] initWithRootViewController:[[TTTMainViewController alloc] init]];
    self.window.rootViewController = navController;
    
    return YES;
}

@end
