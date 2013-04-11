//
//  KBPopupBubbleView.m
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

#import "KBPopupBubbleView.h"
#import "KBPopupBubbleView+Animations.h"
#import "KBPopupDrawableView.h"

static const CGFloat kKBDefaultWidth       = 200.0f;
static const CGFloat kKBDefaultHeight      = 120.0f;
static const CGFloat kKBDefaultMargin      = 8.0f;     // <-- works best if it matches kKBArrowHeight
static const CGFloat kKBDefaultPaddingTop  = 8.0f;
static const CGFloat kKBDefaultPaddingSide = 12.0f;

static const CGFloat kKBDefaultSlideDuration = 0.4f;

static const NSString * kKBAnimationKeyArrowPosition  = @"arrowPosition";
static const NSString * kKBAnimationKeyShadowPosition = @"shadowPosition";

#pragma mark -
#pragma mark Interface (Private)
@interface KBPopupBubbleView() 
{
    CGFloat _targetPosition;
    CGPoint _touch;
}

@property (nonatomic, strong) KBPopupDrawableView * drawable;
@property (nonatomic, strong) UIView * shadow;

// Class methods
+ (CGRect)defaultKBRectWithCenterPoint:(CGPoint)point;

// Instance methods
- (void)configure;
- (UIBezierPath*)configureShadowPathWithPosition:(CGFloat)position;

@end

#pragma mark -
#pragma mark Implementation
@implementation KBPopupBubbleView

#pragma mark -
#pragma mark Selectors
//
// SELECTORS
//
- (void)setUseDropShadow:(BOOL)useDropShadow {
    _useDropShadow = useDropShadow;
    [self configureShadow];
}

- (void)setUseRoundedCorners:(BOOL)useRoundedCorners {
    _useRoundedCorners = useRoundedCorners;
    if ( self.drawable != nil ) {
        self.drawable.useRoundedCorners = useRoundedCorners;
        self.drawable.cornerRadius = self.cornerRadius;
    }
    [self configureShadow];
}

- (void)setUseBorders:(BOOL)useBorders {
    _useBorders = useBorders;
    if ( self.drawable != nil ) {
        self.drawable.useBorders = useBorders;
    }
}

- (void)setDrawableColor:(UIColor *)drawableColor {
    _drawableColor = drawableColor;
    if ( self.drawable != nil ) {
        self.drawable.drawableColor = drawableColor;
    }
}

- (void)setPosition:(CGFloat)position {
    // Update model
    if ( position < 0.0f || position > 1.0f ) return;
    _position = position;
    if ( self.drawable != nil ) {
        self.drawable.position = position;
    }
    
    // Update views
    [self configureShadow];
}

- (void)setSide:(NSUInteger)side {
    // Update model
    if( side != kKBPopupPointerSideTop &&
        side != kKBPopupPointerSideBottom &&
        side != kKBPopupPointerSideLeft &&
        side != kKBPopupPointerSideRight ) return;
    _side = side;
    self.drawable.side = side;
    
    // Update views
    [self configureShadow];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    // Update model
    _cornerRadius = cornerRadius;
    if ( self.drawable != nil ) {
        self.drawable.cornerRadius = cornerRadius;
    }
    
    // Update views
    [self configureShadow];
}

- (void)setShadowColor:(UIColor *)shadowColor {
    _shadowColor = shadowColor;
    [self configureShadow];
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    if ( self.drawable != nil ) {
        self.drawable.borderColor = borderColor;
        [self.drawable updateCover];
        [self.drawable updateArrow];
    }
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    if ( self.drawable != nil ) {
        [self.drawable updateCover];
    }
}

- (void)setShadowOpacity:(CGFloat)shadowOpacity {
    _shadowOpacity = shadowOpacity;
    [self configureShadow];
}

- (void)setShadowRadius:(CGFloat)shadowRadius {
    _shadowRadius = shadowRadius;
    [self configureShadow];
}

