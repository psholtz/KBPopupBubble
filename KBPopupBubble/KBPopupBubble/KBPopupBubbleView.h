//
//  KBPopupBubbleView.h
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

#import "KBPopupHeaders.h"

typedef void (^KBPopupBubbleCompletionBlock)(void);

// Placeholder constants for user to use, for simplicity
#define kKBPopupPointerPositionLeft       0.0f
#define kKBPopupPointerPositionMiddle     0.5f
#define kKBPopupPointerPositionRight      1.0f

#define kKBPopupPointerPositionTop        0.0f
#define kKBPopupPointerPositionBottom     1.0f

// Animation constants
#define kKBPopupAnimationPopIn          @"kKBPopupAnimationPopIn"
#define kKBPopupAnimationPopOut         @"kKBPopupAnimationPopOut"
#define kKBAnimationKeyArrowPosition    @"arrowPosition"
#define kKBAnimationKeyShadowPosition   @"shadowPosition"

// Which side of the bubble to render the pointer
enum {
    kKBPopupPointerSideTop,
    kKBPopupPointerSideBottom,
    kKBPopupPointerSideLeft,
    kKBPopupPointerSideRight,
};

//
// Defaults to help during construction
//
#define kKBPopupDefaultUseDropShadow         YES
#define kKBPopupDefaultUseRoundedCorners     YES
#define kKBPopupDefaultUseBorders            YES
#define kKBPopupDefaultUseGradient           YES
#define kKBPopupDefaultUsePointerArrow       YES
#define kKBPopupDefaultDraggable             YES
#define kKBPopupDefaultShadowBackgroundColor [UIColor blackColor]
#define kKBPopupDefaultDrawableColor         [UIColor colorWithRed:0.95f green:0.0f blue:0.0f alpha:1.0f]
#define kKBPopupDefaultBorderColor           [UIColor blackColor]
#define kKBPopupDefaultShadowOpacity         0.4f
#define kKBPopupDefaultShadowRadius          3.0f
#define kKBPopupMinimumShadowRadius          3.0f
#define kKBPopupDefaultCornerRadius          12.0f
#define kKBPopupDefaultAnimationDuration     0.4f
#define kKBPopupDefaultBorderWidth           4.0f
#define kKBPopupDefaultCompletionDelay       0.2f
#define kKBPopupDefaultShadowOffset          CGSizeMake(5.0f, 5.0f)
#define kKBPopupDefaultPosition              kKBPopupPointerPositionMiddle
#define kKBPopupDefaultSide                  kKBPopupPointerSideTop

#pragma mark -
#pragma mark Delegate Protocol
@protocol KBPopupBubbleViewDelegate <NSObject>

@optional
- (void)didTapBubbleTouchDown:(id)sender;
- (void)didTapBubbleTouchDrag:(id)sender;
- (void)didTapBubbleTouchUp:(id)sender;

@end

#pragma mark -
#pragma mark Interface (Public)
@interface KBPopupBubbleView : UIView

@property (nonatomic, assign)   CGFloat position;
@property (nonatomic, readonly) CGFloat margin;
@property (nonatomic, readonly) CGFloat paddingSide;
@property (nonatomic, readonly) CGFloat paddingTop;

@property (nonatomic, assign) BOOL useDropShadow;
@property (nonatomic, assign) BOOL useRoundedCorners;
@property (nonatomic, assign) BOOL useBorders;
@property (nonatomic, assign) BOOL usePointerArrow;

@property (nonatomic, assign) BOOL draggable;

@property (nonatomic, strong) UIColor * drawableColor;  
@property (nonatomic, strong) UIColor * shadowColor;
@property (nonatomic, strong) UIColor * borderColor;

@property (nonatomic, assign) CGSize  shadowOffset;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, assign) CGFloat shadowOpacity;
@property (nonatomic, assign) CGFloat shadowRadius;          
@property (nonatomic, assign) CGFloat borderWidth;           
@property (nonatomic, assign) NSUInteger side;

@property (nonatomic, strong) UILabel * label;

@property (nonatomic, assign) CGFloat completionBlockDelay;

@property (nonatomic, assign) id<KBPopupBubbleViewDelegate> delegate;

// ================
// PUBLIC INTERFACE
// ================

// Constructors
- (id)initWithCenter:(CGPoint)center;

// View Lifecycle
- (void)showInView:(UIView*)target animated:(BOOL)animated;

- (void)hide:(BOOL)animated;

// Adjust Position
- (void)setPosition:(CGFloat)position animated:(BOOL)animated;

//
// Completion Blocks
//
/**
 * To use the completion blocks, pass in a block with signature (void (^)(void)) for binding
 * with an animation key. The animation key should be a constant identifying one of the four
 * animations supported by the bubble, specifically those define above in macros:
 *
 *  kKBPopupAnimationPopIn
 *  kKBPopupAnimationPopOut
 *  kKBAnimationKeyArrowPosition
 *  kKBAnimationKeyShadowPosition
 *
 * For instance, binding a completion block with the key kKBPopupAnimationPopIn will cause that 
 * block to run when the "pop in" animation sequence terminates.
 */
- (void)setCompletionBlock:(KBPopupBubbleCompletionBlock)completion forAnimationKey:(NSString*)animationKey;

- (void)removeCompletionBlock:(NSString*)animationKey;

@end
