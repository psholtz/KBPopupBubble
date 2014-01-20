//
//  KBPopupDrawableView.m
//  KBPopupBubble
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without restriction,
//  including without limitation the rights to use, copy, modify, merge,
//  publish, distribute, sublicense, and/or sell copies of the Software,
//  and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
//  CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
//  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
//  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//  Created by Paul Sholtz on 4/6/13.
//

#import <QuartzCore/QuartzCore.h>

#import "KBPopupDrawableView.h"

#pragma mark -
#pragma mark Implementation (Arrow View)
@implementation KBPopupArrowView

// Draw pointer arrow
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if ( self.delegate != nil ) {
        switch ( [self.delegate side] ) {
            case kKBPopupPointerSideTop:
                CGContextMoveToPoint(context, -kKBPopupArrowAdjustment, kKBPopupArrowHeight + kKBPopupArrowAdjustment);
                CGContextAddLineToPoint(context, kKBPopupArrowWidth/2.0f, 0.0f);
                CGContextAddLineToPoint(context, kKBPopupArrowWidth + kKBPopupArrowAdjustment, kKBPopupArrowHeight + kKBPopupArrowAdjustment);
                break;
            case kKBPopupPointerSideBottom:
                CGContextMoveToPoint(context, -kKBPopupArrowAdjustment, 0.0f);
                CGContextAddLineToPoint(context, kKBPopupArrowWidth/2.0f, kKBPopupArrowHeight + kKBPopupArrowAdjustment);
                CGContextAddLineToPoint(context, kKBPopupArrowWidth + kKBPopupArrowAdjustment, 0.0f);
                break;
            case kKBPopupPointerSideLeft:
                CGContextMoveToPoint(context, kKBPopupArrowHeight + kKBPopupArrowAdjustment, -kKBPopupArrowAdjustment);
                CGContextAddLineToPoint(context, 0.0f, kKBPopupArrowWidth/2.0f);
                CGContextAddLineToPoint(context, kKBPopupArrowHeight + kKBPopupArrowAdjustment, kKBPopupArrowWidth + kKBPopupArrowAdjustment);
                break;
            case kKBPopupPointerSideRight:
                CGContextMoveToPoint(context, 0.0f, -kKBPopupArrowAdjustment);
                CGContextAddLineToPoint(context, kKBPopupArrowHeight + kKBPopupArrowAdjustment, kKBPopupArrowWidth/2.0f);
                CGContextAddLineToPoint(context, 0.0f, kKBPopupArrowWidth + kKBPopupArrowAdjustment);
                break;
        }
                
        UIColor * targetColor = [self.delegate usePointerArrow] ? ([self.delegate useBorders] ? [self.delegate borderColor] : [self.delegate drawableColor]) : [UIColor clearColor];
        CGContextSetFillColorWithColor(context, targetColor.CGColor);
    }

    CGContextFillPath(context);
}

@end

#pragma mark -
#pragma mark Implementation (Cover View)
@implementation KBPopupCoverView

@end

#pragma mark -
#pragma mark Internal Interface
@interface KBPopupDrawableView() <KBPopupDrawableChildDelegate>

@end

#pragma mark -
#pragma mark Implementation (Drawable View)
@implementation KBPopupDrawableView

#pragma mark -
#pragma mark Getter/Setters
//
// GETTERS AND SETTERS
//
- (void)setUseRoundedCorners:(BOOL)useRoundedCorners {
    _useRoundedCorners = useRoundedCorners;
    [self updateCover];
}

- (void)setUseBorders:(BOOL)useBorders {
    _useBorders = useBorders;
    [self updateCover];
    [self updateArrow];
}

- (void)setUsePointerArrow:(BOOL)usePointerArrow {
    _usePointerArrow = usePointerArrow;
    [self updateCover];
    [self updateArrow];
}

- (void)setSide:(NSUInteger)side {
    _side = side;
    [self updateArrow];
}
- (void)setPosition:(CGFloat)position {
    _position = position;
    [self updateArrow];
}