- (void)setShadowOffset:(CGSize)shadowOffset {
    _shadowOffset = shadowOffset;
    [self configureShadow];
}

#pragma mark -
#pragma mark Constructors
//
// CONSTRUCTORS
//
- (id)init {
    CGRect r1 = [UIScreen mainScreen].bounds;
    CGPoint p1 = CGPointMake(r1.origin.x + r1.size.width/2.0f, r1.origin.y + r1.size.height/2.0f);
    self = [super initWithFrame:[KBPopupBubbleView defaultKBRectWithCenterPoint:p1]];
    if ( self ) {
        [self configure];
    }
    return self;
}

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

- (id)initWithCenter:(CGPoint)center {
    self = [super initWithFrame:[KBPopupBubbleView defaultKBRectWithCenterPoint:center]];
    if ( self ) {
        [self configure];
    }
    return self;
}

- (void)configure {
    self.backgroundColor = [UIColor clearColor];
    self.drawableColor   = kKBPopupDefaultDrawableColor;
    
    _margin      = kKBDefaultMargin;
    _paddingSide = kKBDefaultPaddingSide;
    _paddingTop  = kKBDefaultPaddingTop;
    _position    = kKBPopupDefaultPosition;
    _side        = kKBPopupDefaultSide;
    
    _cornerRadius       = kKBPopupDefaultCornerRadius;
    _animationDuration  = kKBPopupDefaultAnimationDuration;
    _shadowOpacity      = kKBPopupDefaultShadowOpacity;
    _shadowRadius       = kKBPopupDefaultShadowRadius;
    _shadowOffset       = kKBPopupDefaultShadowOffset;
    _shadowColor        = kKBPopupDefaultShadowBackgroundColor;
    _borderColor        = kKBPopupDefaultBorderColor;
    _borderWidth        = kKBPopupDefaultBorderWidth;
    
    CGRect rect1 = CGRectMake(self.margin,
                              self.margin,
                              self.frame.size.width - 2 * self.margin,
                              self.frame.size.height - 2 * self.margin);
    self.drawable = [[KBPopupDrawableView alloc] initWithFrame:rect1];
    self.drawable.position = self.position;
    self.drawable.drawableColor = self.drawableColor;

    self.shadow = [[UIView alloc] initWithFrame:rect1];
    self.shadow.backgroundColor = [UIColor clearColor];
    
    CGRect rect2 = self.drawable.bounds;
    CGRect rect3 = CGRectMake(_paddingSide,
                              _paddingTop,
                              rect2.size.width - 2 * _paddingSide,
                              rect2.size.height - 2 * _paddingTop);
    self.label = [[UILabel alloc] initWithFrame:rect3];
    self.label.backgroundColor = [UIColor clearColor];
    self.label.numberOfLines = 0;
    [self.drawable addSubview:self.label];
    
    self.useDropShadow = kKBPopupDefaultUseDropShadow;
    self.useRoundedCorners = kKBPopupDefaultUseRoundedCorners;
    self.useBorders = kKBPopupDefaultUseBorders;
    self.draggable = kKBPopupDefaultDraggable;
    
    self.userInteractionEnabled = YES;
    
    [self addSubview:self.shadow];
    [self addSubview:self.drawable];
}

- (void)configureShadow {
    if ( self.shadow != nil && self.drawable.arrow != nil ) {
        self.shadow.layer.shadowColor = self.shadowColor.CGColor;
        self.shadow.layer.shadowOpacity = (self.useDropShadow == YES) ? self.shadowOpacity : 0.0f;
        self.shadow.layer.shadowRadius = self.shadowRadius;
        self.shadow.layer.shadowOffset = self.shadowOffset;
        self.shadow.layer.shadowPath = [self configureShadowPathWithPosition:self.position].CGPath;
        self.shadow.layer.masksToBounds = NO;
    }
}

