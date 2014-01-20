//
//  ViewController.m
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

#import "ViewController.h"

#import "PanelViewController.h"

#import "KBPopupBubbleView.h"

static const CGFloat kKBPanelMargin = 68.0f;

static const BOOL kKBViewControllerDebug = FALSE;

#pragma mark -
#pragma mark View Controller Interface
@interface ViewController () <PanelViewControllerDelegate, KBPopupBubbleViewDelegate>
{
    BOOL _useAnimations;
    BOOL _useColorsRotate;
    NSArray * _colors;
    NSArray * _colorsBorder;
    NSInteger _colorIndex;
}

@property (nonatomic, strong) PanelViewController * panel;
@property (nonatomic, strong) KBPopupBubbleView   * bubble;

@end

#pragma mark -
#pragma mark View Controller Implementation 
@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Add the control panel
    self.panel = [[PanelViewController alloc] init];
    self.panel.delegate = self;
    self.panel.view.frame = CGRectMake(self.panel.view.frame.origin.x,
                                       (-1) * (self.panel.view.frame.size.height - kKBPanelMargin),
                                       self.panel.view.frame.size.width,
                                       self.panel.view.frame.size.height);
    [self addChildViewController:self.panel];
    [self.view addSubview:self.panel.view];
    
    // Update model
    _useAnimations = TRUE;
    _useColorsRotate = TRUE;
    _colors = [NSArray arrayWithObjects:
                [UIColor colorWithRed:0.95f green:0.0f blue:0.0f alpha:1.0f],
                [UIColor colorWithRed:0.0f green:0.95f blue:0.0f alpha:1.0f],
                [UIColor colorWithRed:0.0f green:0.0f blue:0.95f alpha:1.0f],
                [UIColor colorWithRed:0.95f green:0.0f blue:0.95f alpha:1.0f],
                [UIColor colorWithRed:0.0f green:0.95f blue:0.95f alpha:1.0f],
                [UIColor colorWithRed:0.9f green:0.9f blue:0.0f alpha:1.0f],
                nil];
    _colorsBorder = [NSArray arrayWithObjects:
                     [UIColor colorWithRed:0.55f green:0.0f blue:0.0f alpha:1.0f],
                     [UIColor colorWithRed:0.0f green:0.55f blue:0.0f alpha:1.0f],
                     [UIColor colorWithRed:0.0f green:0.0f blue:0.55f alpha:1.0f],
                     [UIColor colorWithRed:0.55f green:0.0f blue:0.55f alpha:1.0f],
                     [UIColor colorWithRed:0.0f green:0.55f blue:0.55f alpha:1.0f],
                     [UIColor colorWithRed:0.55f green:0.55f blue:0.0f alpha:1.0f],
                     nil];
    _colorIndex = _colors.count - 1;
}

#pragma mark -
#pragma mark Event Handlers
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // Manage touches so that we can demonstrate the handlers in the KBPopupBubbleView
    CGPoint p = [[touches anyObject] locationInView:self.panel.view];
    if ( ![self.panel.view pointInside:p withEvent:event] ) {
        if ( self.bubble != nil ) {
            p = [[touches anyObject] locationInView:self.bubble];
            if ( ![self.bubble pointInside:p withEvent:event] ) {
                [self drawBubble:[[touches anyObject] locationInView:self.view]];
            }
        }
        else {
            [self drawBubble:[[touches anyObject] locationInView:self.view]];
        }
    }
}

- (void)drawBubble:(CGPoint)center {
    // Hide the bubble if its there
    if ( self.bubble != nil ) {
        [self.bubble hide:_useAnimations];
        self.bubble = nil;
    }
    
    // Display the new view
    self.bubble = [[KBPopupBubbleView alloc] initWithCenter:center];
    [self configure:self.bubble];
    [self.bubble showInView:self.view animated:_useAnimations];

    // Recycle panel
    [self.panel.view removeFromSuperview];
    [self.view addSubview:self.panel.view];
}

