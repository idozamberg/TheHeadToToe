//
//  FeedItemLargeCell.m
//  NewsFeeder
//
//  Created by Harski Technology Holdings Pty. Ltd. on 10/4/13.
//  Copyright (c) 2013 Harski Technology Holdings Pty. Ltd. All rights reserved.
//

#import "FeedItemLargeCell.h"

@implementation FeedItemLargeCell

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

- (void) setFeedItemCell:(NSString *)title desc:(NSString *)desc photo:(NSString *)photo
{
    [lblDesc setText:desc];
    [lblTitle setText:title];
    [imgvwPhoto setImage:[UIImage imageNamed:photo]];
}


@end
