//
//  FeedBackViewController.h
//  HeadToToe
//
//  Created by ido zamberg on 5/25/15.
//  Copyright (c) 2015 Cristian Ronaldo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomNavViewController.h"

@interface FeedBackViewController : CustomNavViewController <UINavigationControllerDelegate,MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *twFeedbackText;
@property (weak, nonatomic) IBOutlet UIButton *btnFeedback;
- (IBAction)feedbackClicked:(id)sender;

@end
