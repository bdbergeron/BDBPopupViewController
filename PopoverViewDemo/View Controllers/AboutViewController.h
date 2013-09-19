//
//  AboutViewController.h
//  PopoverViewDemo
//
//  Created by Bradley Bergeron on 18/09/2013.
//  Copyright (c) 2013 Bradley David Bergeron. All rights reserved.
//

#import <UIKit/UIKit.h>


#pragma mark -
@interface AboutViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *websiteLabel;
@property (weak, nonatomic) IBOutlet UILabel *twitterLabel;
@property (weak, nonatomic) IBOutlet UILabel *githubLabel;

- (IBAction)close:(UIButton *)sender;

@end
