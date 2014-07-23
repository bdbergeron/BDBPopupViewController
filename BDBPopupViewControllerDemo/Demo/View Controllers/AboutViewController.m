//
//  AboutViewController.m
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

    self.title = NSLocalizedString(@"About", nil);

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.f) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    [self.website addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(infoItemTapped:)]];
    [self.twitter addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(infoItemTapped:)]];
    [self.github  addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(infoItemTapped:)]];
}

- (void)infoItemTapped:(UITapGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if ([recognizer.view isEqual:self.website]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://bradbergeron.com"]];
        } else if ([recognizer.view isEqual:self.twitter]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://twitter.com/bradbergeron"]];
        } else if ([recognizer.view isEqual:self.github]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://github.com/bdbergeron"]];
        }
    }
}

- (IBAction)close:(UIButton *)sender
{
    [self.parentViewController bdb_dismissPopupViewControllerWithAnimation:BDBPopupViewHideAnimationZoomOut
                                                                completion:nil];
}

@end
