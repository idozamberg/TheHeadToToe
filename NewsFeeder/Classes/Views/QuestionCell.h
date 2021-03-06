//
//  QuestionCell.h
//  HeadToToe
//
//  Created by ido zamberg on 10/12/14.
//  Copyright (c) 2014 Cristian Ronaldo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdmissionQuestion.h"
#import "YIPopupTextView.H"
#import "AnalyticsManager.h"
#import "XCDYouTubeVideoPlayerViewController.h"

@interface QuestionCell : UITableViewCell <YIPopupTextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblQuestion;
@property (weak, nonatomic) IBOutlet UITextField *txtComment;
@property (weak, nonatomic) IBOutlet UIButton *btnCheck;
@property (weak, nonatomic) IBOutlet UIButton *btnVideo;
@property (strong,nonatomic) AdmissionQuestion* cellModel;
@property (nonatomic)        BOOL   isChecked;
@property (weak, nonatomic) IBOutlet UIImageView *imgCheck;
- (IBAction)videoClicked:(id)sender;

- (IBAction)checkClicked:(id)sender;
- (void) setIsChecked:(BOOL)isChecked;
- (IBAction)commentClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnComment;

@end
