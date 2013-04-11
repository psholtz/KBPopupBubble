//
//  PanelViewController.m
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

#import "PanelViewController.h"

#import "KBPopupBubbleView.h"

#define kKBSlideDuration    0.4f
#define kKBCornerRadius     10.0f
#define kKBBorderWidth      2.0f
#define kKBLabelColor       [UIColor darkGrayColor]
#define kKBBorderColor      [UIColor blackColor]

#pragma mark -
#pragma mark Private Interface
@interface PanelViewController ()

- (void)configureLabel:(UILabel*)label;

- (BOOL)active;

@end

#pragma mark -
#pragma mark Implementation
@implementation PanelViewController

- (id)init {
    // Select the name
    NSString * name = nil;
    if IS_IPHONE_4 {
        name = @"PanelViewController_iPhone4";
    } else if IS_IPHONE_5 {
        name = @"PanelViewController_iPhone5";
    }

    // Construct the object
    self = [super initWithNibName:name bundle:nil];
    if ( self ) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    CGFloat a = 0.4f;
    self.view.backgroundColor = [UIColor colorWithRed:a green:a blue:a alpha:0.2f];
    
    [self configureLabel:self.label1];
    [self configureLabel:self.label2];
    [self configureLabel:self.label3];
    [self configureLabel:self.label4];
    [self configureLabel:self.label5];
    [self configureLabel:self.label6];
    [self configureLabel:self.label7];
    [self configureLabel:self.label8];
    [self configureLabel:self.label9];
}

- (void)configureLabel:(UILabel*)label {
    label.backgroundColor = kKBLabelColor;
    label.layer.cornerRadius = kKBCornerRadius;
    label.layer.borderColor = kKBBorderColor.CGColor;
    label.layer.borderWidth = kKBBorderWidth;
}

#pragma mark -
#pragma mark IBAction Method
- (IBAction)pressButton1:(id)sender {
    if ( self.delegate != nil && [self.delegate respondsToSelector:@selector(margin)] ) {
        [UIView animateWithDuration:kKBSlideDuration
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             CGRect f = CGRectMake(self.view.frame.origin.x,
                                                   [self active] ? (-1) * (self.view.frame.size.height - [self.delegate margin]) : 0.0f,
                                                   self.view.frame.size.width,
                                                   self.view.frame.size.height);
                             self.view.frame = f;
                         }
                         completion:^(BOOL completed) {
                         }
         ];
    }
}

- (IBAction)pressAnimate:(id)sender {
    if ( [sender isKindOfClass:[UISwitch class]] ) {
        UISwitch * s = (UISwitch*)sender;
        [self.delegate setAnimate:s.on];
    }
}

- (IBAction)pressShadow:(id)sender {
    if ( [sender isKindOfClass:[UISwitch class]] ) {
        UISwitch *s = (UISwitch*)sender;
        [self.delegate setShadow:s.on];
    }
}

- (IBAction)pressCorners:(id)sender {
    if ( [sender isKindOfClass:[UISwitch class]] ) {
        UISwitch *s = (UISwitch*)sender;
        [self.delegate setCorners:s.on];
    }
}

- (IBAction)pressBorders:(id)sender {
    if ( [sender isKindOfClass:[UISwitch class]] ) {
        UISwitch * s = (UISwitch*)sender;
        [self.delegate setBorders:s.on];
    }
}

- (IBAction)pressDraggable:(id)sender {
    if ( [sender isKindOfClass:[UISwitch class]] ) {
        UISwitch * s = (UISwitch*)sender;
        [self.delegate setDraggable:s.on];
    }
}

- (IBAction)pressColors:(id)sender {
    if ( [sender isKindOfClass:[UISwitch class]] ) {
        UISwitch * s = (UISwitch*)sender;
        [self.delegate setColors:s.on];
    }
}

- (IBAction)pressSide:(id)sender {
    if ( [sender isKindOfClass:[UISegmentedControl class]] ) {
        UISegmentedControl *c = (UISegmentedControl*)sender;
        switch ( c.selectedSegmentIndex ) {
            case 0:
                [self.delegate setSide:kKBPopupPointerSideTop];
                break;
            case 1:
                [self.delegate setSide:kKBPopupPointerSideBottom];
                break;
            case 2:
                [self.delegate setSide:kKBPopupPointerSideLeft];
                break;
            case 3:
                [self.delegate setSide:kKBPopupPointerSideRight];
                break;
        }
    }

}

- (IBAction)pressPosition1:(id)sender {
    if ( [sender isKindOfClass:[UISegmentedControl class]] ) {
        UISegmentedControl *c = (UISegmentedControl*)sender;
        if ( self.delegate != nil && [self.delegate respondsToSelector:@selector(setPosition:animated:)] ) {
            switch ( c.selectedSegmentIndex ) {
                case 0:
                    [self.delegate setPosition:kKBPopupPointerPositionLeft animated:YES];
                    [self.position2 setValue:kKBPopupPointerPositionLeft animated:YES];
                    break;
                case 1:
                    [self.delegate setPosition:kKBPopupPointerPositionMiddle animated:YES];
                    [self.position2 setValue:kKBPopupPointerPositionMiddle animated:YES];
                    break;
                case 2:
                    [self.delegate setPosition:kKBPopupPointerPositionRight animated:YES];
                    [self.position2 setValue:kKBPopupPointerPositionRight animated:YES];
                    break;
            }
        }
    }
}

- (IBAction)pressPosition2:(id)sender {
    if ( [sender isKindOfClass:[UISlider class]] ) {
        UISlider *s = (UISlider*)sender;
        [self.delegate setPosition:s.value];        
    }
}

#pragma mark -
#pragma mark Internal Methods
- (BOOL)active {
    return self.view.frame.origin.y == 0.0f;
}

@end
