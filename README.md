KBPopupBubble
============= 

![http://farm8.staticflickr.com/7291/8723769177_151c2c586a_o.gif](http://farm8.staticflickr.com/7291/8723769177_151c2c586a_o.gif)

*Three different KBPopupBubbles: (i) the blue bubble is rendered using square corners and no drop shadow; (ii) the green bubble is rendered using rounded corners, drop shadow and a shaded border; (iii) the red bubble is configured just like the green bubble, but with no borders. In the blue and green bubbles, the pointer arrow is rendered at the 0.0 position on the top and left sides, respectively. In the red bubble the pointer arrow is rendered at the 1.0 position on the bottom.*

KBPopupBubble is a customizable subclass of UIView which can be used to implement "Twitter-like" pointer bubbles on iOS.

The class consists of a parent view, which does little more than provide a "bounding box" in which subviews are drawn, and several subviews, where the actual mechanics of drawing take place. The two most important such subviews are the "drawable" and "shadow" subviews. The "drawable" subview is where most of the mechanics of drawing, including that of drawing the dynamic pointer arrow, takes place, while the "shadow" subview takes care of rendering the optional drop shadow.

The two subviews are inlaid inside the bounding frame of the parent using a "margin" offset. 

Additonally, a standard UILabel object is inlaid inside the "drawing" subview using a "padding" offset. 

This UILabel object is used to render on screen text and writing, and can be configured (in terms of its text, color, font, styling) like normal.

Example Usage
------------- 

Probably the easiest way to construct a KBPopupBubble would be to make use of one of the following constructors:

<pre>
KBPopupBubbleView *bubble1 = [[KBPopupBubbleView alloc] initWithCenter:CGPointMake(x, y)];
</pre>

In this case, the bubble is centered at the argument point, and the width and height of the frame are constructed using the static constants *kKBDefaultWidth* and *kKBDefaultHeight*, which are defined at the top of the *KBPopupBubbleView.m* file and which the user can customize in the source code.

A bubble can also be constructed using a standard argument frame, like any other UIView:

<pre>
KBPopupBubbleView *bubble2 = [[KBPopupBubbleView alloc] initWithFrame:myFrame];
</pre>

A constructor taking an NSCoder argument is also defined, so you can configure your bubbles directly in the Interface Builder.

Once you've constructed your bubble, you bring it to life by invoking the following API:

<pre>
- (void)showInView:(UIView*)target animated:(BOOL)animated;
</pre>

Setting the *animated* flag to TRUE will give the bubble a fun, bouncy popin, whereas leaving it FALSE will simply dump it to the screen.

Similarly, to dismiss the bubble from the screen once you're done, invoke the following API:

<pre>
- (void)hide:(BOOL)animated;
</pre>

Features
-------- 

The feature that most users will be making the most use of is probably the dynamic arrow position setting API:

<pre>
- (void)setPosition:(CGFloat)position animated:(BOOL)animated;
</pre>

The *position* variable is a float ranging from 0.0 and 1.0, and indicates how "far over" on the bubble the dynamic pointer arrow should be rendered. Using rendering on the "top" side as an example, 0.0 would indicate the far left; 0.5 would be in the middle; while 1.0 would be the far right. Clearly, any (float) value in between on the bar is acceptable as well.

By setting the *animated* flag to TRUE, the pointer arrow will dynamically animate and slide to its target position.

You can mess around with the Configuration Menu (see below) to see how this works in greater detail.

In addition to dynamically setting the position of pointer arrow, and controlling whether the bubble pops into its target view using an animation sequence, there are a number of other variables you can configure for your popup bubble. 

Some examples include:

<ul>
<li>Which side (i.e., top, bottom, left, right) of the bubble to draw the pointer arrow on</li>
<li>Whether to use drop shadows</li>
<li>Whether to use rounded corners</li>
<li>Whether to use borders</li>
<li>Whether the bubble is "draggable" by touch</li>
<li>The color of the bubble</li>
<li>The color of the border</li>
<li>The color of the drop shadow</li>
<li>The radius of the rounded corners</li>
<li>The opacity of the drop shadow</li>
<li>The radius of the drop shadow</li>
<li>The offset of the drop shadow</li>
<li>The width of the border</li>
<li>The duration of the popin/popout animation</li>
</ul>

and more. 

Additionally, the text of the bubble can be configured using the standard UILabel interface.

Configuration Menu
------------------

The sample project comes with a configuration button that you can use to bring up a menu to customize your KBPopupBubble:

![http://farm9.staticflickr.com/8251/8638942678_f5d43f309c.jpg](http://farm9.staticflickr.com/8251/8638942678_f5d43f309c.jpg)

At first glance, the configuration menu may be a little confusing. In the first place, it's translucent. To see why the menu was designed the way it was, play around with the two position controls while having at least one KBPopupBubble on screen. Hopefully the design of the menu, and its translucence, will make more sense at that point:

![http://farm9.staticflickr.com/8400/8638976962_24b432bfe6.jpg](http://farm9.staticflickr.com/8400/8638976962_24b432bfe6.jpg)

In fact, you can use any of the controls on the configuration menu to dynamically adjust the properties of the onscreen bubble.

The cryptic labels on the two UISegmentedControls deserve a little bit of explanation. For the "side" control, the "T B L R" labels correspond to the *Top*, *Bottom*, *Left* and *Right* sides of the bubble, respectively. Similarly, for the "position1" control, the "L M R" labels correspond of the *Left*, *Middle* and *Right* positions on the selected side of the bubble.

Make sure you have at least one KBPopupBubble on screen, before invoking the configuration menu.

Tap the "configure" button again to dismiss the menu.

Support
------- 

KBPopupBubble is designed to run on all iOS devices (iPhone4, iPhone5 and iPad), and on all iOS versions from 4.3 and up.

KBPopupBubble is designed to be used on ARC-enabled projects. 

KBPopupBubble requires linking with the QuartzCore Framework.

License
------- 

The code is distributed under the terms and conditions of the MIT license.

Change Log 
---------- 

**Version 1.0** @ April 10, 2013

<ul>
	<li>Initial release</li>
</ul>

Acknowledgements
---------------- 

KBPopupBubble draws inspiration from the following projects:

<ul>
 <li><a href="http://ftutils.com/" target=_blank>FTUtils</a></li>
 <li><a href="https://github.com/Antondomashnev/ADPopupView" target=_blank>ADPopupView</a></li>
</ul>
