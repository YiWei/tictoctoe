//
//  TTTMainViewController.m
//  TicTacToe
//
//  Created by Chia, Yi-Wei on 8/25/14.
//  Copyright (c) 2014 yiweic. All rights reserved.
//

#import "TTTMainViewController.h"
#import "TTTBoardViewController.h"

static float const BOARD_WIDTH = 250.0f;
static float const BUTTON_BAR_PADDING = 30.0f;
static float const ALERT_BAR_HEIGHT = 50.0f;

typedef enum : NSUInteger {
    TagStartButtonEasy = 0x23232,
    TagStartButtonHard,
    TagBoard,
    TagAlertView,
} TTTMainViewTags;

@interface TTTMainViewController ()
@property (nonatomic) TTTBoardViewController * boardViewController;
- (void)startGame:(id)sender;
@end

@implementation TTTMainViewController

- (id)init {
    self = [super init];
    if (self) {
        _boardViewController = [[TTTBoardViewController alloc] initWithBoardWidth:BOARD_WIDTH];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addChildViewController:self.boardViewController];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    UIView * boardView = self.boardViewController.view;
    CGRect boardFrame = boardView.frame;
    boardFrame = CGRectMake((screenWidth - BOARD_WIDTH) / 2,
                            (screenHeight - BOARD_WIDTH) / 2,
                            BOARD_WIDTH,
                            BOARD_WIDTH);
    
    boardView.frame = boardFrame;
    boardView.tag = TagBoard;
    [self.view addSubview:self.boardViewController.view];
    
    UIButton * startButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [startButton setTitle:@"Easy Game" forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(startGame:) forControlEvents:UIControlEventTouchUpInside];
    [startButton.titleLabel sizeToFit];
    [startButton sizeToFit];
    
    CGRect buttonFrame = startButton.frame;
    buttonFrame.origin.x = boardFrame.origin.x;
    buttonFrame.origin.y = boardFrame.origin.y + boardFrame.size.height + BUTTON_BAR_PADDING;
    
    startButton.frame = buttonFrame;
    startButton.tag = TagStartButtonEasy;
    
    [self.view addSubview:startButton];
    
    startButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [startButton setTitle:@"Hard Game" forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(startGame:) forControlEvents:UIControlEventTouchUpInside];
    [startButton.titleLabel sizeToFit];
    [startButton sizeToFit];
    
    buttonFrame = startButton.frame;
    buttonFrame.origin.x = boardFrame.origin.x + boardFrame.size.width - buttonFrame.size.width;
    buttonFrame.origin.y = boardFrame.origin.y + boardFrame.size.height + BUTTON_BAR_PADDING;
    
    startButton.frame = buttonFrame;
    startButton.tag = TagStartButtonHard;
    
    [self.view addSubview:startButton];
}

static int const HARD_DEPTH = 4;
static int const EASY_DEPTH = 1;

- (void)startGame:(id)sender {
    UIView * startButtonEasy = [self.view viewWithTag:TagStartButtonEasy];
    UIView * startButtonHard = [self.view viewWithTag:TagStartButtonHard];
    int depth = 0;
    if (startButtonEasy == sender) {
        depth = EASY_DEPTH;
    } else {
        depth = HARD_DEPTH;
    }
    [self.boardViewController startGameWithState:SingleSquareCircle depth:depth];
    
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        startButtonEasy.alpha = 0.0f;
        startButtonHard.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [startButtonEasy removeFromSuperview];
        [startButtonHard removeFromSuperview];
    }];
    [self showAlert:@"Game Started" autoDismiss:YES];
    
}

- (void)showAlert:(NSString *)alertString autoDismiss:(BOOL)autodismiss{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    UIView * alertViewContainer = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight, screenWidth, ALERT_BAR_HEIGHT)];
    alertViewContainer.backgroundColor = [UIColor purpleColor];
    alertViewContainer.tag = TagAlertView;
    [self.view addSubview:alertViewContainer];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectZero];
    [label setText:alertString];
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    CGRect labelFrame = label.frame;
    
    labelFrame.origin.x = (screenWidth - labelFrame.size.width) / 2;
    labelFrame.origin.y = (ALERT_BAR_HEIGHT - labelFrame.size.height) / 2;
    label.frame = labelFrame;
    
    [alertViewContainer addSubview:label];
    CGRect newFrame = CGRectMake(0, screenHeight - ALERT_BAR_HEIGHT, screenWidth, ALERT_BAR_HEIGHT);
    CGRect oldFrame = alertViewContainer.frame;
    void (^dismissAnimation)(void) = ^(void) {
        [UIView animateWithDuration:ANIMATION_DURATION animations:^{
            alertViewContainer.frame = oldFrame;
        } completion:^(BOOL finished) {
            [alertViewContainer removeFromSuperview];
        }];
    };
    
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        alertViewContainer.frame = newFrame;
    } completion:^(BOOL finished) {
        if (autodismiss && finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(ANIMATION_DURATION * NSEC_PER_SEC)), dispatch_get_main_queue(), dismissAnimation);
        }
    }];
}

@end
