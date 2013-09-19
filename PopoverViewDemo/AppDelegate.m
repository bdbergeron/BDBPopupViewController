//
//  AppDelegate.m
//  PopoverViewDemo
//
//  Created by Bradley Bergeron on 18/09/2013.
//  Copyright (c) 2013 Bradley David Bergeron. All rights reserved.
//

#import "AppDelegate.h"
#import "BDBAppearance.h"
#import "MainViewController.h"


#pragma mark -
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    [BDBAppearance applyAppearance];

    MainViewController *mainVC = [[MainViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:mainVC];
    self.window.rootViewController = navVC;

    [self.window makeKeyAndVisible];
    return YES;
}

@end
