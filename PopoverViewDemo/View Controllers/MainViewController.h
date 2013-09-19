//
//  MainViewController.h
//  PopoverViewDemo
//
//  Created by Bradley Bergeron on 18/09/2013.
//  Copyright (c) 2013 Bradley David Bergeron. All rights reserved.
//

#import <UIKit/UIKit.h>


#pragma mark -
@interface MainViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *infoButton;

- (IBAction)showInfo:(UIButton *)sender;

@end
