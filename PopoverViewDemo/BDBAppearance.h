//
//  BDBAppearance.h
//  PopoverViewDemo
//
//  Created by Bradley Bergeron on 18/09/2013.
//  Copyright (c) 2013 Bradley David Bergeron. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark -
@interface BDBAppearance : NSObject

#pragma mark Colors
+ (UIColor *)blueColor;
+ (UIColor *)pinkColor;

#pragma mark Navigation Bar
+ (UIImage *)navigationBarImageForHeight:(CGFloat)height;

#pragma mark Apply
+ (void)applyAppearance;

@end
