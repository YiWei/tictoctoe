//
//  TTTNavigationController.m
//  TicTacToe
//
//  Created by Chia, Yi-Wei on 8/25/14.
//  Copyright (c) 2014 yiweic. All rights reserved.
//

#import "TTTNavigationController.h"
#import "TTTMainViewController.h"

@interface TTTNavigationController ()
- (void)newGame;
- (void)cancelGame;
@end

@implementation TTTNavigationController

- (id)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        [self setupNavigationItem:rootViewController];
    }
    return self;
}

- (void)setupNavigationItem:(UIViewController *)vc {
    UIBarButtonItem * barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New Game"
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self action:@selector(newGame)];
    UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel Game"
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self action:@selector(cancelGame)];
    vc.navigationItem.rightBarButtonItem = barButtonItem;
    vc.navigationItem.backBarButtonItem = backButtonItem;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:NO];
    [self setupNavigationItem:viewController];
}

- (void)newGame {
    [UIView  beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75f];
    [self pushViewController:[[TTTMainViewController alloc] init] animated:YES];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:NO];
    [UIView commitAnimations];
}

- (void)cancelGame {
    [self popViewControllerAnimated:YES];
}

@end
