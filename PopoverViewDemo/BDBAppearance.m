//
//  BDBAppearance.m
//  PopoverViewDemo
//
//  Created by Bradley Bergeron on 18/09/2013.
//  Copyright (c) 2013 Bradley David Bergeron. All rights reserved.
//

#import "BDBAppearance.h"

#import "UIImage+BBlock.h"


#pragma mark -
@implementation BDBAppearance

#pragma mark Colors
+ (UIColor *)blueColor
{
    return [UIColor colorWithRed:0.000 green:0.694 blue:1.000 alpha:1.000];
}

+ (UIColor *)pinkColor
{
    return [UIColor colorWithRed:1.000 green:0.239 blue:0.333 alpha:1.000];
}

#pragma mark Navigation Bar
+ (UIImage *)navigationBarImageForHeight:(CGFloat)height
{
    return [UIImage imageWithIdentifier:BBlockImageIdentifier(@"%f", height) forSize:CGSizeMake(1, height) andDrawingBlock:^{
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = UIGraphicsGetCurrentContext();

        UIColor *bottomColor = [self blueColor];
        UIColor *topColor    = [self blueColor];
        UIColor *lineColor   = [UIColor colorWithWhite:0.0 alpha:0.3];

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
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
    {
        [[[[UIApplication sharedApplication] delegate] window] setTintColor:[self blueColor]];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

        UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
        [navigationBarAppearance setBackgroundImage:[self navigationBarImageForHeight:64] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
        [navigationBarAppearance setTintColor:[self blueColor]];
        [navigationBarAppearance setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        [navigationBarAppearance setShadowImage:[UIImage new]];
    }
    else
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];

        UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
        [navigationBarAppearance setBackgroundImage:[self navigationBarImageForHeight:44] forBarMetrics:UIBarMetricsDefault];
        [navigationBarAppearance setTintColor:[self blueColor]];
        [navigationBarAppearance setTitleTextAttributes:@{UITextAttributeFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0],
                                                          UITextAttributeTextColor:[UIColor whiteColor],
                                                          UITextAttributeTextShadowColor:[UIColor clearColor]}];
        [navigationBarAppearance setShadowImage:[UIImage new]];
        [navigationBarAppearance setTitleVerticalPositionAdjustment:1.0 forBarMetrics:UIBarMetricsDefault];
    }
}

@end
