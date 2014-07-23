//
//  BDBAppearance.m
//
//  Copyright (c) 2014 Bradley David Bergeron
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "BDBAppearance.h"

#import "UIImage+BBlock.h"


#pragma mark -
@implementation BDBAppearance

#pragma mark Colors
+ (UIColor *)blueColor
{
    return [UIColor colorWithRed:0.f green:0.694f blue:1.000f alpha:1.f];
}

+ (UIColor *)pinkColor
{
    return [UIColor colorWithRed:1.f green:0.239f blue:0.333f alpha:1.f];
}

#pragma mark Navigation Bar
+ (UIImage *)navigationBarImageForHeight:(CGFloat)height
{
    return [UIImage imageWithIdentifier:BBlockImageIdentifier(@"%f", height)
                                forSize:CGSizeMake(1, height)
                        andDrawingBlock:^{
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = UIGraphicsGetCurrentContext();

        UIColor *bottomColor = [self blueColor];
        UIColor *topColor    = [self blueColor];
        UIColor *lineColor   = [UIColor colorWithWhite:0.f alpha:0.3f];

        NSArray *gradientColors = @[(id)topColor.CGColor, (id)bottomColor.CGColor];
        CGFloat gradientLocations[] = {0, 1};
        CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);

        UIBezierPath *gradientPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 1, height)];
        CGContextSaveGState(context);
        [gradientPath addClip];
        CGContextDrawLinearGradient(context, gradient, CGPointZero, CGPointMake(0, height), 0);
        CGContextRestoreGState(context);

        UIBezierPath *linePath = [UIBezierPath bezierPathWithRect:CGRectMake(0, height - 1, 1, 1)];
        [lineColor setFill];
        [linePath fill];

        CGGradientRelease(gradient);
        CGColorSpaceRelease(colorSpace);
    }];
}

#pragma mark Apply
+ (void)applyAppearance
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.f) {
        [[[[UIApplication sharedApplication] delegate] window] setTintColor:[self blueColor]];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

        UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
        [navigationBarAppearance setBackgroundImage:[self navigationBarImageForHeight:64.f] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
        [navigationBarAppearance setTintColor:[self blueColor]];
        [navigationBarAppearance setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        [navigationBarAppearance setShadowImage:[UIImage new]];
    } else {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];

        UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
        [navigationBarAppearance setBackgroundImage:[self navigationBarImageForHeight:44.f] forBarMetrics:UIBarMetricsDefault];
        [navigationBarAppearance setTintColor:[self blueColor]];
        [navigationBarAppearance setTitleTextAttributes:@{UITextAttributeFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17.f],
                                                          UITextAttributeTextColor:[UIColor whiteColor],
                                                          UITextAttributeTextShadowColor:[UIColor clearColor]}];
        [navigationBarAppearance setShadowImage:[UIImage new]];
        [navigationBarAppearance setTitleVerticalPositionAdjustment:1.0 forBarMetrics:UIBarMetricsDefault];
    }
}

@end
