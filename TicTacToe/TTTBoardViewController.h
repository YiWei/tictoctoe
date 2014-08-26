//
//  TTTBoardViewController.h
//  TicTacToe
//
//  Created by Chia, Yi-Wei on 8/25/14.
//  Copyright (c) 2014 yiweic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTCommons.h"
#import "TTTAI.h"

@interface TTTBoardViewController : UIViewController <TTTAIGameStateDelegate>
- (id)initWithBoardWidth:(float)width;
- (void)startGameWithState:(TTTSingleSqureState)state depth:(int)depth;
@end
