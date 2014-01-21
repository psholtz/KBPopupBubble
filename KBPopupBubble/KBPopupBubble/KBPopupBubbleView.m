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

#pragma mark -
#pragma mark Internal Interface
@interface KBPopupBubbleView() 

@property (nonatomic, strong) KBPopupDrawableView * drawable;
@property (nonatomic, strong) UIView * shadow;
@property (nonatomic, assign) CGFloat targetPosition;
@property (nonatomic, assign) CGPoint touch;
@property (nonatomic, strong) NSMutableDictionary * completionBlocks;

@end

#pragma mark -
#pragma mark Implementation
@implementation KBPopupBubbleView

#pragma mark -
#pragma mark Selectors
//
// SELECTORS
//

// POSITIONS
- (void)setPosition:(CGFloat)position {
    // Update model
    if ( position < 0.0f || position > 1.0f ) return;
    _position = position;
    [[self drawable] setPosition:position];
    
    // Update views
    [self configureShadow];
}

// BOOLEAN
- (void)setUseDropShadow:(BOOL)useDropShadow {
    _useDropShadow = useDropShadow;
    [self configureShadow];
}

- (void)setUseRoundedCorners:(BOOL)useRoundedCorners {
    _useRoundedCorners = useRoundedCorners;
    [[self drawable] setUseRoundedCorners:useRoundedCorners];
    [[self drawable] setCornerRadius:[self cornerRadius]];
    [self configureShadow];
}

- (void)setUseBorders:(BOOL)useBorders {
    _useBorders = useBorders;
    [[self drawable] setUseBorders:useBorders];
}

- (void)setUsePointerArrow:(BOOL)usePointerArrow {
    // Update present object
    _usePointerArrow = usePointerArrow;
    [self configureShadow];
    
    // Update drawable object
    [[self drawable] setUsePointerArrow:usePointerArrow];
    [[self drawable] updateCover];
    [[self drawable] updateArrow];
}

// COLORS
- (void)setDrawableColor:(UIColor *)drawableColor {
    _drawableColor = drawableColor;
    [[self drawable] setDrawableColor:drawableColor];
}

- (void)setShadowColor:(UIColor *)shadowColor {
    _shadowColor = shadowColor;
    [self configureShadow];
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    [[self drawable] setBorderColor:borderColor];
    [[self drawable] updateCover];
    [[self drawable] updateArrow];
}

//
// Override background color, so that drawable color and
// background color are the "same" (this is, intuitively,
// how most people will probably anticipate using this
// attribute).
//
- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:[UIColor clearColor]];
    [self setDrawableColor:backgroundColor];
}

// DIMENSIONS
- (void)setShadowOffset:(CGSize)shadowOffset {
    _shadowOffset = shadowOffset;
    [self configureShadow];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    // Update model
    _cornerRadius = cornerRadius;
    [[self drawable] setCornerRadius:cornerRadius];
    [[self drawable] updateCover];
    
    // Update views
    [self configureShadow];
}

- (void)setShadowOpacity:(CGFloat)shadowOpacity {
    _shadowOpacity = shadowOpacity;
    [self configureShadow];
}

- (void)setShadowRadius:(CGFloat)shadowRadius {
    // Bail, but gently notify the user
    CGFloat targetRadius = shadowRadius;
    if ( shadowRadius < kKBPopupMinimumShadowRadius ) {
        ALog(@"[KBPopupBubbleView]: Attempting to set shadow radius to: %f", shadowRadius);
        ALog(@"[KBPopupBubbleView]: Values less than %f lead to strange-looking UIs, hence setting to minimum.", kKBPopupMinimumShadowRadius);
        targetRadius = kKBPopupMinimumShadowRadius;
    }
    
    // Update the shadow radius
    _shadowRadius = targetRadius;
    [self configureShadow];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    [[self drawable] setBorderWidth:borderWidth];
    [[self drawable] updateCover];
}

