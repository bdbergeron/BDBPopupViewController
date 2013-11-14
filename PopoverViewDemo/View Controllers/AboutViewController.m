//
//  AboutViewController.m
//  PopoverViewDemo
//
//  Created by Bradley Bergeron on 18/09/2013.
//  Copyright (c) 2013 Bradley David Bergeron. All rights reserved.
//

#import "AboutViewController.h"

#import "UIViewController+BDBPopupViewController.h"


#pragma mark -
@interface AboutViewController ()

@end


#pragma mark -
@implementation AboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"About";

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
        self.edgesForExtendedLayout = UIRectEdgeNone;

    [self.website addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(infoItemTapped:)]];
    [self.twitter addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(infoItemTapped:)]];
    [self.github  addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(infoItemTapped:)]];
}

- (void)infoItemTapped:(UITapGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        if ([recognizer.view isEqual:self.website])
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://bradbergeron.com"]];
        if ([recognizer.view isEqual:self.twitter])
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://twitter.com/bradbergeron"]];
        if ([recognizer.view isEqual:self.github])
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://github.com/bdbergeron"]];
    }
}

- (IBAction)close:(UIButton *)sender
{
    [self.parentViewController dismissPopupViewControllerWithAnimation:BDBPopupViewHideAnimationZoomOut completion:nil];
}

@end
