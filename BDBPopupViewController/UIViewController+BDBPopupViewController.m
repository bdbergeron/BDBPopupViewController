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

@import ObjectiveC.runtime;
@import QuartzCore;

#import "UIViewController+BDBPopupViewController.h"


#pragma mark -
@interface BDBPopupViewControllerAnimationDelegate : NSObject

typedef void (^BDBPopupViewControllerAnimationCompletionBlock)(void);

@property (nonatomic, readonly, copy) BDBPopupViewControllerAnimationCompletionBlock completionBlock;

- (id)initWithAnimationDidFinishBlock:(BDBPopupViewControllerAnimationCompletionBlock)block;

@end


#pragma mark -´
@implementation BDBPopupViewControllerAnimationDelegate

- (id)initWithAnimationDidFinishBlock:(BDBPopupViewControllerAnimationCompletionBlock)block
{
    self = [super init];

    if (self) {
        _completionBlock = block;
    }

    return self;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag && self.completionBlock) {
        self.completionBlock();
    }
}

@end


#pragma mark -
@interface UIViewController (BDBPopupViewControllerPrivate)

@property (nonatomic, readwrite) UIViewController *bdb_popupViewController;

@property (nonatomic) UIView *bdb_popupDimmingView;
@property (nonatomic) UIView *bdb_popupContainerView;
@property (nonatomic) UIView *bdb_popupContentView;

- (void)bdb_showPopupWithAnimation:(BDBPopupViewShowAnimationStyle)animation
                        completion:(void (^)(void))completion;

- (void)bdb_dismissPopupWithAnimation:(BDBPopupViewHideAnimationStyle)animation
                           completion:(void (^)(void))completion;

@end


#pragma mark -
@implementation UIViewController (BDBPopupViewController)

#pragma mark Fake Accessors
- (UIViewController *)bdb_popupViewController
{
    return objc_getAssociatedObject(self, @selector(bdb_popupViewController));
}