- (UIBezierPath*)configureShadowPathWithPosition:(CGFloat)position {
    if ( self.drawable != nil ) {
        // Get the variables
        CGFloat base = kKBPopupArrowWidth / 2.0f;
        CGRect rect1 = self.drawable.arrow.frame;
        CGFloat targetX = 0.0;
        CGFloat targetY = 0.0;
        switch ( self.side) {
            case kKBPopupPointerSideTop:
            case kKBPopupPointerSideBottom:
                targetX = kKBPopupArrowMargin + self.drawable.workingWidth * position;
                targetY = rect1.origin.y;
                break;
            case kKBPopupPointerSideLeft:
            case kKBPopupPointerSideRight:
                targetX = rect1.origin.x;
                targetY = kKBPopupArrowMargin + self.drawable.workingHeight * position;
                break;
        }
        
        // Configure the Bezier Path
        UIBezierPath *path = self.useRoundedCorners ? [UIBezierPath bezierPathWithRoundedRect:self.shadow.bounds cornerRadius:self.cornerRadius] : [UIBezierPath bezierPathWithRect:self.shadow.bounds];
        switch ( self.side ) {
            case kKBPopupPointerSideTop:
                [path moveToPoint:CGPointMake(targetX, targetY + kKBPopupArrowHeight)];
                [path addLineToPoint:CGPointMake(targetX + base, targetY)];
                [path addLineToPoint:CGPointMake(targetX + 2 * base, targetY + kKBPopupArrowHeight)];
                break;
            case kKBPopupPointerSideBottom:
                [path moveToPoint:CGPointMake(targetX, targetY)];
                [path addLineToPoint:CGPointMake(targetX + base, targetY + kKBPopupArrowHeight)];
                [path addLineToPoint:CGPointMake(targetX + 2 * base, targetY)];
                break;
            case kKBPopupPointerSideLeft:
                [path moveToPoint:CGPointMake(targetX + kKBPopupArrowHeight, targetY)];
                [path addLineToPoint:CGPointMake(targetX, targetY + base)];
                [path addLineToPoint:CGPointMake(targetX + kKBPopupArrowHeight, targetY + 2 * base)];
                break;
            case kKBPopupPointerSideRight:
                [path moveToPoint:CGPointMake(targetX,targetY)];
                [path addLineToPoint:CGPointMake(targetX + kKBPopupArrowHeight, targetY + base)];
                [path addLineToPoint:CGPointMake(targetX, targetY + 2 * base)];
                break;
        }
        [path closePath];
        
        return path;
    }
    return nil;
}

// Class methods
+ (CGRect)defaultKBRectWithCenterPoint:(CGPoint)point {
    return CGRectMake(point.x - kKBDefaultWidth/2.0f,
                      point.y - kKBDefaultHeight/2.0f,
                      kKBDefaultWidth,
                      kKBDefaultHeight);
}

- (void)dealloc {
    _drawable = nil;
    _drawableColor = nil;
    _shadow = nil;
    _shadowColor = nil;
    _borderColor = nil;
}

#pragma mark -
#pragma mark View Lifecycle
// View Lifecycle
- (void)showInView:(UIView*)target animated:(BOOL)animated {
    [target addSubview:self];
    if ( animated ) {
        [self popIn];
    }
}

- (void)hide:(BOOL)animated {
    if ( animated ) {
        [self popOut];
    } else {
        [self removeFromSuperview];
    }
}