- (CGFloat)workingWidth {
    return self.frame.size.width - 2 * kKBPopupArrowMargin - kKBPopupArrowWidth;;
}

- (CGFloat)workingHeight {
    return self.frame.size.height - 2 * kKBPopupArrowMargin - kKBPopupArrowWidth;
}

- (void)setDrawableColor:(UIColor *)drawableColor {
    _drawableColor = drawableColor;
    [[self cover] setBackgroundColor:drawableColor];
    [self updateCover];
    [self updateArrow];
}

#pragma mark -
#pragma mark Constructors
//
// CONSTRUCTORS
//
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if ( self ) {
        [self configure];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if ( self ) {
        [self configure];
    }
    return self;
}

- (void)configure {
    // Configure colors
    self.drawableColor = kKBPopupDefaultDrawableColor;
    self.borderColor   = kKBPopupDefaultBorderColor;
    self.borderWidth   = kKBPopupDefaultBorderWidth;
    
    // Configure pointer arrow
    self.arrow = [[KBPopupArrowView alloc] initWithFrame:[self rectForPosition:_position]];
    self.arrow.backgroundColor = [UIColor clearColor];
    self.arrow.delegate = self;
    [self addSubview:self.arrow];
    
    // Configure the cover
    self.cover = [[KBPopupCoverView alloc] initWithFrame:self.bounds];
    self.cover.backgroundColor = self.drawableColor;
    self.cover.delegate = self;
    [self addSubview:self.cover];
    
    // Configure the corners
    [self updateCover];
}

- (CGRect)rectForPosition:(CGFloat)position {
    // Calculate dimensions based on current position
    CGFloat X = 0.0f;
    CGFloat Y = 0.0f;
    
    CGRect rect = CGRectZero;
    switch ( self.side ) {
        case kKBPopupPointerSideTop:
            X = kKBPopupArrowMargin + self.workingWidth * position;
            Y = (-1) * kKBPopupArrowHeight;
            rect = CGRectMake(X, Y, kKBPopupArrowWidth, kKBPopupArrowHeight + kKBPopupArrowAdjustment);
            break;
        case kKBPopupPointerSideBottom:
            X = kKBPopupArrowMargin + self.workingWidth * position;
            Y = self.frame.size.height - kKBPopupArrowAdjustment;
            rect = CGRectMake(X, Y, kKBPopupArrowWidth, kKBPopupArrowHeight + kKBPopupArrowAdjustment);
            break;
        case kKBPopupPointerSideLeft:
            X = (-1) * kKBPopupArrowHeight;
            Y = kKBPopupArrowMargin + self.workingHeight * position;
            rect = CGRectMake(X, Y, kKBPopupArrowHeight + kKBPopupArrowAdjustment, kKBPopupArrowWidth);
            break;
        case kKBPopupPointerSideRight:
            X = self.frame.size.width - kKBPopupArrowAdjustment;
            Y = kKBPopupArrowMargin + self.workingHeight * position;
            rect = CGRectMake(X, Y, kKBPopupArrowHeight + kKBPopupArrowAdjustment, kKBPopupArrowWidth);
            break;
    }
    
    // Return the rect
    return rect;
}

#pragma mark -
#pragma mark External Methods
- (void)updateArrow {
    self.arrow.frame = [self rectForPosition:_position];
    [self.arrow setNeedsDisplay];
}

- (void)updateCover {
    // Rounded corners
    self.cover.layer.cornerRadius = self.useRoundedCorners ? self.cornerRadius : 0.0f;
    self.cover.clipsToBounds = YES;
    
    // Border
    self.cover.layer.borderColor = self.useBorders ?  [self borderColor].CGColor : [UIColor clearColor].CGColor;
    self.cover.layer.borderWidth = self.useBorders ?  [self borderWidth] : 0.0f;
}

@end
