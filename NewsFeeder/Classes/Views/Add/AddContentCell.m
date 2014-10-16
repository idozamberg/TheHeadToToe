//
//  AddContentCell.m
//  NewsFeeder
//
//  Created by Harski Technology Holdings Pty. Ltd. on 10/4/13.
//  Copyright (c) 2013 Harski Technology Holdings Pty. Ltd. All rights reserved.
//

#import "AddContentCell.h"

@implementation AddContentCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) setAddContentCellWith:(NewsItemData *)data
{
    [imgvwIcon setImage:[UIImage imageNamed:data.strPhoto]];
    [lblTitle setText:data.strName];
    [lblSubscribes setText:[NSString stringWithFormat:@"%d Subscribes", data.subscribers]];
}

- (IBAction) button_click:(id)sender
{
    if ([sender isEqual:btnAdd]) {
        if (self.delegate) {
            if ([self.delegate respondsToSelector:@selector(willAddFeed:)]) {
                [self.delegate willAddFeed:self];
            }
        };
    }
}


@end
