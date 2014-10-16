//
//  SettingOptionCell.h
//  NewsFeeder
//
//  Created by Harski Technology Holdings Pty. Ltd. on 10/4/13.
//  Copyright (c) 2013 Harski Technology Holdings Pty. Ltd. All rights reserved.
//

#import "SuperTableCell.h"

@interface SettingOptionCell : SuperTableCell {
    IBOutlet UILabel * lblTitle;
    IBOutlet UISwitch * option;
}

- (void) setCellContentWithTitle:(NSString *)title on:(BOOL)on;

@end