- (void)setSide:(NSUInteger)side {
    // Update model
    if( side != kKBPopupPointerSideTop &&
        side != kKBPopupPointerSideBottom &&
        side != kKBPopupPointerSideLeft &&
        side != kKBPopupPointerSideRight ) return;
    _side = side;
    [[self drawable] setSide:side];
    
    // Update views
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
        [self configureWithDefaults:YES];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if ( self ) {
        [self configureWithDefaults:YES];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if ( self ) {
        [self configureWithDefaults:YES];
    }
    return self;
}

- (id)initWithCenter:(CGPoint)center {
    self = [super initWithFrame:[KBPopupBubbleView defaultKBRectWithCenterPoint:center]];
    if ( self ) {
        [self configureWithDefaults:YES];
    }
    return self;
}

- (void)configureWithDefaults:(BOOL)useDefaults {
    [self setBackgroundColor:[UIColor clearColor]];
    
    if ( useDefaults ) {
        _drawableColor  = kKBPopupDefaultDrawableColor;
        _margin         = kKBDefaultMargin;
        _paddingSide    = kKBDefaultPaddingSide;
        _paddingTop     = kKBDefaultPaddingTop;
        _position       = kKBPopupDefaultPosition;
        _side           = kKBPopupDefaultSide;
        
        _cornerRadius       = kKBPopupDefaultCornerRadius;
        _animationDuration  = kKBPopupDefaultAnimationDuration;
        _shadowOpacity      = kKBPopupDefaultShadowOpacity;
        _shadowRadius       = kKBPopupDefaultShadowRadius;
        _shadowOffset       = kKBPopupDefaultShadowOffset;
        _shadowColor        = kKBPopupDefaultShadowBackgroundColor;
        _borderColor        = kKBPopupDefaultBorderColor;
        _borderWidth        = kKBPopupDefaultBorderWidth;
        
        _completionBlocks     = [[NSMutableDictionary alloc] init];
        _completionBlockDelay = kKBPopupDefaultCompletionDelay;
    }
    
    CGRect rect1 = CGRectMake(_margin,
                              _margin,
                              [self frame].size.width - 2 * _margin,
                              [self frame].size.height - 2 * _margin);
    _drawable = [[KBPopupDrawableView alloc] initWithFrame:rect1];
    _drawable.position = _position;
    _drawable.drawableColor = _drawableColor;

    _shadow = [[UIView alloc] initWithFrame:rect1];
    _shadow.backgroundColor = [UIColor clearColor];
    
    CGRect rect2 = _drawable.bounds;
    CGRect rect3 = CGRectMake(_paddingSide,
                              _paddingTop,
                              rect2.size.width - 2 * _paddingSide,
                              rect2.size.height - 2 * _paddingTop);
    _label = [[UILabel alloc] initWithFrame:rect3];
    _label.backgroundColor = [UIColor clearColor];
    _label.numberOfLines = 0;
    [_drawable addSubview:_label];
    
    if ( useDefaults ) {
        [self setUseDropShadow:kKBPopupDefaultUseDropShadow];
        [self setUseRoundedCorners:kKBPopupDefaultUseRoundedCorners];
        [self setUseBorders:kKBPopupDefaultUseBorders];
        [self setUsePointerArrow:kKBPopupDefaultUsePointerArrow];
        [self setDraggable:kKBPopupDefaultDraggable];
    }
        
    [self setUserInteractionEnabled:YES];
    
    [self addSubview:_shadow];
    [self addSubview:_drawable];
}

- (void)configureShadow {
    if ( _shadow != nil && _drawable.arrow != nil ) {
        _shadow.layer.shadowColor   = _shadowColor.CGColor;
        _shadow.layer.shadowOpacity = ([self useDropShadow] == YES) ? _shadowOpacity : 0.0f;
        _shadow.layer.shadowRadius  = _shadowRadius;
        _shadow.layer.shadowOffset  = _shadowOffset;
        _shadow.layer.shadowPath    = [self configureShadowPathWithPosition:_position].CGPath;
        _shadow.layer.masksToBounds = NO;
    }
}

- (UIBezierPath*)configureShadowPathWithPosition:(CGFloat)position {
    if ( _drawable != nil ) {
        // Get the variables
        CGFloat base = kKBPopupArrowWidth / 2.0f;
        CGRect rect1 = _drawable.arrow.frame;
        CGFloat targetX = 0.0;
        CGFloat targetY = 0.0;
        switch ( _side) {
            case kKBPopupPointerSideTop:
            case kKBPopupPointerSideBottom:
                targetX = kKBPopupArrowMargin + _drawable.workingWidth * position;
                targetY = rect1.origin.y;
                break;
            case kKBPopupPointerSideLeft:
            case kKBPopupPointerSideRight:
                targetX = rect1.origin.x;
                targetY = kKBPopupArrowMargin + _drawable.workingHeight * position;
                break;
        }
        
        // Configure the Bezier Path
        UIBezierPath *path = _useRoundedCorners ? [UIBezierPath bezierPathWithRoundedRect:_shadow.bounds cornerRadius:_cornerRadius] : [UIBezierPath bezierPathWithRect:_shadow.bounds];
        if ( _usePointerArrow ) {
            switch ( _side ) {
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
        self.targetPosition = position;
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
    // COMPLETION BLOCK
    void (^completionBlock)(void) = nil;
    
    // ARROW MOVE
    if ( theAnimation == [self.drawable.arrow.layer animationForKey:(NSString*)kKBAnimationKeyArrowPosition] ) {
        [self setPosition:self.targetPosition];
        [self.drawable.arrow.layer removeAllAnimations];
        completionBlock = [_completionBlocks objectForKey:(NSString*)kKBAnimationKeyArrowPosition];
    }
    
    // SHADOW MOVE
    if ( theAnimation == [self.shadow.layer animationForKey:(NSString*)kKBAnimationKeyShadowPosition] ) {
        [self.shadow.layer removeAllAnimations];
        completionBlock = [_completionBlocks objectForKey:(NSString*)kKBAnimationKeyShadowPosition];
    }
    
    // POP IN
    if ( theAnimation == [self.layer animationForKey:(NSString*)kKBPopupAnimationPopIn] ) {
        [self.layer removeAllAnimations];
        completionBlock = [_completionBlocks objectForKey:(NSString*)kKBPopupAnimationPopIn];
    }
    
    // POP OUT
    if ( theAnimation == [self.layer animationForKey:(NSString*)kKBPopupAnimationPopOut] ) {
        [self removeFromSuperview];
        [self.layer removeAllAnimations];
        completionBlock = [_completionBlocks objectForKey:(NSString*)kKBPopupAnimationPopOut];
    }
    
    if ( completionBlock != nil ) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, self.completionBlockDelay * NSEC_PER_SEC) , dispatch_get_current_queue(), ^{
            completionBlock();
        });
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
        self.touch = p2;
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
        CGFloat dx = p2.x - self.touch.x, dy = p2.y - self.touch.y;
        CGFloat nx = self.frame.origin.x + dx;
        CGFloat ny = self.frame.origin.y + dy;
        self.frame = CGRectMake(nx, ny, self.frame.size.width, self.frame.size.height);
    
        // Update for dragging
        self.touch = p2;
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

#pragma mark -
#pragma mark Completion Blocks
//
// Completion Blocks
//
- (void)setCompletionBlock:(KBPopupBubbleCompletionBlock)completion forAnimationKey:(NSString*)animation {
    if ( self.completionBlocks != nil ) {
        [self.completionBlocks setObject:completion forKey:animation];
    }
}

- (void)removeCompletionBlock:(NSString*)animation {
    if ( self.completionBlocks != nil ) {
        [self.completionBlocks removeObjectForKey:animation];
    }
}

@end
