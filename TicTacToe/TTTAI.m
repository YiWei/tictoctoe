//
//  TTTAI.m
//  TicTacToe
//
//  Created by Chia, Yi-Wei on 8/25/14.
//  Copyright (c) 2014 yiweic. All rights reserved.
//

#import "TTTAI.h"
#import "TTTSingleSquareView.h"

@interface TTTAIScore : NSObject
@property (nonatomic) int score;
@property (nonatomic) int index;
@end

@implementation TTTAIScore
@end

@interface TTTAI ()
@property (nonatomic) NSArray * winningPatterns;
@end

@implementation TTTAI

- (id)init {
    self = [super init];
    if (self) {
        _depth = 4;
        _winningPatterns = @[@0b111000000, @0b000111000, @0b000000111, @0b100100100, @0b010010010, @0b001001001, @0b100010001, @0b001010100];
    }
    return self;
}

- (int)determineStep:(NSArray *)squares userState:(TTTSingleSqureState)userState {
    TTTAIScore * finalScore = [self minimaxWithSquares:squares
                                                 depth:self.depth
                                          currentState:[[self class] toggleState:userState]
                                             userState:userState];
    return finalScore.index;
}


+ (TTTSingleSqureState)toggleState:(TTTSingleSqureState)state {
    if (state == SingleSquareCircle) {
        return SingleSquareCross;
    } else if (state == SingleSquareCross) {
        return SingleSquareCircle;
    }
    return SingleSquareNone;
}

- (NSArray*)possibleMoves:(NSArray*)squares {
    NSMutableArray * possibleMoves = [[NSMutableArray alloc] init];
    
    if ([self stateHasWon:SingleSquareCross withSquares:squares] || [self stateHasWon:SingleSquareCircle withSquares:squares]) {
        return possibleMoves;
    }

    for (int i = 0; i < MAX_NUMBER_TTT * MAX_NUMBER_TTT; i++) {
        TTTSingleSquareView * square = (TTTSingleSquareView*)squares[i];
        if (square.state == SingleSquareNone) {
            [possibleMoves addObject:[NSNumber numberWithInt:i]];
        }
    }
    return possibleMoves;
}

- (TTTAIScore*)minimaxWithSquares:(NSArray*)sqaures
                             depth:(int)depth
                      currentState:(TTTSingleSqureState)state
                         userState:(TTTSingleSqureState)userState {
    NSArray * possibleMoves = [self possibleMoves:sqaures];
    
    // Com state is maximizing; while user state is minimizing
    int bestScore = (state == userState) ? 100000 : -100000; // MAX value or min value
    int bestIndex;
    if (possibleMoves.count == 0 || depth == 0) {
        bestScore = [self evaluateScore:sqaures currentState:state userState:userState];
        bestIndex = -1;
    } else {
        for (NSNumber * indexNumber in possibleMoves) {
            int index = [indexNumber integerValue];
            TTTSingleSquareView* currentView = (TTTSingleSquareView*)sqaures[index];
            TTTSingleSqureState rememberState = currentView.state;
            currentView.state = state;
            int currentScore = [self minimaxWithSquares:sqaures
                                              depth:depth - 1
                                       currentState:[[self class] toggleState:state]
                                          userState:userState].score;
            if (state != userState) {
                if (currentScore > bestScore) {
                    bestScore = currentScore;
                    bestIndex = index;
                }
            } else {
                if (currentScore < bestScore) {
                    bestScore = currentScore;
                    bestIndex = index;
                }
            }
            // Setback to original state
            currentView.state = rememberState;
        }
    }
    
    if (bestScore == 0 && depth == self.depth && possibleMoves.count < 3) {
        // It's a draw game
        [self.delegate gameStateUpdate:TTTWinnerDraw];
    }
    TTTAIScore * finalScore = [[TTTAIScore alloc] init];

    finalScore.score = bestScore;
    finalScore.index = bestIndex;
    return finalScore;
}

