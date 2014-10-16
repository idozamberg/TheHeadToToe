//
//  QuestionCell.h
//  HeadToToe
//
//  Created by ido zamberg on 10/12/14.
//  Copyright (c) 2014 Cristian Ronaldo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdmissionQuestion.h"

@interface QuestionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblQuestion;
@property (weak, nonatomic) IBOutlet UITextField *txtComment;
@property (weak, nonatomic) IBOutlet UIButton *btnCheck;
@property (strong,nonatomic) AdmissionQuestion* cellModel;
@property (nonatomic)        BOOL   isChecked;
@property (weak, nonatomic) IBOutlet UIImageView *imgCheck;

- (IBAction)checkClicked:(id)sender;
- (void) setIsChecked:(BOOL)isChecked;

@end
