//
//  UIViewController+BDBPopupViewController.m
//
//  Created by Bradley David Bergeron on 09/18/13.
//  Copyright (c) 2013 Bradley David Bergeron
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
//

#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>

#import "UIViewController+BDBPopupViewController.h"


#pragma mark -
@interface UIViewController (BDBPopupViewControllerPrivate)

@property (nonatomic, readwrite) UIViewController   *popupViewController;

@property (nonatomic) UIView            *bdbPopoverDimmingView;
@property (nonatomic) UIView            *bdbPopoverContainerView;
@property (nonatomic) UIView            *bdbPopoverContentView;

- (void)showPopupWithAnimation:(BDBPopupViewAnimationStyle)animation completion:(void (^)(void))completion;
- (void)dismissPopupWithAnimation:(BDBPopupViewAnimationStyle)animation completion:(void (^)(void))completion;

@end


#pragma mark -
@implementation UIViewController (BDBPopupViewController)

#pragma mark Fake Accessors
// http://oleb.net/blog/2011/05/faking-ivars-in-objc-categories-with-associative-references/
// http://www.tuaw.com/2013/04/10/devjuice-better-objective-c-associated-objects/
- (UIViewController *)popupViewController
{
    return objc_getAssociatedObject(self, @selector(popupViewController));
}

