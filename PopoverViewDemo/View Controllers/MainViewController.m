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

    NSMutableAttributedString *normal = [[NSMutableAttributedString alloc] initWithString:self.infoButton.titleLabel.text
                                                                               attributes:@{NSForegroundColorAttributeName:[self.infoButton titleColorForState:UIControlStateNormal],
                                                                                            (NSString *)kCTFontAttributeName:[UIFont fontWithName:@"SSStandard" size:72.0],
                                                                                            (NSString *)kCTLigatureAttributeName:@(2)}];
    [self.infoButton setAttributedTitle:normal forState:UIControlStateNormal];

    NSMutableAttributedString *highlighted = [[NSMutableAttributedString alloc] initWithAttributedString:normal];
    [highlighted addAttribute:NSForegroundColorAttributeName value:[self.infoButton titleColorForState:UIControlStateHighlighted] range:NSMakeRange(0, highlighted.length)];
    [self.infoButton setAttributedTitle:highlighted forState:UIControlStateHighlighted];
}

- (IBAction)showInfo:(UIButton *)sender
{
    AboutViewController *aboutVC = [[AboutViewController alloc] initWithNibName:nil bundle:nil];
    [self presentPopupViewController:aboutVC withAnimation:BDBPopupAnimationGrowFromCenter completion:nil];
}

@end
