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
#define kKBCornerRadius     16.0f
#define kKBBorderWidth      1.5f
#define kKBLabelColor       [UIColor colorWithWhite:0.45f alpha:1.0f]
#define kKBBorderColor      [UIColor blackColor]

#pragma mark -
#pragma mark Internal Interface
@interface PanelViewController ()

@property (nonatomic, KB_WEAK) IBOutlet UILabel *label1;
@property (nonatomic, KB_WEAK) IBOutlet UILabel *label2;
@property (nonatomic, KB_WEAK) IBOutlet UILabel *label3;
@property (nonatomic, KB_WEAK) IBOutlet UILabel *label4;
@property (nonatomic, KB_WEAK) IBOutlet UILabel *label5;
@property (nonatomic, KB_WEAK) IBOutlet UILabel *label6;
@property (nonatomic, KB_WEAK) IBOutlet UILabel *label7;
@property (nonatomic, KB_WEAK) IBOutlet UILabel *label8;
@property (nonatomic, KB_WEAK) IBOutlet UILabel *label9;
@property (nonatomic, KB_WEAK) IBOutlet UILabel *labelButton;

@property (nonatomic, KB_WEAK) IBOutlet UISwitch *animate;
@property (nonatomic, KB_WEAK) IBOutlet UISwitch *colors;
@property (nonatomic, KB_WEAK) IBOutlet UISlider *position2;

@property (nonatomic, KB_WEAK) IBOutlet UIButton *button1;

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
    
    // Slight hack for iOS7 UIs
    if ( SYSTEM_VERSION_LESS_THAN(@"7.0") ) {
        [self adjustSwitchControl:self.animate];
        [self adjustSwitchControl:self.shadow];
        [self adjustSwitchControl:self.corners];
        [self adjustSwitchControl:self.draggable];
        [self adjustSwitchControl:self.colors];
        [self adjustSwitchControl:self.borders];
            
        [self adjustSegmentedControl:self.side];
        [self adjustSegmentedControl:self.position1];
    }
    
    if ( SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ) {
        // Adjust the configure button downwards
        CGFloat margin1 = 30.0f;
        [self adjustButton:self.button1 withLabel:self.labelButton withMargin:margin1];
            
        // Adjust the rest of the controls downwards
        CGFloat margin2 = 15.0f;
        [self adjustView:self.animate withMargin:margin2];
        [self adjustView:self.shadow withMargin:margin2];
        [self adjustView:self.corners withMargin:margin2];
        [self adjustView:self.draggable withMargin:margin2];
        [self adjustView:self.colors withMargin:margin2];
        [self adjustView:self.borders withMargin:margin2];
            
        [self adjustView:self.label1 withMargin:margin2];
        [self adjustView:self.label2 withMargin:margin2];
        [self adjustView:self.label3 withMargin:margin2];
        [self adjustView:self.label4 withMargin:margin2];
        [self adjustView:self.label5 withMargin:margin2];
        [self adjustView:self.label6 withMargin:margin2];
        [self adjustView:self.label7 withMargin:margin2];
        [self adjustView:self.label8 withMargin:margin2];
        [self adjustView:self.label9 withMargin:margin2];
            
        [self adjustView:self.side withMargin:margin2];
        [self adjustView:self.position1 withMargin:margin2];
        [self adjustView:self.position2 withMargin:margin2];
        
        // Adjust the colors on the controls
        [self adjustSwitchControlColor:self.animate];
        [self adjustSwitchControlColor:self.shadow];
        [self adjustSwitchControlColor:self.corners];
        [self adjustSwitchControlColor:self.draggable];
        [self adjustSwitchControlColor:self.colors];
        [self adjustSwitchControlColor:self.borders];
        
        [self adjustSegmentedControlColor:self.side];
        [self adjustSegmentedControlColor:self.position1];
        
        [self adjustSliderControlColor:self.position2];
    }
}

- (void)configureLabel:(UILabel*)label {
    label.backgroundColor    = kKBLabelColor;
    label.layer.cornerRadius = kKBCornerRadius;
    label.layer.borderColor  = kKBBorderColor.CGColor;
    label.layer.borderWidth  = kKBBorderWidth;
}

// Hack to adjust positioning in iOS7
- (void)adjustSwitchControl:(UISwitch*)control {
    CGRect tmp = control.frame;
    control.frame = CGRectMake(205.0f, tmp.origin.y, tmp.size.width, tmp.size.height);
}

- (void)adjustSegmentedControl:(UISegmentedControl*)control {
    CGRect tmp = control.frame;
    control.frame = CGRectMake(tmp.origin.x, tmp.origin.y - 8.0f, tmp.size.width, tmp.size.height);
}

- (void)adjustButton:(UIButton*)button withLabel:(UILabel*)label withMargin:(CGFloat)margin {
    CGRect tmp1 = button.frame;
    CGRect tmp2 = label.frame;
    
    button.frame = CGRectMake(tmp1.origin.x, tmp1.origin.y + margin, tmp1.size.width, tmp1.size.height);
    label.frame = CGRectMake(tmp2.origin.x, tmp2.origin.y + margin, tmp2.size.width, tmp2.size.height);
}

- (void)adjustView:(UIView*)view1 withMargin:(CGFloat)margin {
    CGRect tmp = view1.frame;
    view1.frame = CGRectMake(tmp.origin.x, tmp.origin.y + margin, tmp.size.width, tmp.size.height);
}

// Hacks to adjust colors in iOS7
- (void)adjustSwitchControlColor:(UISwitch*)control {
    control.backgroundColor = kKBLabelColor;
    control.layer.cornerRadius = 16.0f;
    control.tintColor = [UIColor blackColor];
    control.onTintColor = [UIColor colorWithRed:(238.0f/255.0) green:(149.0/255.0) blue:0.0f alpha:1.0f];
}

- (void)adjustSegmentedControlColor:(UISegmentedControl*)control {
    [control.layer setCornerRadius:5.0f];
    [control setBackgroundColor:kKBLabelColor];
    [control setTintColor:[UIColor blackColor]];
}

- (void)adjustSliderControlColor:(UISlider*)slider {
    [slider setTintColor:[UIColor blackColor]];
}

#pragma mark -
#pragma mark IBAction Method
- (IBAction)pressButton1:(id)sender {
    if ( self.delegate != nil && [self.delegate respondsToSelector:@selector(margin)] ) {
        KB_WEAK_REF typeof(self) _weakSelf = self;
        [UIView animateWithDuration:kKBSlideDuration
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             CGRect f = CGRectMake(_weakSelf.view.frame.origin.x,
                                                   _weakSelf.active ? (-1) * (_weakSelf.view.frame.size.height - [_weakSelf.delegate margin]) : 0.0f,
                                                   _weakSelf.view.frame.size.width,
                                                   _weakSelf.view.frame.size.height);
                             _weakSelf.view.frame = f;
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