// Adjust Position
- (void)setPosition:(CGFloat)position animated:(BOOL)animated {
    if ( position < 0.0f || position > 1.0f ) return;

    if ( !animated ) {
        self.position = position;
    } else {
        // Get stats for the arrow rect
        _targetPosition = position;
        CGRect rect1 = self.drawable.arrow.frame;
        CGFloat targetX = 0.0;
        CGFloat targetY = 0.0;
        switch ( self.side ) {
            case kKBPopupPointerSideTop:
            case kKBPopupPointerSideBottom:
                targetX = kKBPopupArrowMargin + kKBPopupArrowWidth/2.0f + self.drawable.workingWidth * position;
                targetY = rect1.origin.y + rect1.size.height/2.0f;
                break;
            case kKBPopupPointerSideLeft:
            case kKBPopupPointerSideRight:
                targetX = rect1.origin.x + rect1.size.width/2.0f;
                targetY = kKBPopupArrowMargin + kKBPopupArrowWidth/2.0f + self.drawable.workingHeight * position;
                break;
        }
        
        // Configure first animation
        CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"position"];
        animation1.duration = kKBDefaultSlideDuration;
        animation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        animation1.toValue = [NSValue valueWithCGPoint:CGPointMake(targetX, targetY)];
        animation1.removedOnCompletion = NO;
        animation1.fillMode = kCAFillModeForwards;
        animation1.delegate = self;
        
        // Configure second animation
        CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"shadowPath"];
        animation2.duration = kKBDefaultSlideDuration;
        animation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        animation2.toValue = (id)[self configureShadowPathWithPosition:position].CGPath;
        animation2.removedOnCompletion = NO;
        animation2.fillMode = kCAFillModeForwards;
        animation2.delegate = self;
        
        [self.drawable.arrow.layer addAnimation:animation1 forKey:(NSString*)kKBAnimationKeyArrowPosition];
        [self.shadow.layer addAnimation:animation2 forKey:(NSString*)kKBAnimationKeyShadowPosition];
    }
}

#pragma mark -
#pragma mark CAAnimation Delegate
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
    // ARROW MOVE
    if ( theAnimation == [self.drawable.arrow.layer animationForKey:(NSString*)kKBAnimationKeyArrowPosition] ) {
        [self setPosition:_targetPosition];
        [self.drawable.arrow.layer removeAllAnimations];
    }
    
    // SHADOW MOVE
    if ( theAnimation == [self.shadow.layer animationForKey:(NSString*)kKBAnimationKeyShadowPosition] ) {
        [self.shadow.layer removeAllAnimations];
    }
    
    // POP IN
    if ( theAnimation == [self.layer animationForKey:(NSString*)kKBPopupAnimationPopIn] ) {
        [self.layer removeAllAnimations];
    }
    
    // POP OUT
    if ( theAnimation == [self.layer animationForKey:(NSString*)kKBPopupAnimationPopOut] ) {
        [self removeFromSuperview];
        [self.layer removeAllAnimations];
    }
}

#pragma mark -
#pragma mark Event Handlers
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint p1 = [[touches anyObject] locationInView:self];
    CGPoint p2 = [[touches anyObject] locationInView:self.superview];
    
    // Signal to delegate
    if ( self.delegate != nil && [self.delegate respondsToSelector:@selector(didTapBubbleTouchDown:)] ) {
        if( [self pointInside:p1 withEvent:event] ) {
            [self.delegate didTapBubbleTouchDown:self];
        }
    }
    
    // Save for dragging
    if ( self.draggable ) {
        _touch = p2;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint p1 = [[touches anyObject] locationInView:self];
    CGPoint p2 = [[touches anyObject] locationInView:self.superview];
    
    // Signal to delegate
    if ( self.delegate != nil && [self.delegate respondsToSelector:@selector(didTapBubbleTouchDrag:)] ) {
        if( [self pointInside:p1 withEvent:event] ) {
            [self.delegate didTapBubbleTouchDrag:self];
        }
    }
    
    if ( self.draggable ) {
        // Perform the drag
        CGFloat dx = p2.x - _touch.x, dy = p2.y - _touch.y;
        CGFloat nx = self.frame.origin.x + dx;
        CGFloat ny = self.frame.origin.y + dy;
        self.frame = CGRectMake(nx, ny, self.frame.size.width, self.frame.size.height);
    
        // Update for dragging
        _touch = p2;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if ( self.delegate != nil && [self.delegate respondsToSelector:@selector(didTapBubbleTouchUp:)] ) {
        CGPoint p = [[touches anyObject] locationInView:self];
        if ( [self pointInside:p withEvent:event] ) {
            [self.delegate didTapBubbleTouchUp:self];
        }
    }
}

@end
