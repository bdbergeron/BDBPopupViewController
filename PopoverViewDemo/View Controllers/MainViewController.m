//
//  MainViewController.m
//  PopoverViewDemo
//
//  Created by Bradley Bergeron on 18/09/2013.
//  Copyright (c) 2013 Bradley David Bergeron. All rights reserved.
//

#import <CoreText/CoreText.h>

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

    UIFont *standardIconFont = [UIFont fontWithName:@"SSStandard" size:self.infoButton.titleLabel.font.pointSize];

    NSMutableAttributedString *infoIcon = [[NSMutableAttributedString alloc] initWithString:self.infoButton.titleLabel.text
                                                                                 attributes:@{NSForegroundColorAttributeName:[self.infoButton titleColorForState:UIControlStateNormal],
                                                                                              NSFontAttributeName:standardIconFont,
                                                                                              NSLigatureAttributeName:@(2)}];
    [self.infoButton setAttributedTitle:infoIcon forState:UIControlStateNormal];

    NSMutableAttributedString *infoIconHighlighted = [[NSMutableAttributedString alloc] initWithAttributedString:infoIcon];
    [infoIconHighlighted addAttribute:NSForegroundColorAttributeName
                                value:[self.infoButton titleColorForState:UIControlStateHighlighted]
                                range:NSMakeRange(0, infoIconHighlighted.length)];
    [self.infoButton setAttributedTitle:infoIconHighlighted forState:UIControlStateHighlighted];
}

- (IBAction)showInfo:(UIButton *)sender
{
    AboutViewController *aboutVC = [[AboutViewController alloc] initWithNibName:nil bundle:nil];
    [self presentPopupViewController:aboutVC withAnimation:BDBPopupViewShowAnimationZoomIn completion:nil];
}

@end
