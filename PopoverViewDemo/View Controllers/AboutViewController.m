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

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
        self.edgesForExtendedLayout = UIRectEdgeNone;

    UIFont *socialIconFont = [UIFont fontWithName:@"SSSocialCircle" size:self.websiteLabel.font.pointSize * 2.0];

    NSMutableAttributedString *websiteIcon = [[NSMutableAttributedString alloc] initWithString:@"rss"
                                                                                    attributes:@{NSForegroundColorAttributeName:self.websiteLabel.textColor,
                                                                                                 NSFontAttributeName:socialIconFont,
                                                                                                 NSLigatureAttributeName:@(2)}];
    NSMutableAttributedString *twitterIcon = [[NSMutableAttributedString alloc] initWithString:@"twitter"
                                                                                    attributes:@{NSForegroundColorAttributeName:self.twitterLabel.textColor,
                                                                                                 NSFontAttributeName:socialIconFont,
                                                                                                 NSLigatureAttributeName:@(2)}];
    NSMutableAttributedString *githubIcon  = [[NSMutableAttributedString alloc] initWithString:@"octocat"
                                                                                    attributes:@{NSForegroundColorAttributeName:self.githubLabel.textColor,
                                                                                                 NSFontAttributeName:socialIconFont,
                                                                                                 NSLigatureAttributeName:@(2)}];

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineHeightMultiple = 0.75;

    NSDictionary *defaultAttributes = @{NSForegroundColorAttributeName:self.websiteLabel.textColor,
                                        NSFontAttributeName:self.websiteLabel.font,
                                        NSParagraphStyleAttributeName:paragraphStyle};

    NSMutableAttributedString *websiteText = [[NSMutableAttributedString alloc] initWithString:[self.websiteLabel.text stringByReplacingOccurrencesOfString:@"website\n" withString:@"\n"] attributes:defaultAttributes];
    NSMutableAttributedString *twitterText = [[NSMutableAttributedString alloc] initWithString:[self.twitterLabel.text stringByReplacingOccurrencesOfString:@"twitter\n" withString:@"\n"] attributes:defaultAttributes];
    NSMutableAttributedString *githubText  = [[NSMutableAttributedString alloc] initWithString:[self.githubLabel.text stringByReplacingOccurrencesOfString:@"github\n" withString:@"\n"] attributes:defaultAttributes];

    [websiteText insertAttributedString:websiteIcon atIndex:0];
    [twitterText insertAttributedString:twitterIcon atIndex:0];
    [githubText insertAttributedString:githubIcon atIndex:0];

    self.websiteLabel.attributedText = websiteText;
    self.twitterLabel.attributedText = twitterText;
    self.githubLabel.attributedText  = githubText;

    [self.websiteLabel sizeToFit];
    [self.twitterLabel sizeToFit];
    [self.githubLabel sizeToFit];
}

- (IBAction)close:(UIButton *)sender
{
    [self.parentViewController dismissPopupViewControllerWithAnimation:BDBPopupViewHideAnimationZoomOut completion:nil];
}

@end
