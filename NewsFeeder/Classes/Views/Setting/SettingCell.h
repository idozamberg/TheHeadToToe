//
//  SettingCell.h
//  NewsFeeder
//
//  Created by Harski Technology Holdings Pty. Ltd. on 10/4/13.
//  Copyright (c) 2013 Harski Technology Holdings Pty. Ltd. All rights reserved.
//

#import "SuperTableCell.h"

typedef enum {
    SETTING_CELL_STYLE_NONE,
    SETTING_CELL_STYLE_CHECK,
    SETTING_CELL_STYLE_ORDER,
    SETTING_CELL_STYLE_INDICATOR,
} SETTING_CELL_STYLE;

@interface SettingCell : SuperTableCell {
    IBOutlet UILabel * lblTitle;
    IBOutlet UIImageView * imgvwIcon;
}

- (void) setCellContentWithTitle:(NSString *)title style:(SETTING_CELL_STYLE)style;

@end
