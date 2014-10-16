//
//  MenuColorSelectView.h
//  NewsFeeder
//
//  Created by Harski Technology Holdings Pty. Ltd. on 10/4/13.
//  Copyright (c) 2013 Harski Technology Holdings Pty. Ltd. All rights reserved.
//

#import "SuperView.h"

typedef enum {
    THEME_COLOR_TYPE_NONE,
    THEME_COLOR_TYPE_GREEN,
    THEME_COLOR_TYPE_RED,
    THEME_COLOR_TYPE_BLUE,
    THEME_COLOR_TYPE_BLACK,
} THEME_COLOR_TYPE;

@protocol MenuColorSelectViewDelegate;

@interface MenuColorSelectView : SuperView {
    IBOutlet UILabel * lblTitle;
    
    IBOutlet UIView * viewPallete;
    IBOutlet UIButton * btnGreen;
    IBOutlet UIButton * btnRed;
    IBOutlet UIButton * btnBlue;
    IBOutlet UIButton * btnBlack;
}
@property (nonatomic, assign) id<MenuColorSelectViewDelegate> delegate;

- (void) setTitle:(NSString *)title color:(THEME_COLOR_TYPE)color;

- (IBAction) button_click:(id)sender;

@end


@protocol MenuColorSelectViewDelegate <NSObject>

- (void) didSelectColor:(MenuColorSelectView *)msv color:(THEME_COLOR_TYPE)color;

@end