- (int)evaluateScore:(NSArray*)squares
        currentState:(TTTSingleSqureState)state
           userState:(TTTSingleSqureState)userState{
    int score = 0;
    // Evaluate score for each of the 8 lines (3 rows, 3 columns, 2 diagonals)
    score += [self evaluateLineScoreWithSquares:squares index1:0 index2:1 index3:2 currentState:state userState:userState];  // row 0
    score += [self evaluateLineScoreWithSquares:squares index1:3 index2:4 index3:5 currentState:state userState:userState];  // row 1
    score += [self evaluateLineScoreWithSquares:squares index1:6 index2:7 index3:8 currentState:state userState:userState];  // row 2
    score += [self evaluateLineScoreWithSquares:squares index1:0 index2:3 index3:6 currentState:state userState:userState];  // col 0
    score += [self evaluateLineScoreWithSquares:squares index1:1 index2:4 index3:7 currentState:state userState:userState];  // col 1
    score += [self evaluateLineScoreWithSquares:squares index1:2 index2:5 index3:8 currentState:state userState:userState];  // col 2
    score += [self evaluateLineScoreWithSquares:squares index1:0 index2:4 index3:8 currentState:state userState:userState];  // diagonal
    score += [self evaluateLineScoreWithSquares:squares index1:2 index2:4 index3:6 currentState:state userState:userState];  // alternate diagonal
    return score;
}

- (TTTSingleSqureState)stateOfIndex:(int)index squares:(NSArray*)sqaures {
    return (TTTSingleSqureState)[(TTTSingleSquareView*)sqaures[index] state];
}

- (int)evaluateLineScoreWithSquares:(NSArray*)squares
                             index1:(int)index1
                             index2:(int)index2
                             index3:(int)index3
                       currentState:(TTTSingleSqureState)state
                          userState:(TTTSingleSqureState)userState {
    int score = 0;
    int indices[3] = {index1, index2, index3};
    int userStateCount = 0, comStateCount = 0;
    for (int i = 0; i < 3; i++) {
        TTTSingleSqureState squareState = [self stateOfIndex:indices[i] squares:squares];
        if (userState == squareState) {
            userStateCount++;
        } else if (squareState != SingleSquareNone) {
            comStateCount++;
        }
    }
    
    int advantage = 1;
    
    if (userStateCount == 3 || comStateCount == 3) {
        score = userStateCount == 3 ? -1000 : 1000;
    } else if (userStateCount == 0) {
        if (state != userState)
            advantage = 3;
        score = (int)pow(10.0f, comStateCount) * advantage;
    } else if (comStateCount == 0) {
        if (state == userState)
            advantage = 3;
        score = -(int)pow(10.0f, comStateCount) * advantage;
    }
    
    return score;
}



- (BOOL)stateHasWon:(TTTSingleSqureState)state withSquares:(NSArray*)squares {
    int pattern = 0b000000000;  // 9-bit pattern for the 9 cells
    for (int i = 0; i < squares.count; i++) {
        if ([(TTTSingleSquareView*)squares[i] state] == state) {
            pattern |= (1 << i);
        }
    }
    for (NSNumber * winningPatternNumber in self.winningPatterns) {
        int winningPattern = [winningPatternNumber integerValue];
        if ((pattern & winningPattern) == winningPattern)  {
            return YES;
        }
    }
    return NO;
}

- (void)updateSquares:(NSArray *)squares userState:(TTTSingleSqureState)userState {
    TTTWinnerState state = TTTWinnerNone;
    if ([self stateHasWon:userState withSquares:squares]) {
        state = TTTWinnerUser;
    } else if ([self stateHasWon:(userState == SingleSquareCircle ? SingleSquareCross : SingleSquareCircle)withSquares:squares]) {
        state = TTTWinnerCom;
    }
    [self.delegate gameStateUpdate:state];
}
@end