- (void)configure:(KBPopupBubbleView *)bubble {
    // Text
    bubble.label.text = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore.";
    bubble.label.textColor = [UIColor whiteColor];
    bubble.label.font = [UIFont boldSystemFontOfSize:13.0f];
    bubble.delegate = self;
    
    // Shadows
    bubble.useDropShadow = self.panel.shadow.on;
    
    // Corners
    bubble.useRoundedCorners = self.panel.corners.on;
    
    // Borders
    bubble.useBorders = self.panel.borders.on;
    
    // Draggable
    bubble.draggable = self.panel.draggable.on;
    
    // Side 
    switch ( self.panel.side.selectedSegmentIndex ) {
        case 0:
            [bubble setSide:kKBPopupPointerSideTop];
            break;
        case 1:
            [bubble setSide:kKBPopupPointerSideBottom];
            break;
        case 2:
            [bubble setSide:kKBPopupPointerSideLeft];
            break;
        case 3:
            [bubble setSide:kKBPopupPointerSideRight];
            break;
    }
    
    // Position
    switch ( self.panel.position1.selectedSegmentIndex ) {
        case 0:
            [bubble setPosition:kKBPopupPointerPositionLeft];
            break;
        case 1:
            [bubble setPosition:kKBPopupPointerPositionMiddle];
            break;
        case 2:
            [bubble setPosition:kKBPopupPointerPositionRight];
            break;
    }
    
    // Color
    if ( _useColorsRotate ) {
        _colorIndex++;
        if ( _colorIndex >= _colors.count ) {
            _colorIndex = 0;
        }
        
    }
    bubble.drawableColor = [_colors objectAtIndex:_colorIndex];
    bubble.borderColor = [_colorsBorder objectAtIndex:_colorIndex];
    
    // Demonstrate how a completion block works
    // (IMPORTANT: Use a weak reference here, otherwise you end up with a retain cycle and dealloc never gets called!)
    KB_WEAK_REF typeof(bubble) _weakBubble = bubble;
    void (^completion)(void) = ^{
        [_weakBubble setPosition:0.0f animated:YES];
    };
    [bubble setCompletionBlock:completion forAnimationKey:kKBPopupAnimationPopIn];
}

#pragma mark -
#pragma mark Protocol Delegate
- (CGFloat)margin {
    return kKBPanelMargin;
}

- (void)setAnimate:(BOOL)value {
    _useAnimations = value;
}

- (void)setShadow:(BOOL)value {
    [_bubble setUseDropShadow:value];
}

- (void)setCorners:(BOOL)value {
    [_bubble setUseRoundedCorners:value];
}

- (void)setBorders:(BOOL)value {
    [_bubble setUseBorders:value];
}

- (void)setPointerArrow:(BOOL)value {
    [_bubble setUsePointerArrow:value];
}

- (void)setDraggable:(BOOL)value {
    [_bubble setDraggable:value];
}

- (void)setColors:(BOOL)value {
    _useColorsRotate = value;
}

- (void)setSide:(NSUInteger)side {
    [_bubble setSide:side];
}

- (void)setPosition:(CGFloat)position {
    [_bubble setPosition:position];
}

- (void)setPosition:(CGFloat)position animated:(BOOL)animated {
    [_bubble setPosition:position animated:animated];
}

#pragma mark -
#pragma mark KBPopupBubbleViewDelegate
- (void)didTapBubbleTouchDown:(id)sender {
    // Implement delegate callback however you wish
    if ( kKBViewControllerDebug ) {
        DLog(@"++ Press Bubble DOWN");
    }
}

- (void)didTapBubbleTouchDrag:(id)sender {
    // Implement delegate callback however you wish
    if ( kKBViewControllerDebug ) {
        DLog(@"++ Press Bubble DRAG");
    }
}

- (void)didTapBubbleTouchUp:(id)sender {
    // Implement delegate callback however you wish
    if ( kKBViewControllerDebug ) {
        DLog(@"++ Press Bubble UP");
    }
}

@end