- (void)setBdb_popupViewController:(UIViewController *)viewController
{
    objc_setAssociatedObject(self, @selector(bdb_popupViewController), viewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)bdb_popupDimmingView
{
    return objc_getAssociatedObject(self, @selector(bdb_popupDimmingView));
}

- (void)setBdb_popupDimmingView:(UIView *)dimmingView
{
    objc_setAssociatedObject(self, @selector(bdb_popupDimmingView), dimmingView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)bdb_popupContainerView
{
    return objc_getAssociatedObject(self, @selector(bdb_popupContainerView));
}

- (void)setBdb_popupContainerView:(UIView *)containerView
{
    objc_setAssociatedObject(self, @selector(bdb_popupContainerView), containerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)bdb_popupContentView
{
    return objc_getAssociatedObject(self, @selector(bdb_popupContentView));
}

- (void)setBdb_popupContentView:(UIView *)contentView
{
    objc_setAssociatedObject(self, @selector(bdb_popupContentView), contentView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark Present / Dismiss
- (void)bdb_presentPopupViewController:(UIViewController *)viewController
                         withAnimation:(BDBPopupViewShowAnimationStyle)animation
                            completion:(void (^)(void))completion
{
    if (self.bdb_popupViewController) {
        NSLog(@"Cannot present popup view controller %@: popup view controller %@ is currently visible on %@.", viewController, self.bdb_popupViewController, self);

        return;
    }

    UIViewController *rootViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];

    UIView *dimmingView = [[UIView alloc] initWithFrame:rootViewController.view.bounds];
    dimmingView.autoresizingMask =
        UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleHeight;
    dimmingView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5f];
    dimmingView.alpha = 0.f;

    UIView *containerView = [[UIView alloc] initWithFrame:viewController.view.bounds];
    containerView.autoresizingMask =
        UIViewAutoresizingFlexibleTopMargin |
        UIViewAutoresizingFlexibleBottomMargin |
        UIViewAutoresizingFlexibleLeftMargin |
        UIViewAutoresizingFlexibleRightMargin;
    containerView.layer.shadowOffset = CGSizeMake(0.f, 3.f);
    containerView.layer.shadowRadius = 12.f;
    containerView.layer.shadowOpacity = 0.5f;
    containerView.layer.shadowColor = [[UIColor blackColor] CGColor];
    containerView.layer.shouldRasterize = YES;
    containerView.layer.rasterizationScale = [[UIScreen mainScreen] scale];

    [containerView addSubview:viewController.view];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        containerView.frame = rootViewController.view.bounds;
        containerView.autoresizingMask =
            UIViewAutoresizingFlexibleWidth |
            UIViewAutoresizingFlexibleHeight;
        viewController.view.frame = rootViewController.view.bounds;
    }

    self.bdb_popupViewController = viewController;
    viewController.bdb_popupDimmingView = dimmingView;
    viewController.bdb_popupContainerView = containerView;
    viewController.bdb_popupContentView = viewController.view;

    [rootViewController addChildViewController:viewController];
    [rootViewController.view addSubview:dimmingView];
    [rootViewController.view addSubview:containerView];

    [viewController willMoveToParentViewController:self];
    [self addChildViewController:viewController];
    [viewController didMoveToParentViewController:self];

    [viewController bdb_showPopupWithAnimation:animation completion:completion];
}

- (void)bdb_dismissPopupViewControllerWithAnimation:(BDBPopupViewHideAnimationStyle)animation
                                     completion:(void (^)(void))completion
{
    [self bdb_dismissPopupWithAnimation:animation completion:completion];
}

#pragma mark Animations
- (void)bdb_showPopupWithAnimation:(BDBPopupViewShowAnimationStyle)animation
                        completion:(void (^)(void))completion
{
    UIViewController *rootViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];

    switch (animation) {
        case BDBPopupViewShowAnimationZoomIn: {
            CGPoint center = CGPointMake((rootViewController.view.bounds.size.width - self.bdb_popupContainerView.frame.size.width) / 2.f,
                                         (rootViewController.view.bounds.size.height - self.bdb_popupContainerView.frame.size.height) / 2.f);

            self.bdb_popupContainerView.frame = (CGRect){center, self.bdb_popupContainerView.frame.size};
            self.bdb_popupContainerView.alpha = 0.f;

            [UIView animateWithDuration:0.3f animations:^{
                self.bdb_popupContainerView.alpha = 1.f;
                self.bdb_popupDimmingView.alpha = 1.f;
            }];

            CAKeyframeAnimation *animation =
                [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"
                                                 function:BounceEaseOut
                                                fromValue:0.1f
                                                  toValue:1.f];
            animation.duration = 1.f;
            animation.delegate = [[BDBPopupViewControllerAnimationDelegate alloc] initWithAnimationDidFinishBlock:completion];

            [self.bdb_popupContainerView.layer addAnimation:animation forKey:nil];

            break;
        }
        case BDBPopupViewShowAnimationDropDown: {
            CGSize windowSize = rootViewController.view.bounds.size;
            CGSize containerSize = self.bdb_popupContainerView.bounds.size;

            CGPoint center = CGPointMake((windowSize.width - containerSize.width) / 2.f,
                                         (windowSize.height - containerSize.height) / 2.f);

            CGRect containerStartRect = (CGRect){{(windowSize.width - containerSize.width) / 2.f, -windowSize.height}, containerSize};
            CGRect containerEndRect   = (CGRect){center, containerSize};

            self.bdb_popupContainerView.frame = containerEndRect;

            [UIView animateWithDuration:0.3f animations:^{
                self.bdb_popupDimmingView.alpha = 1.f;
            }];

            CAKeyframeAnimation *animation =
                [CAKeyframeAnimation animationWithKeyPath:@"position.y"
                                                 function:BounceEaseOut
                                                fromValue:containerStartRect.origin.y + containerStartRect.size.height / 2.f
                                                  toValue:containerEndRect.origin.y + containerEndRect.size.height / 2.f];
            animation.duration = 1.f;
            animation.delegate = [[BDBPopupViewControllerAnimationDelegate alloc] initWithAnimationDidFinishBlock:completion];

            [self.bdb_popupContainerView.layer addAnimation:animation forKey:nil];

            break;
        }
        case BDBPopupViewShowAnimationDefault:
        default: {
            CGSize windowSize  = rootViewController.view.bounds.size;
            CGSize containerSize = self.bdb_popupContainerView.bounds.size;

            CGPoint center = CGPointMake((windowSize.width - containerSize.width) / 2.f,
                                         (windowSize.height - containerSize.height) / 2.f);

            CGRect containerStartRect = (CGRect){CGPointMake((windowSize.width - containerSize.width) / 2.f, windowSize.height), containerSize};
            CGRect containerEndRect   = (CGRect){center, containerSize};

            self.bdb_popupContainerView.frame = containerStartRect;

            [UIView animateWithDuration:0.3f
                                  delay:0.f
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 self.bdb_popupContainerView.frame = containerEndRect;
                                 self.bdb_popupDimmingView.alpha = 1.f;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];

            break;
        }
    }
}

- (void)bdb_dismissPopupWithAnimation:(BDBPopupViewHideAnimationStyle)animation
                           completion:(void (^)(void))completion
{
    UIViewController *rootViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];

    switch (animation) {
        case BDBPopupViewHideAnimationZoomOut: {
            [UIView animateWithDuration:0.3f
                             animations:^{
                                 self.bdb_popupViewController.bdb_popupContainerView.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
                                 self.bdb_popupViewController.bdb_popupContainerView.alpha = 0.f;
                                 self.bdb_popupViewController.bdb_popupDimmingView.alpha = 0.f;
                             }
                             completion:^(BOOL finished) {
                                 [self.bdb_popupViewController willMoveToParentViewController:nil];
                                 [self.bdb_popupViewController.bdb_popupContainerView removeFromSuperview];
                                 [self.bdb_popupViewController.bdb_popupDimmingView removeFromSuperview];
                                 [self.bdb_popupViewController removeFromParentViewController];
                                 [self.bdb_popupViewController didMoveToParentViewController:nil];

                                 self.bdb_popupViewController.bdb_popupContainerView = nil;
                                 self.bdb_popupViewController.bdb_popupContentView   = nil;
                                 self.bdb_popupViewController.bdb_popupDimmingView   = nil;
                                 self.bdb_popupViewController = nil;

                                 if (completion) {
                                     completion();
                                 }
                             }];

            break;
        }
        case BDBPopupViewHideAnimationTakeoff: {
            CGSize windowSize    = rootViewController.view.bounds.size;
            CGSize containerSize = self.bdb_popupViewController.bdb_popupContainerView.bounds.size;

            CGRect containerEndRect = (CGRect){CGPointMake((windowSize.width - containerSize.width) / 2.f, -windowSize.height), containerSize};

            [UIView animateWithDuration:0.3f
                                  delay:0.f
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 self.bdb_popupViewController.bdb_popupContainerView.frame = containerEndRect;
                                 self.bdb_popupViewController.bdb_popupDimmingView.alpha = 0.f;
                             }
                             completion:^(BOOL finished) {
                                 [self.bdb_popupViewController willMoveToParentViewController:nil];
                                 [self.bdb_popupViewController.bdb_popupContainerView removeFromSuperview];
                                 [self.bdb_popupViewController.bdb_popupDimmingView removeFromSuperview];
                                 [self.bdb_popupViewController removeFromParentViewController];
                                 [self.bdb_popupViewController didMoveToParentViewController:nil];

                                 self.bdb_popupViewController.bdb_popupContainerView = nil;
                                 self.bdb_popupViewController.bdb_popupContentView   = nil;
                                 self.bdb_popupViewController.bdb_popupDimmingView   = nil;
                                 self.bdb_popupViewController = nil;

                                 if (completion) {
                                     completion();
                                 }
                             }];

            break;
        }
        case BDBPopupViewHideAnimationDefault:
        default: {
            CGSize windowSize    = rootViewController.view.bounds.size;
            CGSize containerSize = self.bdb_popupViewController.bdb_popupContainerView.bounds.size;

            CGRect containerEndRect = (CGRect){CGPointMake((windowSize.width - containerSize.width) / 2.f, windowSize.height), containerSize};

            [UIView animateWithDuration:0.3f
                                  delay:0.f
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 self.bdb_popupViewController.bdb_popupContainerView.frame = containerEndRect;
                                 self.bdb_popupViewController.bdb_popupDimmingView.alpha = 0.f;
                             }
                             completion:^(BOOL finished) {
                                 [self.bdb_popupViewController willMoveToParentViewController:nil];
                                 [self.bdb_popupViewController.bdb_popupContainerView removeFromSuperview];
                                 [self.bdb_popupViewController.bdb_popupDimmingView removeFromSuperview];
                                 [self.bdb_popupViewController removeFromParentViewController];
                                 [self.bdb_popupViewController didMoveToParentViewController:nil];

                                 self.bdb_popupViewController.bdb_popupContainerView = nil;
                                 self.bdb_popupViewController.bdb_popupContentView   = nil;
                                 self.bdb_popupViewController.bdb_popupDimmingView   = nil;
                                 self.bdb_popupViewController = nil;

                                 if (completion) {
                                     completion();
                                 }
                             }];

            break;
        }
    }
}

@end
