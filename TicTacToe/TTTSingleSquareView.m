//
//  TTTSingleSquareView.m
//  TicTacToe
//
//  Created by Chia, Yi-Wei on 8/25/14.
//  Copyright (c) 2014 yiweic. All rights reserved.
//

#import "TTTSingleSquareView.h"

static float const LINE_WIDTH = 5.0f;
static float const PADDING = 15.0f;

@implementation TTTSingleSquareView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _state = SingleSquareNone;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    CGContextSetLineWidth(context, LINE_WIDTH);
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    CGRect iconRect = CGRectMake(rect.origin.x + PADDING,
                                 rect.origin.y + PADDING,
                                 rect.size.width - PADDING * 2,
                                 rect.size.height - PADDING * 2);
    switch (self.state) {
        case SingleSquareCircle:
            CGContextAddEllipseInRect(context, iconRect);
            break;
        case SingleSquareCross:
            CGContextMoveToPoint(context, iconRect.origin.x, iconRect.origin.y);
            CGContextAddLineToPoint(context, iconRect.origin.x + iconRect.size.width, iconRect.origin.y + iconRect.size.height);
            
            CGContextMoveToPoint(context, iconRect.origin.x + iconRect.size.width, iconRect.origin.y);
            CGContextAddLineToPoint(context, iconRect.origin.x, iconRect.origin.y + iconRect.size.height);
            break;
        default:
            break;
    }
    CGContextAddRect(context, rect);
    CGContextStrokePath(context);
}

@end
