//
//  KBPopupDrawableView.h
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

#import "KBPopupBubbleView.h"

//
// (1) Works best if kKBArrowHeight matches kKBDefaultMargin
// (2) kKBPopupArrowAdjustment is a slight adjustment to make animations work more smoothly
//
#define kKBPopupArrowMargin     18.0f
#define kKBPopupArrowWidth      16.0f
#define kKBPopupArrowHeight     8.0f
#define kKBPopupArrowAdjustment 1.0f

#pragma mark -
#pragma mark Arrow Delegate
@protocol KBPopupDrawableChildDelegate <NSObject>

@optional
- (BOOL)useRoundedCorners;
- (BOOL)useBorders;
- (BOOL)usePointerArrow;
- (CGFloat)borderWidth;
- (UIColor*)borderColor;
- (UIColor*)drawableColor;
- (NSUInteger)side;

@end

#pragma mark -
#pragma mark Arrow Interface 
@interface  KBPopupArrowView : UIView

@property (nonatomic, KB_WEAK) id<KBPopupDrawableChildDelegate> delegate;

@end

#pragma mark -
#pragma mark Cover Interface
@interface KBPopupCoverView : UIView 

@property (nonatomic, KB_WEAK) id<KBPopupDrawableChildDelegate> delegate;

@end

#pragma mark -
#pragma mark Drawable Interface
@interface KBPopupDrawableView : UIView

@property (nonatomic, strong) KBPopupArrowView *arrow;
@property (nonatomic, strong) KBPopupCoverView *cover;

@property (nonatomic, assign) BOOL useRoundedCorners;
@property (nonatomic, assign) BOOL useBorders;
@property (nonatomic, assign) BOOL usePointerArrow;

@property (nonatomic, assign)   NSUInteger side;
@property (nonatomic, assign)   CGFloat position;
@property (nonatomic, assign)   CGFloat cornerRadius;
@property (nonatomic, assign)   CGFloat borderWidth;
@property (nonatomic, readonly) CGFloat workingWidth;
@property (nonatomic, readonly) CGFloat workingHeight;

@property (nonatomic, strong) UIColor *drawableColor;
@property (nonatomic, strong) UIColor *borderColor;

- (void)updateArrow;

- (void)updateCover;

@end
