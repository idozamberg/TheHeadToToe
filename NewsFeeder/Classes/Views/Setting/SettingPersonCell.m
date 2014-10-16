//
//  SettingPersonCell.m
//  NewsFeeder
//
//  Created by Harski Technology Holdings Pty. Ltd. on 10/4/13.
//  Copyright (c) 2013 Harski Technology Holdings Pty. Ltd. All rights reserved.
//

#import "SettingPersonCell.h"

@implementation SettingPersonCell

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

- (void) setCellContentWith:(NSString *)name mail:(NSString *)mail photo:(NSString *)photo
{
    [lblMail setText:mail];
    [lblName setText:name];
    
    [imgvwPhoto setImage:[UIImage imageNamed:photo]];
    [imgvwPhoto setRoundedCornersWithRadius:22
                                borderWidth:1
                                borderColor:[UIColor clearColor]];
}

@end
