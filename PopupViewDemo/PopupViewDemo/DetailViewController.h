//
//  DetailViewController.h
//  PopupViewDemo
//
//  Created by Bradley Bergeron on 18/09/2013.
//  Copyright (c) 2013 Bradley David Bergeron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
