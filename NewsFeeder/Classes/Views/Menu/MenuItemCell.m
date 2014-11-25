//
//  MenuItemCell.m
//  TapTag
//
//  Created by Harski Technology Holdings Pty. Ltd. on 9/14/13.
//  Copyright (c) 2013 Harski Technology Holdings Pty. Ltd. All rights reserved.
//

#import "MenuItemCell.h"
#import "UIView+Framing.h"

@implementation MenuItemCell

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


#pragma mark --
#pragma mark -- Custom Functions --

- (void) setCellContentWith:(int)type
{
    [lblTitle setText:[gAppDelegate getStringInScreen:SCREEN_MENU
                                                strID:[NSString stringWithFormat:@"CELL_ROW%d", type]]];
    [imgvwPhoto setImage:[UIImage imageNamed: @"menu_cell_icon_pager"]];
}

- (void) setCellContentWith:(int)type andImageName : (NSString*) name
{
    [lblTitle setText:[gAppDelegate getStringInScreen:SCREEN_MENU
                                                strID:[NSString stringWithFormat:@"CELL_ROW%d", type]]];
    [imgvwPhoto setImage:[UIImage imageNamed: name]];
}


- (void) setCellContentWithLabel : (NSString*) text andImageName : (NSString*) name
{
    [lblTitle setText:text];
    [imgvwPhoto setImage:[UIImage imageNamed:name]];
    [imgvwPhoto setContentMode:UIViewContentModeScaleAspectFit];
  //  [imgvwPhoto setHeight:25];
    //[imgvwPhoto setWidth:25];
}

@end