- (void)setPopupViewController:(UIViewController *)viewController
{
    objc_setAssociatedObject(self, @selector(popupViewController), viewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIViewController *)bdbPresentingViewController
{
    return objc_getAssociatedObject(self, @selector(bdbPresentingViewController));
}

- (void)setBdbPresentingViewController:(UIViewController *)presentingViewController
{
    objc_setAssociatedObject(self, @selector(bdbPresentingViewController), presentingViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)bdbPopoverDimmingView
{
    return objc_getAssociatedObject(self, @selector(bdbPopoverDimmingView));
}

- (void)setBdbPopoverDimmingView:(UIView *)dimmingView
{
    objc_setAssociatedObject(self, @selector(bdbPopoverDimmingView), dimmingView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)bdbPopoverContainerView
{
    return objc_getAssociatedObject(self, @selector(bdbPopoverContainerView));
}

- (void)setBdbPopoverContainerView:(UIView *)containerView
{
    objc_setAssociatedObject(self, @selector(bdbPopoverContainerView), containerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)bdbPopoverContentView
{
    return objc_getAssociatedObject(self, @selector(bdbPopoverContentView));
}

- (void)setBdbPopoverContentView:(UIView *)contentView
{
    objc_setAssociatedObject(self, @selector(bdbPopoverContentView), contentView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark Present / Dismiss
- (void)presentPopupViewController:(UIViewController *)viewController withAnimation:(BDBPopupViewAnimationStyle)animation completion:(void (^)(void))completion
{
    if (self.popupViewController)
    {
        NSLog(@"Cannot present popup view controller %@: popup view controller %@ is currently visible on %@.", viewController, self.popupViewController, self);
        return;
    }

    UIViewController *rootViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];

    UIView *dimmingView = [[UIView alloc] initWithFrame:rootViewController.view.bounds];
    dimmingView.autoresizingMask =
        UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleHeight;
    dimmingView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    dimmingView.alpha = 0.0;

    UIView *containerView = [[UIView alloc] initWithFrame:viewController.view.bounds];
    containerView.autoresizingMask =
        UIViewAutoresizingFlexibleTopMargin |
        UIViewAutoresizingFlexibleBottomMargin |
        UIViewAutoresizingFlexibleLeftMargin |
        UIViewAutoresizingFlexibleRightMargin;
    containerView.layer.shadowOffset = CGSizeMake(0, 3);
    containerView.layer.shadowRadius = 12;
    containerView.layer.shadowOpacity = 0.5;
    containerView.layer.shadowColor = [[UIColor blackColor] CGColor];
    containerView.layer.shouldRasterize = YES;
    containerView.layer.rasterizationScale = [[UIScreen mainScreen] scale];

    [containerView addSubview:viewController.view];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        containerView.frame = rootViewController.view.bounds;
        containerView.autoresizingMask =
            UIViewAutoresizingFlexibleWidth |
            UIViewAutoresizingFlexibleHeight;
        viewController.view.frame = rootViewController.view.bounds;
    }

    self.popupViewController = viewController;
    viewController.bdbPopoverDimmingView       = dimmingView;
    viewController.bdbPopoverContainerView     = containerView;
    viewController.bdbPopoverContentView       = viewController.view;

    [rootViewController addChildViewController:viewController];
    [rootViewController.view addSubview:dimmingView];
    [rootViewController.view addSubview:containerView];

    [viewController willMoveToParentViewController:self];
    [self addChildViewController:viewController];
    [viewController didMoveToParentViewController:self];

    [viewController showPopupWithAnimation:animation completion:completion];
}

- (void)dismissPopupViewControllerWithAnimation:(BDBPopupViewAnimationStyle)animation completion:(void (^)(void))completion
{
    [self dismissPopupWithAnimation:animation completion:completion];
}

#pragma mark Animations
- (void)showPopupWithAnimation:(BDBPopupViewAnimationStyle)animation completion:(void (^)(void))completion
{
    UIViewController *rootViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];

    switch (animation)
    {
        case BDBPopupAnimationGrowFromCenter:
        {
            CGPoint center = CGPointMake((rootViewController.view.bounds.size.width - self.bdbPopoverContainerView.frame.size.width) / 2.0,
                                         (rootViewController.view.bounds.size.height - self.bdbPopoverContainerView.frame.size.height) / 2.0);
            self.bdbPopoverContainerView.frame = (CGRect){center, self.bdbPopoverContainerView.frame.size};
            self.bdbPopoverContainerView.transform = CGAffineTransformMakeScale(0.1, 0.1);
            self.bdbPopoverContainerView.alpha = 0.0;

            [UIView animateWithDuration:0.3
                             animations:^{
                                 self.bdbPopoverContainerView.transform = CGAffineTransformMakeScale(1.1, 1.1);
                                 self.bdbPopoverContainerView.alpha = 1.0;
                                 self.bdbPopoverDimmingView.alpha = 1.0;
                             }
                             completion:^(BOOL finished) {
                                 [UIView animateWithDuration:0.2
                                                  animations:^{
                                                      self.bdbPopoverContainerView.transform = CGAffineTransformMakeScale(0.95, 0.95);
                                                  }
                                                  completion:^(BOOL finished) {
                                                      [UIView animateWithDuration:0.2
                                                                       animations:^{
                                                                           self.bdbPopoverContainerView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                                                       }
                                                                       completion:^(BOOL finished) {
                                                                           if (completion)
                                                                               completion();
                                                                       }];
                                                  }];
                             }];
            break;
        }

        case BDBPopupAnimationDefault:
        default:
        {
            CGSize windowSize  = self.view.window.bounds.size;
            CGSize containerSize = self.bdbPopoverContainerView.bounds.size;

            CGPoint center = (CGPoint){(windowSize.width - containerSize.width) / 2.0, (windowSize.height - containerSize.height) / 2.0};

            CGRect containerStartRect = (CGRect){(CGPoint){(windowSize.width - containerSize.width) / 2.0, windowSize.height}, containerSize};
            CGRect containerEndRect   = (CGRect){center, containerSize};

            self.bdbPopoverContainerView.frame = containerStartRect;

            [UIView animateWithDuration:0.3
                                  delay:0.0
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 self.bdbPopoverContainerView.frame = containerEndRect;
                                 self.bdbPopoverDimmingView.alpha = 1.0;
                             }
                             completion:^(BOOL finished) {
                                 self.bdbPopoverContainerView.center = self.view.window.center;
                                 if (completion)
                                     completion();
                             }];
            break;
        }
    }

}

- (void)dismissPopupWithAnimation:(BDBPopupViewAnimationStyle)animation completion:(void (^)(void))completion
{
    switch (animation)
    {
        case BDBPopupAnimationGrowFromCenter:
        {
            [UIView animateWithDuration:0.3
                             animations:^{
                                 self.popupViewController.bdbPopoverContainerView.transform = CGAffineTransformMakeScale(0.1, 0.1);
                                 self.popupViewController.bdbPopoverContainerView.alpha = 0.0;
                                 self.popupViewController.bdbPopoverDimmingView.alpha = 0.0;
                             }
                             completion:^(BOOL finished) {
                                 [self.popupViewController willMoveToParentViewController:nil];
                                 [self.popupViewController.bdbPopoverContainerView removeFromSuperview];
                                 [self.popupViewController.bdbPopoverDimmingView removeFromSuperview];
                                 [self.popupViewController removeFromParentViewController];
                                 [self.popupViewController didMoveToParentViewController:nil];

                                 self.popupViewController.bdbPopoverContainerView = nil;
                                 self.popupViewController.bdbPopoverContentView   = nil;
                                 self.popupViewController.bdbPopoverDimmingView   = nil;
                                 self.popupViewController = nil;

                                 if (completion)
                                     completion();
                             }];
            break;
        }

        case BDBPopupAnimationDefault:
        default:
        {
            CGSize windowSize    = self.view.window.bounds.size;
            CGSize containerSize = self.popupViewController.bdbPopoverContainerView.bounds.size;

            CGRect containerEndRect = (CGRect){(CGPoint){(windowSize.width - containerSize.width) / 2.0, windowSize.height}, containerSize};

            [UIView animateWithDuration:0.3
                                  delay:0.0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 self.popupViewController.bdbPopoverContainerView.frame = containerEndRect;
                                 self.popupViewController.bdbPopoverDimmingView.alpha = 0.0;
                             }
                             completion:^(BOOL finished) {
                                 [self.popupViewController willMoveToParentViewController:nil];
                                 [self.popupViewController.bdbPopoverContainerView removeFromSuperview];
                                 [self.popupViewController.bdbPopoverDimmingView removeFromSuperview];
                                 [self.popupViewController removeFromParentViewController];
                                 [self.popupViewController didMoveToParentViewController:nil];

                                 self.popupViewController.bdbPopoverContainerView = nil;
                                 self.popupViewController.bdbPopoverContentView   = nil;
                                 self.popupViewController.bdbPopoverDimmingView   = nil;
                                 self.popupViewController = nil;

                                 if (completion)
                                     completion();
                             }];
            break;
        }
    }
}

@end
