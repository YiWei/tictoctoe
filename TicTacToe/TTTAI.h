//
//  TTTAI.h
//  TicTacToe
//
//  Created by Chia, Yi-Wei on 8/25/14.
//  Copyright (c) 2014 yiweic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTTCommons.h"

typedef enum : NSUInteger {
    TTTWinnerNone = 0,
    TTTWinnerDraw,
    TTTWinnerUser,
    TTTWinnerCom,
} TTTWinnerState;

@protocol TTTAIGameStateDelegate <NSObject>
- (void)gameStateUpdate:(TTTWinnerState)winnerState;
@end

@interface TTTAI : NSObject
@property (nonatomic, weak) NSObject<TTTAIGameStateDelegate> * delegate;
@property (nonatomic) int depth;
- (int)determineStep:(NSArray*)squares userState:(TTTSingleSqureState)userState;
- (void)updateSquares:(NSArray*)squares userState:(TTTSingleSqureState)userState;
@end


