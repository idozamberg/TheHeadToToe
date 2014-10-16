//
//  SettingCell.m
//  NewsFeeder
//
//  Created by Harski Technology Holdings Pty. Ltd. on 10/4/13.
//  Copyright (c) 2013 Harski Technology Holdings Pty. Ltd. All rights reserved.
//

#import "SettingCell.h"

@implementation SettingCell

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

- (void) setCellContentWithTitle:(NSString *)title style:(SETTING_CELL_STYLE)style
{
    [lblTitle setText:title];
    
    if (style == SETTING_CELL_STYLE_CHECK) {
        [imgvwIcon setImage:[UIImage imageNamed:@"setting_cell_checkmark"]];
    }
    else if (style == SETTING_CELL_STYLE_ORDER) {
        [imgvwIcon setImage:[UIImage imageNamed:@"setting_cell_order"]];
    }
    else if (style == SETTING_CELL_STYLE_INDICATOR) {
        [imgvwIcon setImage:[UIImage imageNamed:@"setting_cell_indicator"]];
    }
}

@end
