//
//  TTTCommons.h
//  TicTacToe
//
//  Created by Chia, Yi-Wei on 8/26/14.
//  Copyright (c) 2014 yiweic. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TTTSingleSqureState) {
    SingleSquareNone = 0x1112,
    SingleSquareCircle,
    SingleSquareCross
};

#define MAX_NUMBER_TTT 3