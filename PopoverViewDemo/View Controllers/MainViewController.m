//
//  MainViewController.m
//  PopoverViewDemo
//
//  Created by Bradley Bergeron on 18/09/2013.
//  Copyright (c) 2013 Bradley David Bergeron. All rights reserved.
//

#import "AboutViewController.h"
#import "MainViewController.h"

#import "UIViewController+BDBPopupViewController.h"


#pragma mark -
@interface MainViewController ()

@end


#pragma mark -
@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Popup Demo";

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
        self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (IBAction)showInfo:(UIButton *)sender
{
    AboutViewController *aboutVC = [[AboutViewController alloc] initWithNibName:nil bundle:nil];
    [self presentPopupViewController:aboutVC withAnimation:BDBPopupViewShowAnimationZoomIn completion:nil];
}

@end
