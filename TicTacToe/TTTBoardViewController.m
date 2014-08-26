//
//  TTTBoardViewController.m
//  TicTacToe
//
//  Created by Chia, Yi-Wei on 8/25/14.
//  Copyright (c) 2014 yiweic. All rights reserved.
//

#import "TTTBoardViewController.h"
#import "TTTMainViewController.h"
#import "TTTAI.h"
#import "TTTSingleSquareView.h"

@interface TTTBoardViewController ()
@property (nonatomic) float boardWidth;
@property (nonatomic) NSMutableArray * squareList;
@property (nonatomic) TTTSingleSqureState currentState;
@property (nonatomic) TTTSingleSqureState userSelectedState;
@property (nonatomic) BOOL isCom;
@property (nonatomic) TTTAI * ai;
- (void)loadTTTBoard;
@end

@implementation TTTBoardViewController

- (id)initWithBoardWidth:(float)width {
    self = [super init];
    if (self) {
        _boardWidth = width;
        _squareList = [[NSMutableArray alloc] init];
        _currentState = SingleSquareCircle;
        _ai = [[TTTAI alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [self.squareList removeAllObjects];
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self loadTTTBoard];
    [self.view sizeThatFits:CGSizeMake(self.boardWidth, self.boardWidth)];
    self.ai.delegate = self;
}

- (void)setIsCom:(BOOL)isCom {
    _isCom = isCom;
    if (isCom) {
        self.view.userInteractionEnabled = NO;
        if ([self.parentViewController isKindOfClass:[TTTMainViewController class]]) {
            TTTMainViewController * mainVC = (TTTMainViewController*)self.parentViewController;
            [mainVC showAlert:@"Thinking" autoDismiss:YES];
        }
        [self performSelector:@selector(viewTapped:)
                   withObject:self.squareList[[self.ai determineStep:self.squareList userState:self.userSelectedState]]
                   afterDelay:ANIMATION_DURATION];
    } else {
        self.view.userInteractionEnabled = YES;
    }
}

- (void)loadTTTBoard {
    for (int i = 0; i < MAX_NUMBER_TTT * MAX_NUMBER_TTT; i++) {
        float segLength = self.boardWidth / MAX_NUMBER_TTT;
        float x = (i % MAX_NUMBER_TTT) * segLength;
        float y = (i / MAX_NUMBER_TTT) * segLength;
        CGRect frame = CGRectMake(x, y, segLength, segLength);
        
        UIView * newSquare = [[TTTSingleSquareView alloc] initWithFrame:frame];
        
        [self.squareList addObject:newSquare];
        [self.view addSubview:newSquare];
    }
}

- (void)toggleCurrentState {
    if (self.currentState == SingleSquareCross) {
        self.currentState = SingleSquareCircle;
    } else {
        self.currentState = SingleSquareCross;
    }
    
    self.isCom = !self.isCom;
}

- (void)viewTapped:(id)sender {
    TTTSingleSquareView * square;
    if ([sender isKindOfClass:[UITapGestureRecognizer class]]) {
        UITapGestureRecognizer * tapRecognizer = (UITapGestureRecognizer*)sender;
        square = (TTTSingleSquareView*)tapRecognizer.view;
    } else if ([sender isKindOfClass:[TTTSingleSquareView class]]) {
        square = (TTTSingleSquareView*)sender;
    }
    if (square && square.state == SingleSquareNone) {
        square.state = self.currentState;
        // Refresh the view to redraw the right icon for it
        [square setNeedsDisplay];
        [self.ai updateSquares:self.squareList userState:self.userSelectedState];
    }
}

- (void)startGameWithState:(TTTSingleSqureState)state depth:(int)depth {
    if (state != SingleSquareNone) {
        self.currentState = state;
        self.userSelectedState = state;
    }
    self.ai.depth = depth;
    for (TTTSingleSquareView * square in self.squareList) {
        UITapGestureRecognizer * tapRecognizer =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
        [square addGestureRecognizer:tapRecognizer];
    }
}

- (void)gameStateUpdate:(TTTWinnerState)winnerState {
    if ( winnerState == TTTWinnerNone) {
        // Toggle the state to continue
        [self toggleCurrentState];
    } else {
        NSString * alertString;
        switch (winnerState) {
            case TTTWinnerDraw:
                alertString = @"Draw";
                break;
            case TTTWinnerUser:
                alertString = @"You Win!!";
                break;
            case TTTWinnerCom:
                alertString = @"You Lose!!";
                break;
            default:
                alertString = @"This should not happen";
                break;
        }
        if ([self.parentViewController isKindOfClass:[TTTMainViewController class]]) {
            TTTMainViewController * mainVC = (TTTMainViewController*)self.parentViewController;
            [mainVC showAlert:alertString autoDismiss:NO];
        }
        self.view.userInteractionEnabled = NO;
        [UIView animateWithDuration:ANIMATION_DURATION * 2 animations:^{
            self.view.alpha = 0.3f;
        }];
        for (UIView * square in self.squareList) {
            square.userInteractionEnabled = NO;
        }
    }
}

@end
