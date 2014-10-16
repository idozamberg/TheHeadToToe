//
//  QuestionsHeader.m
//  HeadToToe
//
//  Created by ido zamberg on 10/12/14.
//  Copyright (c) 2014 Cristian Ronaldo. All rights reserved.
//

#import "QuestionsHeader.h"

@implementation QuestionsHeader

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) awakeFromNib
{
    self.isMore = NO;
}

- (void) setTitle:(NSString *)title
{
    
    [_lblTitle setText:title];
}

- (IBAction)moreClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(moreButtonClickedWithSection:)])
    {
        [self.delegate moreButtonClickedWithSection:self.tag];
    }
}

@end
