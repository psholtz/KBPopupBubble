//
//  PanelViewController.h
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

#pragma mark -
#pragma mark Panel View Controller Protocol
@protocol PanelViewControllerDelegate <NSObject>

// Wrappers for the KBPopupView
@required
- (void)setAnimate:(BOOL)value;
- (void)setShadow:(BOOL)value;
- (void)setCorners:(BOOL)value;
- (void)setBorders:(BOOL)value;
- (void)setPointerArrow:(BOOL)value;
- (void)setDraggable:(BOOL)value;
- (void)setColors:(BOOL)value;
- (void)setSide:(NSUInteger)side;
- (void)setPosition:(CGFloat)position;
- (void)setPosition:(CGFloat)position animated:(BOOL)animated;
- (CGFloat)margin;

@end

#pragma mark -
#pragma mark Panel View Controller Interface 
@interface PanelViewController : UIViewController

@property (nonatomic, KB_WEAK) IBOutlet UISwitch *shadow;
@property (nonatomic, KB_WEAK) IBOutlet UISwitch *corners;
@property (nonatomic, KB_WEAK) IBOutlet UISwitch *borders;
@property (nonatomic, KB_WEAK) IBOutlet UISwitch *draggable;
@property (nonatomic, KB_WEAK) IBOutlet UISegmentedControl *side;
@property (nonatomic, KB_WEAK) IBOutlet UISegmentedControl *position1;

@property (nonatomic, KB_WEAK) id<PanelViewControllerDelegate> delegate;

@end
