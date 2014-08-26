//
//  TTTMainViewController.h
//  TicTacToe
//
//  Created by Chia, Yi-Wei on 8/25/14.
//  Copyright (c) 2014 yiweic. All rights reserved.
//

#import <UIKit/UIKit.h>

static int const ANIMATION_DURATION = 1;

@interface TTTMainViewController : UIViewController
- (void)showAlert:(NSString*)alertString autoDismiss:(BOOL)autodismiss;
@end
