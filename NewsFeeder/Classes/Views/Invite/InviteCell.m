//
//  InviteCell.m
//  NewsFeeder
//
//  Created by Harski Technology Holdings Pty. Ltd. on 10/4/13.
//  Copyright (c) 2013 Harski Technology Holdings Pty. Ltd. All rights reserved.
//

#import "InviteCell.h"

@implementation InviteCell

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

- (IBAction) button_click:(id)sender
{
    if ([sender isEqual:btnAdd]) {
        if (self.delegate) {
            if ([self.delegate respondsToSelector:@selector(didChooseFriend:)]) {
                [self.delegate didChooseFriend:self];
            }
        }
    }
}

- (void) setInviteCellWith:(InviteItemData *)iid
{
    [lblAddr setText:iid.strAddr];
    [lblName setText:iid.strName];
    
    [imgvwPhoto setImage:[UIImage imageNamed:iid.strPhoto]];
    [imgvwPhoto setRoundedCornersWithRadius:22
                                borderWidth:1
                                borderColor:[UIColor clearColor]];
}

@end
