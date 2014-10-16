//
//  QuestionCell.m
//  HeadToToe
//
//  Created by ido zamberg on 10/12/14.
//  Copyright (c) 2014 Cristian Ronaldo. All rights reserved.
//

#import "QuestionCell.h"
#import "AdmissionQuestion.h"

@implementation QuestionCell

@synthesize isChecked = _isChecked;

- (void)awakeFromNib {
    // Initialization code
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(takeTextDown) name:@"ViewTapped" object:Nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(takeTextDown) name:@"ViewTappedFromInside" object:Nil];

}

- (void) takeTextDown
{
    [self.txtComment resignFirstResponder];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setIsChecked:(BOOL)isChecked
{
    _isChecked = isChecked;
    
    if (self.cellModel.wasChecked)
    {
        self.imgCheck.image = [UIImage imageNamed:@"check-on"];
    }
    else
    {
        self.imgCheck.image = [UIImage imageNamed:@"check-off"];
    }
}


- (IBAction)checkClicked:(id)sender {
    
        if (self.cellModel.wasChecked)
        {
            self.cellModel.wasChecked = NO;
            self.imgCheck.image = [UIImage imageNamed:@"check-off"];
        }
        else
        {
            self.cellModel.wasChecked = YES;
             self.imgCheck.image = [UIImage imageNamed:@"check-on"];
        }
    
    [self.txtComment resignFirstResponder];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ViewTappedFromInside" object:Nil];


}
@end
